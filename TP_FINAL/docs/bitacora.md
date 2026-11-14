# Bitácora — Trabajo Final (procesador RISC-V con pipeline)

Registro cronológico de todo lo que discutimos, decidimos y tocamos. Regla: nada queda solo en el chat (ver "Ley de oro" en `CLAUDE.md`). Cada entrada anota qué se decidió y por qué, qué archivos se crearon/modificaron/movieron y qué quedó pendiente.

Formato de entrada: `## NNN — fecha — título`.

---

## 001 — 2026-11-14 — Lectura de la consigna y punto de partida

**Discutido**
- Se leyó la consigna (`TRABAJO FINAL 2026.pdf`): procesador RV32I con pipeline de 5 etapas, Debug Unit por UART, interfaz en la PC, clock sin intervenir, análisis de camino crítico/skew y preguntas de defensa (ver `informe_final.md`, sección "Consigna").
- Se consultó el artifact de la guía de estudio del grupo. Describe un proyecto ya terminado (IF hecha, `rv_defs.vh`, 164 programas de prueba), pero esos archivos **no estaban en el repo**: el zip con `rtl/`, `sim/`, `scripts/` y `docs/` nunca se copió.

**Decidido**
- Arrancar el procesador **desde cero** en un proyecto Vivado vacío, entendiendo cada pieza antes de escribirla. No se copia código ya hecho.
- Orden de trabajo: entender → decidir → documentar → recién después escribir código.

**Archivos**
- *(El usuario)* creó el proyecto Vivado vacío `tp_final/tp_final.xpr` (+ `tp_final.cache/`, `tp_final.hw/`).
- *(El usuario)* movió el ensamblador a `software_tpfinal/` (`asm.py`, `test_asm.py`, `README.md`, `ejemplos/`). Ya no está en `tp_final/software/` como decía `CLAUDE.md`.
- *(El usuario)* agregó `tp_final_referencia.zip` en la raíz (material de referencia; no se usa para copiar código).

**Pendiente / dudas abiertas**
- `CLAUDE.md` todavía menciona `tp_final/software/` y `scripts/create_project.tcl`; hay que actualizarlo cuando decidamos la estructura final de carpetas.
- Decidir dónde viven `rtl/` y `sim/` respecto del proyecto Vivado (ver entrada siguiente).

---

## 002 — 2026-11-14 — Ley de oro y documentos de seguimiento

**Decidido**
- Se establece la "Ley de oro": todo lo discutido y decidido se registra por escrito. Hay dos documentos vivos:
  - **Bitácora** (este archivo): cronológica, detallada, uso interno.
  - **Informe final** (`informe_final.md`): documento a entregar al profesor, se completa mientras avanzamos.
- Ambos viven en `tp_final/docs/`, en español.

**Archivos**
- `CLAUDE.md` — **modificado**: nueva sección "LEY DE ORO: todo queda documentado" antes de "Estructura".
- `tp_final/docs/bitacora.md` — **creado** (este archivo).
- `tp_final/docs/informe_final.md` — **creado**, con el esqueleto de secciones.

**Pendiente**
- Nada se commiteó todavía.

---

## 003 — 2026-11-14 — `CLAUDE.md` actualizado a la realidad del repo

**Decidido**
- El procesador se hace desde cero, así que se elimina del `CLAUDE.md` la idea de que IF estaba "hecha y probada" por el compañero y que había un zip pendiente de copiar.
- La ubicación de `rtl/` y `sim/` queda como **pendiente de decisión**; se documenta como "prevista".

**Archivos**
- `CLAUDE.md` — **modificado**:
  - tabla de carpetas: `tp_final/` descrita como proyecto Vivado vacío; agregadas `software_tpfinal/` y `tp_final_referencia.zip`;
  - estructura de `tp_final/`: refleja lo que existe (`tp_final.xpr`, `docs/`) y marca `rtl/`, `sim/` como previstas; quitado `scripts/` y `software/`;
  - rutas del ensamblador: `tp_final/software/` → `software_tpfinal/` (3 lugares);
  - plan de trabajo: IF deja de figurar como hecha;
  - convención sobre Vivado: el proyecto se creó a mano, no con `create_project.tcl`.

**Pendiente**
- Decidir ubicación de `rtl/` y `sim/`.

---

## 004 — 2026-11-14 — Un documento por módulo

**Discutido**
- La bitácora (cronológica) y el informe (para el profesor) no sirven para consultar rápido cómo quedó un módulo mientras se trabaja en el siguiente. Además, explicar cada módulo con palabras propias ayuda a entenderlo y a preparar la defensa.

**Decidido**
- Un `.md` por etapa/pieza importante en `tp_final/docs/modulos/` (no por cada `.v`; `imem` y `pc` van dentro de `if_stage.md`).
- Sin duplicar: el doc del módulo es la fuente de detalle; el informe final resume y enlaza; la bitácora solo registra la creación/actualización.
- Todos usan la misma plantilla (qué hace, interfaz, comportamiento y decisiones, cómo se prueba, errores comunes, preguntas de defensa).
- Alternativa descartada: solo bitácora + informe (no sirve de consulta técnica por módulo).

**Archivos**
- `CLAUDE.md` — **modificado**: nuevo punto 3 en la LEY DE ORO (doc por módulo), renumerados los siguientes; `docs/` ahora lista `modulos/`.
- `tp_final/docs/modulos/_plantilla.md` — **creado**.

---

## 005 — 2026-11-14 — Revisión del proyecto Vivado de Tadeo

**Revisado** (`tp_final/proyecto_vivado/tp_final_arqui/tp_final_arqui.xpr`, Vivado 2025.2)
- Parte correcta: `xc7a35tcpg236-1` (Basys 3). Sin `BoardPart` (no hace falta).
- Proyecto **vacío**: sin fuentes de diseño, sin constraints (`constrs_1`), sin testbenches (`sim_1`). Simulador: XSim.
- El `.xpr` guarda en su cabecera una ruta absoluta vieja de la PC de Tadeo; es inofensivo, Vivado resuelve el resto con rutas relativas.
- Reorganización del repo hecha por Tadeo: ensamblador en `tp_final/cli/`, PDF de la consigna en `tp_final/docs/`, proyecto en `tp_final/proyecto_vivado/`. Ya no existen `software_tpfinal/` ni `tp_final/tp_final.xpr`.

**Falta / a corregir**
- El `.gitignore` de la raíz ignora `vivado/`, pero la carpeta se llama `proyecto_vivado/`: lo que genera Vivado (`*.runs/`, `*.sim/`, `*.gen/`, `*.ip_user_files/`, `*.cache/`) se estaría versionando.
- No hay carpeta de fuentes (`rtl/`, `sim/`, `constr/`) ni decisión sobre dónde viven.
- `CLAUDE.md` todavía menciona `software_tpfinal/` y la estructura vieja.

**Pendiente de decisión**
- Fuentes fuera del proyecto Vivado (`tp_final/rtl`, `sim`, `constr`) agregadas con "Add sources" *sin copiar*, para que git versione el código y no los archivos generados.

---

## 006 — 2026-11-14 — Fuentes dentro del proyecto Vivado y commits manuales

**Decidido**
- **Por ahora el código vive dentro del proyecto Vivado** (`proyecto_vivado/tp_final_arqui/`), con "Copy sources into project" por defecto. Se descarta, por ahora, la estructura `rtl/`, `sim/`, `constr/` fuera del proyecto. Motivo: simplicidad al arrancar. Si más adelante genera problemas (git, merges, dos PCs), se saca el código afuera y se anota acá.
- **Los commits los hace solo el usuario.** Claude no hace `git commit`/`push` ni crea ramas; puede sugerir un mensaje.

**Archivos**
- `CLAUDE.md` — **modificado**: nueva sección "Git: los commits los hace solo el usuario".

**Pendiente**
- El `.gitignore` de la raíz sigue ignorando `vivado/` y no `proyecto_vivado/`: revisar cuando haya archivos generados.
- Actualizar en `CLAUDE.md` la estructura de carpetas real (`tp_final/cli/`, `tp_final/docs/`, `tp_final/proyecto_vivado/`).

---

## 007 — 2026-11-14 — Arquitectura del procesador: módulos, conexiones e interfaces

**Discutido**
- Antes de escribir IF, se acordó cómo se estructura todo el procesador: jerarquía de módulos, conexiones entre etapas e interfaz de `cpu_core`.

**Decidido** (detalle y justificación completa en `informe_final.md`, secciones 2 y 3: D2–D5)
- `cpu_core` contiene: `if_stage`, `if_id`, `id_stage`, `id_ex`, `ex_stage`, `ex_mem`, `mem_stage`, `mem_wb`, `wb_stage`, `forwarding_unit`, `hazard_unit`. Constantes en `rv_defs.vh`.
- **Los latches son módulos propios** (D2). Por qué: se ve qué viaja entre etapas; la Debug Unit los expone en un solo lugar (la consigna pide enviarlos a la PC); `stall`/`flush` se aplican en un único sitio; las etapas quedan como lógica combinacional pura y testeable; `pc`/`valid` siguen un patrón único. Alternativa descartada: registros embebidos en cada etapa (menos archivos, pero mezcla lógica y estado y dispersa el control).
- Interfaz de `cpu_core`: control (`i_clk`, `i_reset`, `i_enable`), carga de imem, lectura de debug (registros y memoria), estado (`o_pc`, `o_halted`, `o_pipeline_empty`, latches).
- Orden de construcción: `rv_defs.vh` → IF → regfile e `imm_gen` → control → ALU y EX → MEM → WB → riesgos → `cpu_core`.

**Abierto**
- D5: etapa donde se resuelve el branch (EX o ID). Se decide al llegar a la unidad de riesgos.

**Archivos**
- `tp_final/docs/informe_final.md` — **modificado**: sección 2 (arquitectura e interfaz) y decisiones D2–D5.

---

## 008 — 2026-11-14 — Concepto de IF e `imem` + ilustración

**Discutido**
- Se explicó la etapa IF (PC, `imem`, PC+4, mux de próximo PC) y su comportamiento ciclo a ciclo.
- Aclaración que costó entender y conviene no olvidar: **`imem` = Instruction Memory** (memoria de programa; no es una "memoria instantánea"). "Asincrónica" describe solo su lectura. Se usó la analogía del armario con 256 cajones.
- Por qué se indexa con `pc[9:2]`: el PC cuenta bytes, la `imem` cuenta palabras; dividir por 4 = descartar los 2 bits bajos.

**Decidido**
- Documentar el concepto con una imagen para no olvidarlo.

**Archivos**
- `tp_final/docs/img/imem.svg` — **creado**: ilustración de la `imem` (PC → cajón → instrucción).
- `tp_final/docs/modulos/if_stage.md` — **creado** desde la plantilla, con el concepto, la imagen y el ciclo a ciclo. Estado: en diseño; interfaz y tests pendientes.

**Pendiente**
- Definir los puertos de `if_stage` y confirmar las decisiones de IF (PC en reset, escritura sincrónica de `imem`).

---

## 009 — 2026-11-14 — Interfaz de IF y `imem` como módulo separado

**Discutido**
- Se propuso que `if_stage` tuviera puertos de escritura de la `imem`. El usuario preguntó por qué IF tendría que escribir instrucciones: no debería. Las escribe la Debug Unit (carga por UART sin resintetizar).
- Se comparó A (`imem` dentro de IF) vs B (`imem` módulo aparte).

**Decidido** (D6 en `informe_final.md`)
- **B**: `imem` es un módulo propio. Principio del grupo: cada módulo lo más chico posible, con una responsabilidad clara. `if_stage` queda solo con PC, mux de próximo PC y sumador +4.
- Puertos de `if_stage`: `i_clk`, `i_reset`, `i_enable`, `i_pc_src`, `i_pc_target`, `o_pc`. No recibe la instrucción.
- Puertos de `imem`: `i_clk`, `i_we`, `i_waddr[7:0]`, `i_wdata[31:0]`, `i_raddr[7:0]`, `o_rdata[31:0]`. Lectura asincrónica, escritura sincrónica, ignora `i_enable`.
- `cpu_core` conecta `o_pc[9:2]` → `imem.i_raddr` y `imem.o_rdata` → `if_id`.
- Un solo `i_enable`; sin salida PC+4 (EX suma 4 a `o_pc`); reset sincrónico; el `valid` lo genera el latch `if_id`.

**Archivos**
- `tp_final/docs/informe_final.md` — **modificado**: jerarquía (2.1) con `imem` aparte; decisión D6.
- `tp_final/docs/modulos/if_stage.md` — **modificado**: encabezado y sección 2 (interfaz de `if_stage` e `imem`, conexión en `cpu_core`).

**Pendiente**
- Escribir `if_stage.v` e `imem.v` y sus testbenches (todavía no se escribió código).

---

## 010 — 2026-11-14 — Archivos creados por Tadeo y primer código: `if_stage`

**Revisado**
- Tadeo creó desde Vivado los 19 archivos de Design Sources y los 14 testbenches de la lista (en `tp_final/proyecto_vivado/tp_final_arqui/tp_final_arqui.srcs/{sources_1,sim_1}/new/`). Casi todos vacíos.
- Dos tenían la plantilla de Vivado: `tb_dmem.v` (válido) y `ex_mem.v`, que tenía `module (` **sin nombre** (error de sintaxis). Un error así rompe la compilación de todo el proyecto, aunque el módulo no se use.
- Lenguaje: los archivos son `.v`, o sea Verilog-2001 (D4 se mantiene).

**Decidido**
- D7: prioridad en IF reset > enable > salto > PC+4 (justificación en `informe_final.md`). Implica una regla para la `hazard_unit`: no hacer stall cuando hay salto tomado.

**Archivos**
- `.../sources_1/new/if_stage.v` — **escrito**: PC con reset sincrónico, estilo `_reg`/`_next`, dos `always`.
- `.../sim_1/new/tb_if_stage.v` — **escrito**: 8 pruebas autochequeables (ver `docs/modulos/if_stage.md`, sección 4).
- `.../sources_1/new/ex_mem.v` — **modificado**: se vació (quedó en blanco) para quitar el error de sintaxis; se rellenará cuando llegue el latch EX/MEM.
- `tp_final/docs/modulos/if_stage.md` — **modificado**: estado, ubicación y sección 4 (cómo se prueba).
- `tp_final/docs/informe_final.md` — **modificado**: sección 4.1 y decisión D7.

**Comandos / verificación**
- **No se pudo simular**: esta PC no tiene Vivado, `iverilog` ni `xsim`. El código y el testbench se revisaron a mano, pero **no se ejecutaron**.

**Pendiente**
- Correr `tb_if_stage` en Vivado y anotar el resultado (esperado: `TEST OK`).
- Escribir `imem.v` y `tb_imem.v`.

---

## 011 — 2026-11-14 — `if_stage` simulado: TEST OK

**Comandos / verificación**
- Tadeo corrió en Vivado 2026.1: `tb_if_stage` como top → *Run Behavioral Simulation* (XSim).
- Resultado: 17 comprobaciones `ok` (8 pruebas: reset, avance, stall, salto, enable>salto, reset a mitad, reset>salto, reset>enable) y `TEST OK: if_stage paso todas las pruebas`. `$finish` a los 166 ns.
- Compilación: solo se analizaron `if_stage.v` y `tb_if_stage.v`; los archivos vacíos no generaron errores.

**Archivos**
- `tp_final/docs/modulos/if_stage.md` — **modificado**: estado y resultado de la sección 4.
- `tp_final/docs/informe_final.md` — **modificado**: estado de 4.1.

**Observaciones**
- Código y testbench los escribió la misma persona (Claude): el test valida que el código cumple lo acordado, no descubre pruebas que se nos hayan olvidado. Se sugirió mirar además las ondas.
- El log mostró que el proyecto se había creado antes en `tp_final/vivado/` y luego se movió a `proyecto_vivado/` (aviso "Project file moved"); sin consecuencias.

**Pendiente**
- Escribir `imem.v` y `tb_imem.v`.

---

## 012 — 2026-11-14 — Qué se valida del programa y dónde (D8)

**Discutido**
- Al recargar un programa **no se borra la `imem`**: el programa nuevo pisa los cajones y, como termina en HALT, los restos del viejo nunca se ejecutan (evita reenviar 256 palabras por UART; a 19200 baud serían ≈0,5 s).
- Se planteó quién valida (instrucciones, tamaño, HALT). Claude propuso que fuera el ensamblador; el usuario objetó con un buen argumento: **el programa puede venir de un tercero**, así que la FPGA debe defenderse sola.

**Decidido** (D8, detalle en `informe_final.md` y `CLAUDE.md`)
- La `imem` **no valida nada**.
- Módulo aparte `program_checker`, parte de la Debug Unit. Valida **durante la carga** (el procesador está frenado, escribir un programa inválido no hace daño; evita un buffer extra de un Block RAM).
- Programa válido ⇔ 1 ≤ palabras ≤ 256 **y la última palabra cargada es HALT** (`0x00100073`). Elegida sobre "HALT en cualquier posición" por ser más estricta y simple.
- Si no es válido: la Debug Unit se niega a ejecutar y responde un código de error.
- Defensa en dos capas: el ensamblador también avisa (errores claros), la FPGA se protege de lo que llegue de afuera.
- Instrucciones desconocidas no se validan: ya se tratan como NOP.

**Límite reconocido**: el hardware garantiza la presencia de HALT al final, no la terminación del programa (imposible de probar en general). Posible protección: límite de ciclos en modo continuo, **a decidir** al diseñar la Debug Unit.

**Archivos**
- `tp_final/docs/informe_final.md` — **modificado**: decisión D8; sección 5.3 (`program_checker`); respuestas preliminares a "¿vaciar la memoria de programa?" y "¿qué pasa sin instrucción de parada?".
- `CLAUDE.md` — **modificado**: nueva decisión en "Decisiones tomadas".

**Pendiente**
- `program_checker.v` todavía no existe en el proyecto Vivado (se crea al diseñar la Debug Unit; el protocolo UART sigue sin definir).
- Escribir `imem.v` y `tb_imem.v`.

---

## 013 — 2026-11-14 — `imem` y `tb_imem` escritos

**Decidido**
- `imem`: arreglo de 256 × 32, lectura asincrónica, escritura sincrónica con `i_we`, inicializada en cero con `initial`. Sin validación (D6, D8).

**Archivos**
- `.../sources_1/new/imem.v` — **escrito** (estaba vacío).
- `.../sim_1/new/tb_imem.v` — **escrito**: 8 pruebas autochequeables (vacío, escribe/lee, asincrónica, `we=0`, vecinos, sobrescribir, extremos, sincrónica).
- `tp_final/docs/modulos/if_stage.md` — **modificado**: estado y sección de pruebas de `imem`.

**Comandos / verificación**
- **No se simuló**: esta PC no tiene simulador. Se revisó a mano la temporización del testbench (cada chequeo ocurre entre flancos, la escritura se verifica antes y después del flanco).

**Pendiente**
- Correr `tb_imem` en Vivado (Set as Top → Run Behavioral Simulation) y anotar el resultado (esperado: `TEST OK`).
- Siguiente módulo: latch `if_id` (o el bloque ID: `regfile`, `imm_gen`, `control_unit`), a definir.
