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

*(pendiente)* — diagrama de bloques: núcleo del procesador, Debug Unit, UART, software de PC.

## 3. Decisiones de diseño

Cada decisión indica qué se eligió, por qué y qué alternativas se descartaron.

| # | Decisión | Justificación | Alternativas descartadas |
|---|---|---|---|
| D1 | Empezar el procesador desde cero, entendiendo cada módulo antes de escribirlo | La consigna pide decisiones propias y documentadas; el objetivo es comprender, no copiar | Reutilizar código ya hecho de una referencia |

*(Se irán agregando: codificación de HALT, endianness de UART, cómo se frena el pipeline sin tocar el clock, tamaño de memorias, reutilización de ALU y UART, etc.)*

## 4. El procesador

### 4.1 Etapa IF — *(pendiente)*
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
