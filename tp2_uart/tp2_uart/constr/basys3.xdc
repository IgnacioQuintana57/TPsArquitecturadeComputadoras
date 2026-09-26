## ============================================================
## Constraints para Basys 3 (Artix-7 xc7a35tcpg236-1)
## Si usan otra placa, cambien los pines segun su master XDC.
## ============================================================

## Reloj 100 MHz
set_property -dict { PACKAGE_PIN W5  IOSTANDARD LVCMOS33 } [get_ports i_clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_clk]

## Reset = boton de abajo (btnD), el mismo que i_btn_rst del TP1
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports i_reset]

## UART por el USB (el mismo cable de programacion)
set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports i_rx]
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports o_tx]

## LEDs 0..7 = resultado de la ALU
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[0]}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[1]}]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[2]}]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[3]}]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[4]}]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[5]}]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[6]}]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {o_leds_res[7]}]

## LEDs 13..15 = estado de la FSM de interfaz (0=A 1=B 2=Op 3=Send 4=Wait)
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports {o_leds_state[0]}]
set_property -dict { PACKAGE_PIN P1  IOSTANDARD LVCMOS33 } [get_ports {o_leds_state[1]}]
set_property -dict { PACKAGE_PIN L1  IOSTANDARD LVCMOS33 } [get_ports {o_leds_state[2]}]

## Configuracion del bitstream
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
