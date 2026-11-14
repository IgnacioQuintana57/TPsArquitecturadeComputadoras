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
