# CLAUDE.md

Repositorio de los TPs de **Arquitectura de Computadoras** (FCEFyN, UNC). Placa: **Basys 3** (Artix-7), herramienta: **Vivado**. Lo trabajan dos estudiantes; cualquiera de los dos puede abrir una sesión con Claude, así que este archivo tiene que alcanzar para entender el proyecto sin más explicaciones.

## Estructura

| Carpeta | Qué es | ¿Se puede modificar? |
|---|---|---|
| `tp1_v2/` | **TP1**: ALU parametrizable (`alu_core.sv` + `alu_top.sv` con botones/switches). Proyecto Vivado completo. | **NO** |
| `tp2_uart/` | **TP2**: UART (`uart_rx.v`, `uart_tx.v`, `baud_rate_gen.v`), FSM `intf.v` que recibe A, B, Op por UART y devuelve el resultado de la ALU, script `scripts/test_uart.py`. (`tp2_uart/tp2_uart/` es una copia idéntica.) | **NO** |
| `tp_final/` | **Trabajo final**: procesador RISC-V con pipeline + Debug Unit + software de PC. | Sí, es lo que estamos haciendo |

Estructura prevista de `tp_final/`:

```
tp_final/
├── rtl/        Verilog sintetizable (if_stage.v, imem.v, rv_defs.vh, ...)
├── sim/        testbenches (tb_if_stage.v, ...)
├── scripts/    create_project.tcl (genera el proyecto Vivado en vivado/, que NO se versiona)
├── docs/       documentación del informe
└── software/   ensamblador (asm.py) e interfaz de PC
```

> A la fecha de crear este archivo, `rtl/`, `sim/`, `scripts/` y `docs/` (con la etapa IF ya hecha) estaban en un zip pendiente de copiar al repo.

## Consigna del trabajo final

1. **Procesador RISC-V RV32I con pipeline de 5 etapas** (IF, ID, EX, MEM, WB) en la Basys 3, con manejo de riesgos (**forwarding, stall, flush**). Instrucciones:
   - **R**: add, sub, sll, srl, sra, and, or, xor, slt, sltu
   - **I**: lb, lh, lw, lbu, lhu, addi, andi, ori, xori, slti, sltiu, slli, srli, srai, jalr
   - **S**: sb, sh, sw
   - **B**: beq, bne
   - **J**: jal
   - **U**: lui
   - **HALT**
2. **Debug Unit** por UART que permita:
   - cargar/recargar el programa **sin resintetizar**;
   - **modo continuo** (corre hasta HALT) y **modo paso a paso** (1 ciclo de clock por comando);
   - enviar a la PC los 32 registros, el contenido de los latches intermedios y la memoria de datos usada.
   - Al terminar, el pipeline tiene que quedar vacío.
3. **Software en la PC**: ensamblador (asm → código máquina) + interfaz (CLI/TUI/GUI) para cargar, ejecutar y ver el estado.
4. **El clock no se puede intervenir.** Al final: camino crítico, skew, frecuencia óptima con Clock Wizard, métricas de Vivado. Documentar todas las decisiones.

## Decisiones tomadas (respetarlas)

- **HALT = `ebreak` = `0x00100073`.** En el ensamblador, `halt` genera exactamente esa palabra.
- **Orden de bytes por UART: little-endian** (primero el byte bajo). `0x003100B3` se envía `B3 00 31 00`.
- **El clock nunca se corta.** Run y Step se implementan con una señal `enable` global.
- **Se reutiliza la ALU del TP1** con `NB_DATA = 32`, manteniendo sus códigos de 6 bits y agregando tres:

  | Op | Código | | Op | Código |
  |---|---|---|---|---|
  | ADD | `100000` | | SRA | `000011` |
  | SUB | `100010` | | SRL | `000010` |
  | AND | `100100` | | NOR | `100111` |
  | OR  | `100101` | | **SLL** (nuevo) | `000000` |
  | XOR | `100110` | | **SLT** (nuevo) | `101010` |
  | | | | **SLTU** (nuevo) | `101011` |

  Un módulo `alu_control` traduce funct3/funct7 de RISC-V a esos códigos.
- **Se reutiliza la UART del TP2 sin cambios** dentro de la Debug Unit. Sin FIFO: se manda un byte, se espera `tx_done`, se manda el siguiente.
- **`pc` y `valid` viajan por todos los latches** para que la interfaz muestre qué instrucción hay en cada etapa (`valid = 0` → burbuja).
- **Memorias**: imem y dmem de **256 palabras × 32 bits**, lectura asincrónica; imem con puerto de escritura para la Debug Unit.
- **Instrucción desconocida = NOP** (incluido `0x00000000`, que es lo que hay en memoria vacía).
- **El protocolo de comandos de la Debug Unit todavía NO está definido.** No asumir uno; preguntar.

## Plan de trabajo

1. **Procesador en simulación** (compañero): IF ✅ (hecha y probada) · ID · EX · MEM · WB · unidad de riesgos.
2. **Debug Unit + protocolo UART** (reusa TP2).
3. **Software de PC** (Tadeo): primero el ensamblador `tp_final/software/asm.py`, después la interfaz.
4. **Clock, análisis de tiempos y documentación.**

### Estado del ensamblador

`tp_final/software/asm.py` tiene hecha la infraestructura (lectura, comentarios, etiquetas, registros, inmediatos, dos pasadas, chequeo de rangos, salida `.hex` y listado). Las funciones `encode_r/i/s/b/u/j` y `expand_pseudo` están en `TODO` **a propósito**: Tadeo las implementa una por una (orden: R, I, S, U, J, B, después pseudoinstrucciones). Explicar cada una antes de escribirla, no completarlas de golpe, y correr los tests después de cada paso:

```
cd tp_final/software
py -m unittest -v test_asm
```

## Errores conocidos en las slides de la consigna (no copiarlos)

- **Tipo B**: la slide dice `rs1` dos veces; el campo `[24:20]` es **`rs2`**.
- **Tipo J**: el destino del salto es **PC + imm**; en `rd` se **guarda PC + 4** (dirección de retorno).
- **Tipo I**: la slide muestra `ld` (RV64); nosotros usamos **`lw`** (funct3 = `010`).

## Convenciones

- **Puertos** con prefijo `i_` (entradas) y `o_` (salidas): `i_clk`, `i_reset`, `o_tx_start`, ...
- **FSM al estilo del TP2**: registros `_reg` / `_next` (p. ej. `s_reg`, `s_next`) y **dos `always`**: uno secuencial (`always @(posedge i_clk)`) que solo actualiza registros, y uno combinacional (`always @(*)`) con la lógica de próximo estado y salidas, con valores por defecto al principio y `default:` en el `case`. Ver `tp2_uart/src/uart_rx.v` e `intf.v`.
- **Comentarios en español.**
- **Verilog-2001 en los `.v`** (nada de SystemVerilog: sin `logic`, `always_ff`, `always_comb`, etc.). Los `.sv` heredados del TP1 se dejan como están.
- Constantes compartidas (opcodes, códigos de ALU) en `rv_defs.vh`.
- Lo que genera Vivado (`vivado/`, `.Xil/`, `*.jou`, `*.log`) no se versiona: el proyecto se regenera con `scripts/create_project.tcl`.
- **Python**: solo librería estándar de Python 3. En la PC de Tadeo `python` apunta a Python 2.7; usar **`py`**.
