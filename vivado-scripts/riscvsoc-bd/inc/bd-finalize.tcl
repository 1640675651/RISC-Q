# ---- Validate, generate the HDL wrapper, add constraints, set the top ------------------------------
validate_bd_design
set WR_BUILD [llength [get_bd_ports -quiet wrRefClkP]]   ;# White Rabbit ports present? (query pre-close)

make_wrapper -files [get_files $BD_NAME.bd] -top -import -force
generate_target all [get_files $BD_NAME.bd]
close_bd_design $BD_NAME

set_property top ${BD_NAME}_wrapper [current_fileset]

if {[file exists $SCRIPT_DIR/constraints-zcu216.xdc]} {
  set _xdc $SCRIPT_DIR/constraints-zcu216.xdc
  if {$DSP_FREQ != 500e6} {
    # rewrite the 2.000 ns periods for this build into a per-build copy: dspClk and the tile-2
    # references run at dspClk rate, except a DAC_DIRECT DAC tile 2 input, the 16× sample clock
    # (rfdc-config.tcl)
    set _fh [open $_xdc r]; set _txt [read $_fh]; close $_fh
    set _per [format %.3f [expr {1e9 / $DSP_FREQ}]]
    if {$DAC_DIRECT} {
      set _dacPer [format %.4f [expr {1e9 / (16.0 * $DSP_FREQ)}]]
      set _txt [string map [list "-period 2.000 -name dac_clk_clk_p" "-period $_dacPer -name dac_clk_clk_p"] $_txt]
    }
    set _txt [string map [list "-period 2.000 " "-period $_per "] $_txt]
    set _xdc $BUILD_DIR/constraints-zcu216.xdc
    set _fh [open $_xdc w]; puts -nonewline $_fh $_txt; close $_fh
    puts "\[bd-finalize\] dspClk ${DSP_FREQ} Hz → clock periods $_per ns ($_xdc)"
  }
  add_files -fileset constrs_1 -norecurse $_xdc
}
# White Rabbit builds (the BD grew wr* ports in bd-build.tcl): GTY placement + link clocks
if {$WR_BUILD && [file exists $SCRIPT_DIR/constraints-wr.xdc]} {
  add_files -fileset constrs_1 -norecurse $SCRIPT_DIR/constraints-wr.xdc
}
update_compile_order -fileset sources_1
