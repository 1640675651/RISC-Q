"""Native block read / write for the PL's AXI window (board only).

`pynq.MMIO.write(addr, bytes)` and word-at-a-time reads loop in Python: about 2.5 us per 32-bit
word, 1.6 MB/s, which makes loading a program's envelopes the dominant cost of a dispatch. The
same single-beat 32-bit transactions issued from a C loop (fastmmio.c) run at the bus's own speed.

The shared object is compiled on the board on first use and cached under ~/.cache/riscq/, keyed
by the source's hash. `load()` returns None when there is no compiler; callers then keep the
Python word loop.
"""

from __future__ import annotations

import ctypes
import hashlib
import logging
import os
import shutil
import subprocess
from pathlib import Path

log = logging.getLogger("riscq.board")

_SRC = Path(__file__).with_name("fastmmio.c")
_lib = None
_tried = False


def load():
    """The compiled helper (a ctypes CDLL), or None if it cannot be built here."""
    global _lib, _tried
    if _tried:
        return _lib
    _tried = True
    try:
        cc = shutil.which("gcc") or shutil.which("cc")
        if cc is None:
            raise RuntimeError("no C compiler on PATH")
        src = _SRC.read_bytes()
        cache = Path(os.environ.get("RISCQ_CACHE", Path.home() / ".cache" / "riscq"))
        cache.mkdir(parents=True, exist_ok=True)
        so = cache / f"fastmmio-{hashlib.sha256(src).hexdigest()[:12]}.so"
        if not so.exists():
            tmp = so.with_suffix(f".{os.getpid()}.tmp")
            subprocess.run([cc, "-O2", "-shared", "-fPIC", "-o", str(tmp), str(_SRC)],
                           check=True, capture_output=True, text=True)
            tmp.replace(so)
        lib = ctypes.CDLL(str(so))
        for fn in (lib.riscq_mmio_write32, lib.riscq_mmio_read32):
            fn.argtypes = (ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t)
            fn.restype = None
        for fn in (lib.riscq_mmio_write_segs, lib.riscq_mmio_read_segs):
            fn.argtypes = (ctypes.c_void_p,) * 4 + (ctypes.c_size_t,)
            fn.restype = None
        lib.riscq_mmio_write_segs_delta.argtypes = (ctypes.c_void_p,) * 6 + (ctypes.c_size_t,)
        lib.riscq_mmio_write_segs_delta.restype = ctypes.c_size_t
        _lib = lib
        log.info(f"fast MMIO: {so.name}")
    except Exception as e:                       # the Python word loop still works
        log.warning(f"fast MMIO unavailable ({e}); block I/O falls back to the Python word loop")
        _lib = None
    return _lib


def write_words(lib, base_ptr: int, offset: int, data: bytes) -> None:
    """Write `data` (a multiple of 4 bytes, little-endian words) at `base_ptr + offset`."""
    buf = (ctypes.c_uint32 * (len(data) // 4)).from_buffer_copy(data)
    lib.riscq_mmio_write32(base_ptr + offset, buf, len(data) // 4)


def read_words(lib, base_ptr: int, offset: int, nwords: int) -> bytes:
    buf = (ctypes.c_uint32 * nwords)()
    lib.riscq_mmio_read32(buf, base_ptr + offset, nwords)
    return bytes(buf)


def write_segments(lib, base_ptr: int, offs, lens, words) -> None:
    """Write many blocks in one call. `offs` (uint64, byte offsets), `lens` (uint32, words per
    block) and `words` (uint32, all blocks back to back) are contiguous numpy arrays."""
    lib.riscq_mmio_write_segs(base_ptr, words.ctypes.data, offs.ctypes.data, lens.ctypes.data, len(offs))


def read_segments(lib, base_ptr: int, offs, lens):
    """Read many blocks in one call; returns one uint32 array, the blocks back to back."""
    import numpy as np
    out = np.empty(int(lens.sum()), dtype=np.uint32)
    lib.riscq_mmio_read_segs(base_ptr, out.ctypes.data, offs.ctypes.data, lens.ctypes.data, len(offs))
    return out


def write_segments_delta(lib, base_ptr: int, offs, lens, words, shadow, known) -> int:
    """`write_segments`, skipping words equal to the caller's shadow. `shadow` / `known` hold, per
    block, the address of that block's uint32 shadow words and uint8 known flags (uint64 arrays).
    Returns the number of words written."""
    return int(lib.riscq_mmio_write_segs_delta(base_ptr, words.ctypes.data, offs.ctypes.data,
                                               lens.ctypes.data, shadow.ctypes.data,
                                               known.ctypes.data, len(offs)))
