# Informe final — Procesador RISC-V con pipeline en FPGA

**Materia:** Arquitectura de Computadoras — FCEFyN, UNC (2026)
**Integrantes:** Antonino, Tadeo · Quintana, Ignacio
**Plataforma:** Basys 3 (Artix-7 xc7a35t), Vivado

> Documento vivo: se completa a medida que avanza el trabajo. Las secciones marcadas *(pendiente)* todavía no tienen contenido. El detalle cronológico de cada paso está en `bitacora.md`.

---

## 1. Consigna

Resumen de lo pedido por la cátedra:

1. **Procesador RISC-V (RV32I) con pipeline de 5 etapas** (IF, ID, EX, MEM, WB) con manejo de riesgos (forwarding, stall, flush). Instrucciones:
   - R: add, sub, sll, srl, sra, and, or, xor, slt, sltu
   - I: lb, lh, lw, lbu, lhu, addi, andi, ori, xori, slti, sltiu, slli, srli, srai, jalr
   - S: sb, sh, sw
   - B: beq, bne
   - J: jal
   - U: lui
   - HALT
2. **Debug Unit por UART**: cargar y recargar el programa sin resintetizar; modo continuo y modo paso a paso (un ciclo por comando); enviar a la PC los 32 registros, los latches intermedios y la memoria de datos usada. Al terminar, el pipeline debe quedar vacío.
3. **Software en la PC**: ensamblador (asm → código máquina) e interfaz (CLI/GUI/TUI) para cargar, ejecutar y observar el estado.
4. **El clock no se interviene.** Al integrar: camino crítico, skew, frecuencia óptima (Clock Wizard) y métricas de Vivado.

### Preguntas de la consigna a responder

| Pregunta | Respuesta |
|---|---|
| ¿Es necesario vaciar la memoria de datos al recargar un programa? | *(pendiente)* |
| ¿Y los registros? | *(pendiente)* |
| ¿Se necesita vaciar el pipeline? | *(pendiente)* |
| ¿Y la memoria de programa? | *(pendiente)* |
| ¿Qué pasa si en la memoria no hay instrucción de parada? | *(pendiente)* |
| ¿Cuál es el camino crítico del sistema? | *(pendiente)* |
| ¿Genera skew? ¿Qué consecuencias tiene? | *(pendiente)* |

## 2. Arquitectura general

*(Diagrama de bloques completo: pendiente.)*

### 2.1 Jerarquía del procesador (`cpu_core`)

```
cpu_core
├── if_stage   (pc + mux del próximo pc + sumador pc+4)
├── imem       (memoria de programa; módulo hermano de if_stage)
├── if_id      (latch)
├── id_stage   (control_unit + regfile + imm_gen)
├── id_ex      (latch)
├── ex_stage   (alu_control + alu [TP1] + comparador de branch)
├── ex_mem     (latch)
├── mem_stage  (dmem + manejo de byte/half)
├── mem_wb     (latch)
├── wb_stage   (mux del resultado)
├── forwarding_unit
└── hazard_unit  (stall y flush)
rv_defs.vh     (opcodes y códigos de ALU compartidos)
```

Cada etapa recibe del latch anterior y entrega al siguiente. Solo el write-back (WB → regfile en ID) y los branch/jump (→ PC en IF) retroceden. La `forwarding_unit` compara los registros fuente en EX con los destinos de EX/MEM y MEM/WB y gobierna los mux de la ALU. La `hazard_unit` detecta load-use (stall) y saltos tomados (flush).

### 2.2 Interfaz de `cpu_core`

| Grupo | Señales |
|---|---|
| Control | `i_clk`, `i_reset`, `i_enable` (el clock nunca se corta) |
| Carga de programa | `i_imem_we`, `i_imem_addr`, `i_imem_data` |
| Lectura de debug | `i_dbg_reg_addr` → `o_dbg_reg_data`; `i_dbg_mem_addr` → `o_dbg_mem_data` |
| Estado | `o_pc`, `o_halted`, `o_pipeline_empty`, buses con el contenido de los 4 latches |

### 2.3 Orden de construcción

`rv_defs.vh` → IF → regfile e `imm_gen` → control → ALU y EX → MEM → WB → riesgos → `cpu_core`. Cada pieza con su testbench y su documento en `docs/modulos/`.

## 3. Decisiones de diseño

Cada decisión indica qué se eligió, por qué y qué alternativas se descartaron.

| # | Decisión | Justificación | Alternativas descartadas |
|---|---|---|---|
| D1 | Empezar el procesador desde cero, entendiendo cada módulo antes de escribirlo | La consigna pide decisiones propias y documentadas; el objetivo es comprender, no copiar | Reutilizar código ya hecho de una referencia |
| D2 | **Cada latch del pipeline (`if_id`, `id_ex`, `ex_mem`, `mem_wb`) es un módulo propio**, no registros dentro de las etapas | (1) Se ve explícitamente qué información viaja entre etapas. (2) La Debug Unit necesita enviar a la PC el contenido de los latches: con módulos propios, se exponen en un solo lugar sin tocar la lógica de las etapas. (3) `stall` y `flush` se aplican en un único sitio (`i_enable`, `i_flush` del latch), en vez de repartirse por las etapas. (4) Cada etapa queda como lógica combinacional pura y se prueba sola. (5) `pc` y `valid` viajan por todos los latches con el mismo patrón | Registros de pipeline embebidos dentro de cada etapa: menos archivos, pero mezcla lógica con estado, esparce el control de stall/flush y obliga a rastrear cada registro para exponerlo a la Debug Unit |
| D3 | Jerarquía de módulos con `cpu_core` como único punto de entrada (ver 2.1 y 2.2) | Frontera clara entre procesador y Debug Unit; el clock nunca se corta (se usa `i_enable`) | Una Debug Unit que accede directamente a señales internas de cada etapa |
| D4 | Verilog-2001, puertos con prefijo `i_`/`o_`, constantes en `rv_defs.vh` | Convención heredada del TP2, compatible con las herramientas de Vivado sin depender de SystemVerilog | SystemVerilog (`logic`, `always_ff`) |
| D6 | **La `imem` es un módulo aparte, no está dentro de `if_stage`**. `if_stage` solo maneja el PC; `cpu_core` conecta `o_pc[9:2]` a la dirección de lectura de la `imem` y su salida al latch `if_id` | Principio de diseño del grupo: cada módulo lo más chico posible, con una única responsabilidad. La `imem` necesita un puerto de escritura para que la Debug Unit cargue el programa por UART sin resintetizar; dentro de IF esos puertos solo "pasarían de largo" y mezclarían buscar la instrucción con cargar el programa. Separada, IF se prueba solo (sin memoria) y la `imem` se prueba sola | `imem` embebida en `if_stage`: un archivo menos, pero IF con puertos de escritura ajenos a su función |
| D7 | En `if_stage` la prioridad es **reset > enable > salto > PC+4** | La pausa de la Debug Unit (`i_enable = 0`) debe congelar el PC aunque haya un salto pendiente; el reset debe funcionar siempre. Consecuencia: la `hazard_unit` no debe activar stall cuando hay un salto tomado (en ese caso la instrucción en ID es de camino equivocado y se descarta con flush) | Que el salto gane sobre `i_enable`: la pausa de la Debug Unit no congelaría el PC |
| D5 | *Abierta*: etapa donde se resuelve el branch (EX o ID) | Se decide al construir la unidad de riesgos. EX: más simple, 2 ciclos de flush por salto tomado. ID: 1 ciclo, pero complica el forwarding | — |

*(Se irán agregando: codificación de HALT, endianness de UART, cómo se frena el pipeline sin tocar el clock, tamaño de memorias, reutilización de ALU y UART, etc.)*

## 4. El procesador

### 4.1 Etapa IF

`if_stage` mantiene el PC (registro de 32 bits, reset sincrónico a 0) y calcula el próximo valor: PC+4, el destino de un salto, o se queda quieto si `i_enable = 0`. La memoria de programa (`imem`) es un módulo aparte (D6). Prioridad: reset > enable > salto > PC+4 (D7). Detalle completo, interfaz y plan de pruebas: `docs/modulos/if_stage.md`. Estado: código y testbench escritos; **simulación pendiente**.
### 4.2 Etapa ID — *(pendiente)*
### 4.3 Etapa EX — *(pendiente)*
### 4.4 Etapa MEM — *(pendiente)*
### 4.5 Etapa WB — *(pendiente)*
### 4.6 Unidad de riesgos (forwarding, stall, flush) — *(pendiente)*

## 5. Debug Unit

### 5.1 Protocolo de comandos UART — *(pendiente)*
### 5.2 Máquina de estados — *(pendiente)*

## 6. Software de PC

### 6.1 Ensamblador — *(pendiente)*
### 6.2 Interfaz — *(pendiente)*

## 7. Verificación

*(pendiente)* — testbenches, programas de prueba, resultados.

## 8. Implementación en Vivado

### 8.1 Síntesis e implementación — *(pendiente)*
### 8.2 Camino crítico, skew y frecuencia óptima (Clock Wizard) — *(pendiente)*
### 8.3 Pruebas en placa — *(pendiente)*

## 9. Conclusiones

*(pendiente)*
