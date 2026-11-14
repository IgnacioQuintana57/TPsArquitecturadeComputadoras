# CLAUDE.md

Repositorio de los TPs de **Arquitectura de Computadoras** (FCEFyN, UNC). Placa: **Basys 3** (Artix-7), herramienta: **Vivado**. Lo trabajan dos estudiantes; cualquiera de los dos puede abrir una sesión con Claude, así que este archivo tiene que alcanzar para entender el proyecto sin más explicaciones.

## LEY DE ORO: todo queda documentado

**Nada de lo que se discuta o se decida puede quedar solo en el chat.** Antes de cerrar cada paso, Claude lo registra por escrito. Sin registro, el paso no está terminado.

1. **Bitácora** (`tp_final/docs/bitacora.md`): registro cronológico, una entrada por paso. Cada entrada lleva fecha y anota:
   - qué se discutió y qué se decidió (con el **porqué** y las alternativas descartadas);
   - cada archivo **creado, modificado, movido o borrado**, con una línea de qué cambió y por qué;
   - comandos importantes que se corrieron y su resultado (tests, simulaciones, síntesis);
   - problemas encontrados y cómo se resolvieron;
   - dudas abiertas.
2. **Informe final** (`tp_final/docs/informe_final.md`): es el documento que se **entrega al profesor**. Se va completando mientras avanzamos, no al final. Tiene que reflejar todo lo hecho y todo lo decidido: arquitectura, decisiones de diseño con su justificación, respuestas a las preguntas de la consigna, resultados de simulación, y análisis de clock/tiempos cuando lleguemos. Se redacta de forma prolija, en español, pensando en que lo lee alguien que no estuvo en las charlas.
3. **Un doc por módulo** (`tp_final/docs/modulos/<modulo>.md`, p. ej. `if_stage.md`, `id_stage.md`): uno por cada etapa o pieza importante, no por cada archivo `.v` (`imem` y `pc` van dentro de `if_stage.md`). Se crea junto con el módulo, usando `tp_final/docs/modulos/_plantilla.md`. Es la **fuente de detalle**; el informe final lo resume y enlaza, y la bitácora solo anota que se creó/actualizó, sin repetir el contenido.
4. **Orden de trabajo**: se entiende → se decide → se documenta → recién ahí se escribe código. Si algo cambia una decisión previa, se actualizan ambos documentos (y se anota que la decisión anterior fue reemplazada y por qué).
5. Claude actualiza la bitácora y el informe **sin que se lo pidan**, en el mismo turno en que ocurre el cambio.

## Git: los commits los hace solo el usuario

Claude **nunca** hace `git commit`, `git push`, ni crea ramas por su cuenta. Puede dejar los cambios listos y sugerir un mensaje (conventional commit), pero el commit lo ejecuta el usuario.

## Estructura

| Carpeta | Qué es | ¿Se puede modificar? |
|---|---|---|
| `tp1_v2/` | **TP1**: ALU parametrizable (`alu_core.sv` + `alu_top.sv` con botones/switches). Proyecto Vivado completo. | **NO** |
| `tp2_uart/` | **TP2**: UART (`uart_rx.v`, `uart_tx.v`, `baud_rate_gen.v`), FSM `intf.v` que recibe A, B, Op por UART y devuelve el resultado de la ALU, script `scripts/test_uart.py`. (`tp2_uart/tp2_uart/` es una copia idéntica.) | **NO** |
| `tp_final/` | **Trabajo final**: proyecto Vivado `tp_final.xpr` (vacío al 2026-11-14) + RTL, simulación y documentación. | Sí, es lo que estamos haciendo |
| `software_tpfinal/` | **Software de PC del trabajo final**: ensamblador `asm.py`, `test_asm.py`, `ejemplos/`, `README.md`. | Sí |
| `tp_final_referencia.zip` | Material de referencia ajeno al repo. **No se copia código de ahí**: el procesador se hace desde cero (ver `bitacora.md`, entrada 001). | No |

Estructura actual y prevista de `tp_final/`:

```
tp_final/
├── tp_final.xpr   proyecto Vivado (ya creado, vacío)
├── rtl/           (prevista) Verilog sintetizable: if_stage.v, imem.v, rv_defs.vh, ...
├── sim/           (prevista) testbenches: tb_if_stage.v, ...
└── docs/          bitacora.md, informe_final.md y modulos/ (ver LEY DE ORO)
```

> La ubicación definitiva de `rtl/` y `sim/` (dentro de `tp_final/` o fuera) todavía no está decidida; cuando se decida, se anota en la bitácora y se corrige acá. La etapa IF y `rv_defs.vh` **no existen aún** en el repo: se escriben de cero.

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
- **La `imem` es un módulo aparte y no valida nada** (D6, D8). Un módulo `program_checker` en la Debug Unit valida el programa mientras se carga: válido ⇔ 1 a 256 palabras y **la última palabra cargada es HALT**; si no, la Debug Unit no ejecuta. Al recargar un programa **no se borra** la `imem`. Detalle en `tp_final/docs/informe_final.md`.
- **Instrucción desconocida = NOP** (incluido `0x00000000`, que es lo que hay en memoria vacía).
- **El protocolo de comandos de la Debug Unit todavía NO está definido.** No asumir uno; preguntar.

## Plan de trabajo

1. **Procesador en simulación**: IF · ID · EX · MEM · WB · unidad de riesgos.
2. **Debug Unit + protocolo UART** (reusa TP2).
3. **Software de PC** (Tadeo): primero el ensamblador `software_tpfinal/asm.py`, después la interfaz.
4. **Clock, análisis de tiempos y documentación.**

### Estado del ensamblador

`software_tpfinal/asm.py` tiene hecha la infraestructura (lectura, comentarios, etiquetas, registros, inmediatos, dos pasadas, chequeo de rangos, salida `.hex` y listado). Las funciones `encode_r/i/s/b/u/j` y `expand_pseudo` están en `TODO` **a propósito**: Tadeo las implementa una por una (orden: R, I, S, U, J, B, después pseudoinstrucciones). Explicar cada una antes de escribirla, no completarlas de golpe, y correr los tests después de cada paso:

```
cd software_tpfinal
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
- Lo que genera Vivado (`vivado/`, `.Xil/`, `*.jou`, `*.log`) no se versiona. (Hoy el proyecto `tp_final/tp_final.xpr` se creó a mano desde Vivado; si más adelante se genera con un script `create_project.tcl`, anotarlo acá.)
- **Python**: solo librería estándar de Python 3. En la PC de Tadeo `python` apunta a Python 2.7; usar **`py`**.
