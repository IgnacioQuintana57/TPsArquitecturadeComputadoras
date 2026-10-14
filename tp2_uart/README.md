# TP2 – UART + ALU

## Estructura

```
tp2_uart/
├── src/
│   ├── top.v              # conecta todo
│   ├── baud_rate_gen.v    # tick 16x por bit (contador modulo 325 @100MHz)
│   ├── uart_rx.v          # FSM idle/start/data/stop (diagrama de los slides)
│   ├── uart_tx.v          # FSM del transmisor
│   ├── intf.v             # FSM: byte1->A, byte2->B, byte3->Op, envia resultado
│   └── alu_core.sv        # ALU del TP1, copiada tal cual
├── sim/
│   ├── tb_top.v           # sistema completo, entradas aleatorias + chequeo automatico
│   └── tb_uart_loopback.v # Tx -> Rx, bytes aleatorios
├── constr/basys3.xdc      # pines Basys 3
└── scripts/
    ├── create_project.tcl # crea el proyecto de Vivado
    └── test_uart.py       # prueba en la placa desde la PC
```

## Abrir en Vivado

**Opción A (script):** en Vivado, `Window → Tcl Console`, y escribir:
```
cd C:/ruta/a/tp2_uart
source scripts/create_project.tcl
```
Usen `/` en la ruta, no `\`.

**Opción B (a mano):** Create Project → RTL Project → Add Sources: todo `src/`,
Add Constraints: `constr/basys3.xdc`, parte `xc7a35tcpg236-1`.
Después: Add Sources → Add or create simulation sources → todo `sim/`.

## Simular

Flow Navigator → **Run Simulation → Run Behavioral Simulation**.

- El testbench por defecto es `tb_top`. Para cambiarlo: click derecho sobre
  `tb_uart_loopback` en *Simulation Sources* → **Set as Top**.
- La simulación dura unos 34 ms de tiempo simulado. Si la abrieron a mano y
  se corta en 1 µs, escriban `run all` en la consola Tcl.
- El resultado aparece en la consola: `*** TOP PASO: 16/16 ... ***`.
- Señales para agregar a la forma de onda: `dut/u_intf/state`, `dut/u_rx/state`,
  `dut/u_tx/state`, `dut/a`, `dut/b`, `dut/op`, `dut/alu_res`, `rx`, `tx`.

## Placa

1. Run Synthesis → Run Implementation → Generate Bitstream → Program Device.
2. Revisar el análisis de tiempo: *Open Implemented Design → Report Timing Summary*
   (WNS tiene que ser positivo).
3. `pip install pyserial` y `python scripts/test_uart.py COMx`.
   El puerto COM es el de la Basys 3 (ver el Administrador de dispositivos).

LEDs 0–7 muestran el resultado. LEDs 13–15 muestran el estado de la interfaz
(0 = esperando A, 1 = B, 2 = Op). Si queda trabado, apreten el botón de abajo (btnD, reset).

## Protocolo

La PC manda 3 bytes: `A`, `B`, `Op` (los 6 bits bajos). La FPGA responde con 1 byte.
19200 baudios, 8N1.

Además, el top transmite automáticamente el byte ASCII `5` (`0x35`) por `o_tx`
aproximadamente cada 5 segundos como señal de actividad.
