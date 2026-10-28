"""CLK104 LMK04828 register derivation: reproduces AMD's two shipped ZCU216 configs (embeddedsw
rfclk xrfclk_LMK_conf.h) wherever the settings coincide, and refuses frequencies the chip cannot
make. Host-pure."""

from __future__ import annotations

from fractions import Fraction

import pytest

from riscq.board.clk104 import _BASE_250, lmk04828_regs, plan, tics_text

# AMD "245M76_PL_122M88_SYSREF_7M68": the fields that differ from the 250 MHz base
AMD_245M76 = {0x100: 0x6A, 0x108: 0x6A, 0x110: 0x6A, 0x118: 0x6A, 0x120: 0x74, 0x128: 0x6A,
              0x130: 0x6A, 0x138: 0x00, 0x13B: 0x40, 0x161: 0x19, 0x162: 0x44, 0x168: 0xC0}
# AMD runs PL_CLK at refclk/2 and picks its own SYSREF; ours runs PL_CLK = dspClk = refclk
OURS_ONLY = {0x120, 0x13A, 0x13B}


def _amd(overrides):
    return [(w >> 8 << 8) | overrides.get(w >> 8, w & 0xFF) for w in _BASE_250]


@pytest.mark.parametrize("freq, amd", [(250, _amd({})), (245.76, _amd(AMD_245M76))])
def test_matches_amd_configs(freq, amd):
    ours = lmk04828_regs(freq)
    assert [w >> 8 for w in ours] == [w >> 8 for w in amd]          # same writes, same order
    diff = {w >> 8 for w, a in zip(ours, amd) if w != a}
    assert diff <= OURS_ONLY


@pytest.mark.parametrize("freq", [430, 425, 400, 475, 500])
def test_plan_hits_freq(freq):
    c = plan(freq)
    lo, hi = ((2370, 2630), (2920, 3080))[c["vco_sel"]]
    assert lo <= c["vco_mhz"] <= hi
    assert Fraction(160, c["r"]) * c["p"] * c["n"] == c["vco_mhz"] == freq * c["div"]
    k = freq / c["sysref_mhz"]
    assert k == int(k) and int(k) % 2 == 0 and c["sysref_mhz"] <= 10


def test_430():
    c = plan(430)
    assert (c["vco_mhz"], c["vco_sel"], c["div"], c["r"], c["p"], c["n"]) == (2580, 0, 6, 8, 3, 43)
    regs = dict((w >> 8, w & 0xFF) for w in lmk04828_regs(430))
    assert regs[0x100] == regs[0x120] == 0x66 and regs[0x161] == 8 and regs[0x168] == 43
    assert tics_text(430).splitlines()[0] == "R0\t0x000090"


@pytest.mark.parametrize("freq", [450, 460, 470])
def test_unreachable(freq):
    with pytest.raises(ValueError, match="cannot make"):
        plan(freq)
