# TP2 UART smoke test

## Objective
Provide a minimal, isolated hardware smoke test that repeatedly transmits ASCII `5` from the Basys 3 over UART TX at 192000 baud, plus a PC listener, before integrating the complete ALU and LED flow.

## Problem and rationale
The existing TP2 design is an ALU request/response system configured for 19200 baud. Changing that path directly would mix the basic board-to-PC validation with the full module behavior. A dedicated smoke top and testbench keep the existing TP2 path intact and make the first hardware check observable.

## Scope
- Authoritative checkout: `tp2_uart/` (outer directory).
- Add a dedicated smoke top, simulation testbench, and PC listener.
- Add a reproducible Vivado smoke-project entry point or documented selection flow.
- Preserve the existing ALU/UART design and the unrelated working-tree change in `tp2_uart/src/uart_rx.v`.
- Do not edit the tracked duplicate under `tp2_uart/tp2_uart/`.

## Constraints
- Basys 3, 100 MHz clock, TX on the existing `o_tx`/A18 mapping.
- UART framing: 8 data bits, no parity, 1 stop bit (8N1).
- Target baud: 192000.
- Generated artifacts under Vivado cache/run directories are not implementation inputs.
- Strict TDD is enabled for this session: RED -> GREEN -> REFACTOR where the test flow supports it.
- Route: delegated direct implementation; mapping required reading 4+ files and writer changes multiple non-trivial files.

## Tasks

- [x] T1 — Implement isolated UART smoke path and simulation proof.
  - Acceptance: dedicated smoke top transmits `8'h35` repeatedly; reset is handled; existing top behavior is untouched; simulation proves repeated valid 8N1 frames at the configured baud.
  - Checks: targeted HDL compile/simulation; inspect diff and preserve unrelated edits.
  - Route: delegated writer.
  - Evidence:
    - Commit `66690d2` (`feat(tp2-uart): add isolated UART smoke path`).
    - Added `uart_smoke_top`, a 24-bit fractional/NCO transmitter, an 8N1 repeated-frame testbench, dedicated Basys 3 constraints, and `scripts/create_smoke_project.tcl`.
    - NCO increment `32212` gives `191998.4818` baud, `-0.0007908%` error; ticks deterministically alternate between 520 and 521 clocks.
    - `git diff --cached --check`: passed before commit; default `top.v`/UART files and nested `tp2_uart/tp2_uart/` were unchanged.
    - `iverilog -g2012 -s tb_uart_smoke -o .tmp_uart_smoke.vvp tp2_uart/sim/tb_uart_smoke.sv tp2_uart/src/uart_smoke_top.sv tp2_uart/src/uart_smoke_tx.sv`: unavailable (`iverilog` is not installed), so HDL simulation is pending.
    - Vivado/Tcl are unavailable, so project creation, synthesis, bitstream generation, and hardware reception remain unverified.

- [ ] T2 — Add PC listener and usage documentation/project selection.
  - Acceptance: listener opens a user-supplied COM port at 192000/8N1, prints received bytes/readable `5`, and exits cleanly on Ctrl+C; README explains install, invocation, reset/programming, and validation boundary.
  - Checks: Python syntax/compile check and listener argument/help smoke check; inspect diff.
  - Route: delegated writer.
  - Evidence: pending.

## Verification and delivery
- Functional proof must distinguish HDL simulation/syntax from real Vivado synthesis/bitstream and physical UART reception.
- Hardware proof remains pending until the board is programmed and the listener observes bytes on the user's actual COM port.
- Work-unit commits use Conventional Commits and contain no AI attribution.

## Progress
- Branch: `feat/tp2-uart-smoke-test`.
- T1: complete in commit `66690d2`; HDL simulation and hardware proof pending unavailable-tool/physical-board checks.
- T2: not started.

## Next step
Implement T2 in the outer `tp2_uart/` checkout, then run the remaining bounded checks and hardware validation.
