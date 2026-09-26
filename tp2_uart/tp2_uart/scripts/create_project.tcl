# ============================================================
# Crea el proyecto de Vivado con todos los archivos.
# Uso (desde la consola Tcl de Vivado):
#   cd <carpeta tp2_uart>
#   source scripts/create_project.tcl
# ============================================================
set proj_name tp2_uart
set part      xc7a35tcpg236-1     ;# Basys 3. Cambiar si usan otra placa.

set root [file normalize [file dirname [info script]]/..]

create_project $proj_name $root/vivado -part $part -force

# Fuentes de diseno
add_files -norecurse [glob $root/src/*.v $root/src/*.sv]
set_property top top [current_fileset]

# Constraints
add_files -fileset constrs_1 -norecurse $root/constr/basys3.xdc

# Testbenches
add_files -fileset sim_1 -norecurse [glob $root/sim/*.v]
set_property top tb_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

# La simulacion dura varios ms (UART a 19200): correr hasta $finish
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "\n>>> Proyecto creado en $root/vivado"
puts ">>> Simular: Flow Navigator -> Run Simulation -> Run Behavioral Simulation"
