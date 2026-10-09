# Create an isolated Vivado project for the Basys 3 UART smoke top.
# This writes only tp2_uart/vivado_smoke and does not change the default ALU
# project at tp2_uart/vivado.

set proj_name tp2_uart_smoke
set part      xc7a35tcpg236-1
set root [file normalize [file dirname [info script]]/..]
set project_dir [file join $root vivado_smoke]

create_project $proj_name $project_dir -part $part -force

add_files -norecurse [list \
    [file join $root src uart_smoke_tx.sv] \
    [file join $root src uart_smoke_top.sv]]
set_property top uart_smoke_top [current_fileset]

add_files -fileset constrs_1 -norecurse \
    [file join $root constr basys3_uart_smoke.xdc]

add_files -fileset sim_1 -norecurse \
    [file join $root sim tb_uart_smoke.sv]
set_property top tb_uart_smoke [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} \
    -objects [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts ""
puts ">>> Smoke project created in $project_dir"
puts ">>> Synthesis top: uart_smoke_top"
puts ">>> Simulation top: tb_uart_smoke"
