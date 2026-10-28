"""CLK104 (the ZCU216's clock card) LMK04828 register sets for any dspClk the chip can make.

xrfclk only knows the TICS register files shipped in its package dir, so a build at a new dspClk
(params.json `dsp_freq_hz`) has no LMK config. This derives one from AMD's own CLK104 table
(embeddedsw rfclk `xrfclk_LMK_conf.h`, "250M_PL_125M_SYSREF_10M", MIT) by changing only the
fields that differ between AMD's two shipped configs:

    VCO = 160 MHz (VCXO on OSCin) / PLL2_R * PLL2_P * PLL2_N     (VCO_MUX: VCO0 or VCO1)
    DCLKout0/2/4/6/10/12 (DAC/ADC refclk, LMX inputs) = VCO / DIV = dspClk   (tile-2 PLL refs)
    DCLKout8 (PL_CLK -> dspClk pins)                    = VCO / DIV = dspClk
    SYSREF (RF + PL)                                    = VCO / SYSREF_DIV = dspClk / k

Pure python (no pynq): `PynqDriver.refclks` registers the result with xrfclk on the board."""

from __future__ import annotations

from fractions import Fraction

OSCIN_MHZ = 160
VCO_RANGES = ((2370, 2630), (2920, 3080))   # LMK04828 VCO0 / VCO1, MHz
PFD_MAX_MHZ = 155
SYSREF_MAX_MHZ = 10

# AMD's "250M_PL_125M_SYSREF_10M" (VCO1 3000 MHz = 160/4*3*25; refclks /12, PL /24, SYSREF /300),
# in write order. Each entry is (addr << 8) | data.
_BASE_250 = (
    0x000090, 0x000010, 0x000200, 0x000306, 0x0004D0, 0x00055B, 0x000600, 0x000C51,
    0x000D04, 0x01006C, 0x010155, 0x010255, 0x010301, 0x010422, 0x010500, 0x010673,
    0x010703, 0x01086C, 0x010955, 0x010A55, 0x010B00, 0x010C22, 0x010D00, 0x010EF0,
    0x010F30, 0x01106C, 0x011155, 0x011255, 0x011301, 0x011422, 0x011500, 0x011673,
    0x011703, 0x01186C, 0x011955, 0x011A55, 0x011B01, 0x011C22, 0x011D00, 0x011E72,
    0x011F03, 0x012078, 0x012155, 0x012255, 0x012301, 0x012422, 0x012500, 0x012670,
    0x012733, 0x01286C, 0x012955, 0x012A55, 0x012B00, 0x012C22, 0x012D00, 0x012EF0,
    0x012F30, 0x01306C, 0x013155, 0x013255, 0x013301, 0x013422, 0x013500, 0x013673,
    0x013703, 0x013820, 0x013903, 0x013A01, 0x013B2C, 0x013C00, 0x013D01, 0x013E03,
    0x013F02, 0x014009, 0x014100, 0x014200, 0x014331, 0x0144FF, 0x01457F, 0x014618,
    0x01471A, 0x014806, 0x014946, 0x014A06, 0x014B06, 0x014C00, 0x014D00, 0x014EC0,
    0x014F7F, 0x015013, 0x015102, 0x015200, 0x015300, 0x01547D, 0x015500, 0x01567D,
    0x015703, 0x0158C0, 0x015907, 0x015AD0, 0x015BDA, 0x015C20, 0x015D00, 0x015E00,
    0x015F3E, 0x016000, 0x016104, 0x016264, 0x016300, 0x016400, 0x0165A0, 0x0171AA,
    0x017202, 0x017C15, 0x017D33, 0x016600, 0x016700, 0x016819, 0x016959, 0x016A20,
    0x016B00, 0x016C00, 0x016D00, 0x016E1B, 0x017300, 0x1FFD00, 0x1FFE00, 0x1FFF53,
)
_DCLK_DIV_REGS = (0x100, 0x108, 0x110, 0x118, 0x120, 0x128, 0x130)   # DCLKout0..12 (8 = PL_CLK)


def plan(freq_mhz: float) -> dict:
    """The LMK04828 settings for dspClk = `freq_mhz`: highest PLL2 phase-detector rate first (the
    rule both AMD configs follow), then the smaller P. Raises ValueError if no VCO / divider pair
    hits `freq_mhz` exactly (e.g. ~440-474 MHz lies between VCO1/7 and VCO0/5)."""
    f = Fraction(str(freq_mhz))
    best = None
    for div in range(1, 33):
        vco = f * div
        for vco_sel, (lo, hi) in enumerate(VCO_RANGES):
            if not lo <= vco <= hi:
                continue
            for r in range(1, 4096):
                pfd = Fraction(OSCIN_MHZ, r)
                if pfd > PFD_MAX_MHZ:
                    continue
                pn = vco / pfd
                if pn.denominator != 1:
                    continue
                p = next((p for p in range(2, 9) if pn % p == 0 and pn // p < 1 << 18), None)
                if p is None:
                    continue
                key = (pfd, vco_sel)
                if best is None or key > best[0]:
                    best = (key, dict(vco_mhz=vco, vco_sel=vco_sel, div=div, r=r, p=p,
                                      n=int(pn // p)))
                break
    if best is None:
        raise ValueError(f"LMK04828 cannot make {freq_mhz} MHz: no VCO0 (2370-2630) / VCO1 "
                         f"(2920-3080) multiple of it divides by 1..32 with an integer PLL2")
    cfg = best[1]
    k = -(-f // SYSREF_MAX_MHZ)              # SYSREF = dspClk / k with k even, so it also divides
    k += k % 2                               # the ADC fabric clock (dspClk / 2) for MTS
    cfg.update(sysref_div=cfg["div"] * int(k), sysref_mhz=f / k)
    return cfg


def lmk04828_regs(freq_mhz: float) -> list[int]:
    """The 128 register writes (xrfclk order) for dspClk = `freq_mhz` on every refclk + PL_CLK."""
    c = plan(freq_mhz)
    field = {a: c["div"] & 0x1F for a in _DCLK_DIV_REGS}         # DIV 32 encodes as 0
    out = []
    for w in _BASE_250:
        addr, data = w >> 8, w & 0xFF
        if addr in field:
            data = (data & 0xE0) | field[addr]
        elif addr == 0x138:
            data = (data & ~0x60 & 0xFF) | (c["vco_sel"] << 5)    # VCO_MUX
        elif addr == 0x13A:
            data = (data & 0xE0) | (c["sysref_div"] >> 8)
        elif addr == 0x13B:
            data = c["sysref_div"] & 0xFF
        elif addr == 0x160:
            data = (data & 0xF0) | (c["r"] >> 8)
        elif addr == 0x161:
            data = c["r"] & 0xFF
        elif addr == 0x162:
            data = (data & 0x1F) | ((c["p"] & 7) << 5)            # P = 8 encodes as 0
        elif addr == 0x166:
            data = (data & 0xFC) | (c["n"] >> 16)
        elif addr == 0x167:
            data = (c["n"] >> 8) & 0xFF
        elif addr == 0x168:
            data = c["n"] & 0xFF
        out.append((addr << 8) | data)
    return out


def tics_text(freq_mhz: float) -> str:
    """The same registers as a TICS Pro export (`LMK04828_<freq>.txt` in xrfclk's package dir)."""
    return "".join(f"R{w >> 8}\t0x{w:06X}\n" for w in lmk04828_regs(freq_mhz))
