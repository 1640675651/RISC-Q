/* Block copies to and from the PL's AXI window, one 32-bit beat per word.
 *
 * The gateware's host ports accept single 32-bit beats only: a wider or multi-beat access (what a
 * memcpy or a numpy slice copy may emit) gets DECERR and the process dies with SIGBUS. `volatile`
 * pins every access to exactly one 32-bit load or store, in order, so these loops put the same
 * transactions on the bus as pynq.MMIO's word loop, without the Python interpreter in between.
 *
 * Built on the board on first use by riscq.board.fastmmio (gcc -O2 -shared -fPIC).
 */
#include <stddef.h>
#include <stdint.h>

void riscq_mmio_write32(volatile uint32_t *dst, const uint32_t *src, size_t nwords) {
    for (size_t i = 0; i < nwords; i++) dst[i] = src[i];
}

void riscq_mmio_read32(uint32_t *dst, const volatile uint32_t *src, size_t nwords) {
    for (size_t i = 0; i < nwords; i++) dst[i] = src[i];
}

/* Many blocks in one call: segment i is lens[i] words at base + offs[i]; the words of all segments
 * are packed back to back in `words`. One call per dispatch instead of one per block. */
void riscq_mmio_write_segs(uint8_t *base, const uint32_t *words, const uint64_t *offs,
                           const uint32_t *lens, size_t nseg) {
    for (size_t s = 0; s < nseg; s++) {
        volatile uint32_t *dst = (volatile uint32_t *)(base + offs[s]);
        for (uint32_t i = 0; i < lens[s]; i++) dst[i] = *words++;
    }
}

void riscq_mmio_read_segs(uint8_t *base, uint32_t *words, const uint64_t *offs,
                          const uint32_t *lens, size_t nseg) {
    for (size_t s = 0; s < nseg; s++) {
        const volatile uint32_t *src = (const volatile uint32_t *)(base + offs[s]);
        for (uint32_t i = 0; i < lens[s]; i++) *words++ = src[i];
    }
}

/* Write only what changes. Each segment carries a pointer to the caller's shadow of that RAM (the
 * words last written and whether each is known); a word goes on the bus only when it is unknown
 * or differs, and the shadow is updated. Returns the number of words written. The caller must
 * route every write to a shadowed region through here, or the shadow goes stale. */
size_t riscq_mmio_write_segs_delta(uint8_t *base, const uint32_t *words, const uint64_t *offs,
                                   const uint32_t *lens, const uint64_t *shadow,
                                   const uint64_t *known, size_t nseg) {
    size_t written = 0;
    for (size_t s = 0; s < nseg; s++) {
        volatile uint32_t *dst = (volatile uint32_t *)(base + offs[s]);
        uint32_t *sh = (uint32_t *)(uintptr_t)shadow[s];
        uint8_t *kn = (uint8_t *)(uintptr_t)known[s];
        for (uint32_t i = 0; i < lens[s]; i++) {
            uint32_t w = *words++;
            if (!kn[i] || sh[i] != w) { dst[i] = w; sh[i] = w; kn[i] = 1; written++; }
        }
    }
    return written;
}
