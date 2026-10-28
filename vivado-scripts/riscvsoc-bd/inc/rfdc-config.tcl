# RF Data Converter configuration — verbatim from the RISC-Q reference (utils/rfdc.tcl): all four DAC
# and ADC tiles enabled, DACs at 8 GSPS (×1 interpolation, 16 samples/AXIS word = 256 bit), ADCs at
# 2 GSPS (×1 decimation, 4 samples/AXIS word = 64 bit), coarse mixers, multi-tile sync.
set_property -dict {
CONFIG.ADC0_Clock_Dist {0}
CONFIG.ADC0_Clock_Source {2}
CONFIG.ADC0_Enable {1}
CONFIG.ADC0_Link_Coupling {0}
CONFIG.ADC0_Multi_Tile_Sync {true}
CONFIG.ADC0_Outclk_Freq {250.000}
CONFIG.ADC0_PLL_Enable {false}
CONFIG.ADC0_Refclk_Freq {2000.000}
CONFIG.ADC0_Sampling_Rate {2.000}
CONFIG.ADC1_Clock_Dist {0}
CONFIG.ADC1_Clock_Source {2}
CONFIG.ADC1_Enable {1}
CONFIG.ADC1_Link_Coupling {0}
CONFIG.ADC1_Multi_Tile_Sync {true}
CONFIG.ADC1_Outclk_Freq {250.000}
CONFIG.ADC1_PLL_Enable {false}
CONFIG.ADC1_Refclk_Freq {2000.000}
CONFIG.ADC1_Sampling_Rate {2.000}
CONFIG.ADC2_Clock_Dist {2}
CONFIG.ADC2_Clock_Source {2}
CONFIG.ADC2_Enable {1}
CONFIG.ADC2_Link_Coupling {0}
CONFIG.ADC2_Multi_Tile_Sync {true}
CONFIG.ADC2_Outclk_Freq {250.000}
CONFIG.ADC2_PLL_Enable {true}
CONFIG.ADC2_Refclk_Freq {500.000}
CONFIG.ADC2_Sampling_Rate {2.000}
CONFIG.ADC3_Clock_Dist {0}
CONFIG.ADC3_Clock_Source {2}
CONFIG.ADC3_Enable {1}
CONFIG.ADC3_Link_Coupling {0}
CONFIG.ADC3_Multi_Tile_Sync {true}
CONFIG.ADC3_Outclk_Freq {250.000}
CONFIG.ADC3_PLL_Enable {false}
CONFIG.ADC3_Refclk_Freq {2000.000}
CONFIG.ADC3_Sampling_Rate {2.000}
CONFIG.ADC_Coarse_Mixer_Freq00 {3}
CONFIG.ADC_Data_Width00 {4}
CONFIG.ADC_Decimation_Mode00 {1}
CONFIG.ADC_Dither00 {false}
CONFIG.ADC_Mixer_Type00 {1}
CONFIG.ADC_OBS00 {0}
CONFIG.ADC_Slice00_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq01 {3}
CONFIG.ADC_Data_Width01 {4}
CONFIG.ADC_Decimation_Mode01 {1}
CONFIG.ADC_Dither01 {false}
CONFIG.ADC_Mixer_Type01 {1}
CONFIG.ADC_OBS01 {0}
CONFIG.ADC_Slice01_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq02 {3}
CONFIG.ADC_Data_Width02 {4}
CONFIG.ADC_Decimation_Mode02 {1}
CONFIG.ADC_Dither02 {false}
CONFIG.ADC_Mixer_Type02 {1}
CONFIG.ADC_OBS02 {0}
CONFIG.ADC_Slice02_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq03 {3}
CONFIG.ADC_Data_Width03 {4}
CONFIG.ADC_Decimation_Mode03 {1}
CONFIG.ADC_Dither03 {false}
CONFIG.ADC_Mixer_Type03 {1}
CONFIG.ADC_OBS03 {0}
CONFIG.ADC_Slice03_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq10 {3}
CONFIG.ADC_Data_Width10 {4}
CONFIG.ADC_Decimation_Mode10 {1}
CONFIG.ADC_Dither10 {false}
CONFIG.ADC_Mixer_Type10 {1}
CONFIG.ADC_OBS10 {0}
CONFIG.ADC_Slice10_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq11 {3}
CONFIG.ADC_Data_Width11 {4}
CONFIG.ADC_Decimation_Mode11 {1}
CONFIG.ADC_Dither11 {false}
CONFIG.ADC_Mixer_Type11 {1}
CONFIG.ADC_OBS11 {0}
CONFIG.ADC_Slice11_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq12 {3}
CONFIG.ADC_Data_Width12 {4}
CONFIG.ADC_Decimation_Mode12 {1}
CONFIG.ADC_Dither12 {false}
CONFIG.ADC_Mixer_Type12 {1}
CONFIG.ADC_OBS12 {0}
CONFIG.ADC_Slice12_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq13 {3}
CONFIG.ADC_Data_Width13 {4}
CONFIG.ADC_Decimation_Mode13 {1}
CONFIG.ADC_Dither13 {false}
CONFIG.ADC_Mixer_Type13 {1}
CONFIG.ADC_OBS13 {0}
CONFIG.ADC_Slice13_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq20 {3}
CONFIG.ADC_Data_Width20 {4}
CONFIG.ADC_Decimation_Mode20 {1}
CONFIG.ADC_Dither20 {false}
CONFIG.ADC_Mixer_Type20 {1}
CONFIG.ADC_OBS20 {0}
CONFIG.ADC_Slice20_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq21 {3}
CONFIG.ADC_Data_Width21 {4}
CONFIG.ADC_Decimation_Mode21 {1}
CONFIG.ADC_Dither21 {false}
CONFIG.ADC_Mixer_Type21 {1}
CONFIG.ADC_OBS21 {0}
CONFIG.ADC_Slice21_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq22 {3}
CONFIG.ADC_Data_Width22 {4}
CONFIG.ADC_Decimation_Mode22 {1}
CONFIG.ADC_Dither22 {false}
CONFIG.ADC_Mixer_Type22 {1}
CONFIG.ADC_OBS22 {0}
CONFIG.ADC_Slice22_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq23 {3}
CONFIG.ADC_Data_Width23 {4}
CONFIG.ADC_Decimation_Mode23 {1}
CONFIG.ADC_Dither23 {false}
CONFIG.ADC_Mixer_Type23 {1}
CONFIG.ADC_OBS23 {0}
CONFIG.ADC_Slice23_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq30 {3}
CONFIG.ADC_Data_Width30 {4}
CONFIG.ADC_Decimation_Mode30 {1}
CONFIG.ADC_Dither30 {false}
CONFIG.ADC_Mixer_Type30 {1}
CONFIG.ADC_OBS30 {0}
CONFIG.ADC_Slice30_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq31 {3}
CONFIG.ADC_Data_Width31 {4}
CONFIG.ADC_Decimation_Mode31 {1}
CONFIG.ADC_Dither31 {false}
CONFIG.ADC_Mixer_Type31 {1}
CONFIG.ADC_OBS31 {0}
CONFIG.ADC_Slice31_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq32 {3}
CONFIG.ADC_Data_Width32 {4}
CONFIG.ADC_Decimation_Mode32 {1}
CONFIG.ADC_Dither32 {false}
CONFIG.ADC_Mixer_Type32 {1}
CONFIG.ADC_OBS32 {0}
CONFIG.ADC_Slice32_Enable {true}
CONFIG.ADC_Coarse_Mixer_Freq33 {3}
CONFIG.ADC_Data_Width33 {4}
CONFIG.ADC_Decimation_Mode33 {1}
CONFIG.ADC_Dither33 {false}
CONFIG.ADC_Mixer_Type33 {1}
CONFIG.ADC_OBS33 {0}
CONFIG.ADC_Slice33_Enable {true}
CONFIG.DAC0_Clock_Source {6}
CONFIG.DAC0_Enable {1}
CONFIG.DAC0_Link_Coupling {0}
CONFIG.DAC0_Multi_Tile_Sync {true}
CONFIG.DAC0_Outclk_Freq {500.000}
CONFIG.DAC0_PLL_Enable {false}
CONFIG.DAC0_Refclk_Freq {8000.000}
CONFIG.DAC0_Sampling_Rate {8.000}
CONFIG.DAC0_Clock_Dist {0}
CONFIG.DAC1_Clock_Source {6}
CONFIG.DAC1_Enable {1}
CONFIG.DAC1_Link_Coupling {0}
CONFIG.DAC1_Multi_Tile_Sync {true}
CONFIG.DAC1_Outclk_Freq {500.000}
CONFIG.DAC1_PLL_Enable {false}
CONFIG.DAC1_Refclk_Freq {8000.000}
CONFIG.DAC1_Sampling_Rate {8.000}
CONFIG.DAC1_Clock_Dist {0}
CONFIG.DAC2_Clock_Source {6}
CONFIG.DAC2_Enable {1}
CONFIG.DAC2_Link_Coupling {0}
CONFIG.DAC2_Multi_Tile_Sync {true}
CONFIG.DAC2_Outclk_Freq {500.000}
CONFIG.DAC2_PLL_Enable {true}
CONFIG.DAC2_Refclk_Freq {500.000}
CONFIG.DAC2_Sampling_Rate {8.000}
CONFIG.DAC2_Clock_Dist {2}
CONFIG.DAC3_Clock_Source {6}
CONFIG.DAC3_Enable {1}
CONFIG.DAC3_Link_Coupling {0}
CONFIG.DAC3_Multi_Tile_Sync {true}
CONFIG.DAC3_Outclk_Freq {500.000}
CONFIG.DAC3_PLL_Enable {false}
CONFIG.DAC3_Refclk_Freq {8000.000}
CONFIG.DAC3_Sampling_Rate {8.000}
CONFIG.DAC3_Clock_Dist {0}
CONFIG.DAC_Coarse_Mixer_Freq00 {3}
CONFIG.DAC_Interpolation_Mode00 {1}
CONFIG.DAC_Mixer_Type00 {1}
CONFIG.DAC_Mode00 {3}
CONFIG.DAC_Nyquist00 {0}
CONFIG.DAC_Slice00_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq01 {3}
CONFIG.DAC_Interpolation_Mode01 {1}
CONFIG.DAC_Mixer_Type01 {1}
CONFIG.DAC_Mode01 {3}
CONFIG.DAC_Nyquist01 {0}
CONFIG.DAC_Slice01_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq02 {3}
CONFIG.DAC_Interpolation_Mode02 {1}
CONFIG.DAC_Mixer_Type02 {1}
CONFIG.DAC_Mode02 {3}
CONFIG.DAC_Nyquist02 {0}
CONFIG.DAC_Slice02_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq03 {3}
CONFIG.DAC_Interpolation_Mode03 {1}
CONFIG.DAC_Mixer_Type03 {1}
CONFIG.DAC_Mode03 {3}
CONFIG.DAC_Nyquist03 {0}
CONFIG.DAC_Slice03_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq10 {3}
CONFIG.DAC_Interpolation_Mode10 {1}
CONFIG.DAC_Mixer_Type10 {1}
CONFIG.DAC_Mode10 {3}
CONFIG.DAC_Nyquist10 {0}
CONFIG.DAC_Slice10_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq11 {3}
CONFIG.DAC_Interpolation_Mode11 {1}
CONFIG.DAC_Mixer_Type11 {1}
CONFIG.DAC_Mode11 {3}
CONFIG.DAC_Nyquist11 {0}
CONFIG.DAC_Slice11_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq12 {3}
CONFIG.DAC_Interpolation_Mode12 {1}
CONFIG.DAC_Mixer_Type12 {1}
CONFIG.DAC_Mode12 {3}
CONFIG.DAC_Nyquist12 {0}
CONFIG.DAC_Slice12_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq13 {3}
CONFIG.DAC_Interpolation_Mode13 {1}
CONFIG.DAC_Mixer_Type13 {1}
CONFIG.DAC_Mode13 {3}
CONFIG.DAC_Nyquist13 {0}
CONFIG.DAC_Slice13_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq20 {3}
CONFIG.DAC_Interpolation_Mode20 {1}
CONFIG.DAC_Mixer_Type20 {1}
CONFIG.DAC_Mode20 {3}
CONFIG.DAC_Nyquist20 {0}
CONFIG.DAC_Slice20_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq21 {3}
CONFIG.DAC_Interpolation_Mode21 {1}
CONFIG.DAC_Mixer_Type21 {1}
CONFIG.DAC_Mode21 {3}
CONFIG.DAC_Nyquist21 {0}
CONFIG.DAC_Slice21_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq22 {3}
CONFIG.DAC_Interpolation_Mode22 {1}
CONFIG.DAC_Mixer_Type22 {1}
CONFIG.DAC_Mode22 {3}
CONFIG.DAC_Nyquist22 {0}
CONFIG.DAC_Slice22_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq23 {3}
CONFIG.DAC_Interpolation_Mode23 {1}
CONFIG.DAC_Mixer_Type23 {1}
CONFIG.DAC_Mode23 {3}
CONFIG.DAC_Nyquist23 {0}
CONFIG.DAC_Slice23_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq30 {3}
CONFIG.DAC_Interpolation_Mode30 {1}
CONFIG.DAC_Mixer_Type30 {1}
CONFIG.DAC_Mode30 {3}
CONFIG.DAC_Nyquist30 {0}
CONFIG.DAC_Slice30_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq31 {3}
CONFIG.DAC_Interpolation_Mode31 {1}
CONFIG.DAC_Mixer_Type31 {1}
CONFIG.DAC_Mode31 {3}
CONFIG.DAC_Nyquist31 {0}
CONFIG.DAC_Slice31_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq32 {3}
CONFIG.DAC_Interpolation_Mode32 {1}
CONFIG.DAC_Mixer_Type32 {1}
CONFIG.DAC_Mode32 {3}
CONFIG.DAC_Nyquist32 {0}
CONFIG.DAC_Slice32_Enable {true}
CONFIG.DAC_Coarse_Mixer_Freq33 {3}
CONFIG.DAC_Interpolation_Mode33 {1}
CONFIG.DAC_Mixer_Type33 {1}
CONFIG.DAC_Mode33 {3}
CONFIG.DAC_Nyquist33 {0}
CONFIG.DAC_Slice33_Enable {true}
} $RFDC_TARGET

# dspClk ≠ 500 MHz: scale the converter clocking with it — a DAC AXIS word is 16 samples and an ADC word
# 4 per dspClk, so DAC Fs = 16·f and ADC Fs = 4·f. ADC tile 2 runs its PLL from an f reference and
# distributes. The DAC PLL can't reach 16·f below 500 MHz (7.6 GS/s at 475: the IP only accepts a 7600 MHz
# refclk), so DAC tile 2 takes the sample clock directly (PLL off, from the board's LMX) and distributes
# that input clock (Clock_Dist 1); the other tiles take the distributed sample clock as before.
# DAC_DIRECT: DAC tile 2 takes its 16x sample clock straight from the refclk pins (PLL bypassed).
# The tile PLL can only make DAC rates up to ~6.88 GS/s (dspClk <= 430 MHz) or from ~7.9 GS/s
# (dspClk >= ~492 MHz); in between the clock must arrive at the full rate. On the ZCU216 + CLK104,
# DAC tile 2's refclk comes from the LMK04828 (<= ~3 GHz), so a DAC_DIRECT build needs board rework.
set DAC_DIRECT 0
if {$DSP_FREQ != 500e6} {
  set _f [expr {$DSP_FREQ / 1e6}]
  set DAC_DIRECT [expr {16 * $_f > 6880.0 && 16 * $_f < 7900.0}]
  set _cfg [expr {$DAC_DIRECT ? [list CONFIG.DAC2_PLL_Enable false CONFIG.DAC2_Clock_Dist 1] : {}}]
  if {$DAC_DIRECT} {
    puts "CRITICAL WARNING: \[rfdc-config\] DAC [expr {16 * $_f}] MHz is outside the tile PLL's range: DAC tile 2 needs that rate on its refclk pins, which the CLK104 cannot supply"
  }
  for {set _t 0} {$_t < 4} {incr _t} {
    set _pll [expr {$_t == 2}]
    lappend _cfg \
      CONFIG.DAC${_t}_Sampling_Rate [format %.3f [expr {16 * $_f / 1000.0}]] \
      CONFIG.DAC${_t}_Refclk_Freq   [format %.3f [expr {$_pll && !$DAC_DIRECT ? $_f : 16 * $_f}]] \
      CONFIG.DAC${_t}_Outclk_Freq   [format %.3f $_f] \
      CONFIG.ADC${_t}_Sampling_Rate [format %.3f [expr {4 * $_f / 1000.0}]] \
      CONFIG.ADC${_t}_Refclk_Freq   [format %.3f [expr {$_pll ? $_f : 4 * $_f}]] \
      CONFIG.ADC${_t}_Outclk_Freq   [format %.3f [expr {$_f / 2}]]
  }
  puts "\[rfdc-config\] dspClk $_f MHz → DAC [format %.3f [expr {16 * $_f / 1000.0}]] GS/s ([expr {$DAC_DIRECT ? {direct refclk} : {tile-2 PLL}}]), ADC [format %.3f [expr {4 * $_f / 1000.0}]] GS/s"
  set_property -dict $_cfg $RFDC_TARGET
  # changing the rates resets each tile's Clock_Source to its own tile (own refclk pins); point tiles
  # 0/1/3 back at tile 2's distributed clock (ADC source 2 = ADC tile 2, DAC source 6 = DAC tile 2)
  set _src {}
  foreach _t {0 1 3} { lappend _src CONFIG.ADC${_t}_Clock_Source 2 CONFIG.DAC${_t}_Clock_Source 6 }
  set_property -dict $_src $RFDC_TARGET
}
