# Ensamblador RV32I

Convierte un programa en assembler RISC-V (`.asm`) en un archivo `.hex` para cargar en la memoria de instrucciones del procesador. Usa solo la librería estándar de Python 3.

> En Windows, si `python` abre Python 2, usá `py` en su lugar.

## Uso

```
py asm.py programa.asm               # genera programa.hex
py asm.py programa.asm -o salida.hex
```

Además del `.hex` imprime un listado:

```
0x00000000: 00a00093  addi  x1, x0, 10
0x00000004: 00300113  addi  x2, x0, 3
...
0x00000058: 00100073  ebreak                  # halt
```

## Salida `.hex`

Una palabra de 32 bits por línea, 8 dígitos hexadecimales, la primera instrucción en la dirección 0. Es el formato de `$readmemh`, así que sirve también para inicializar la imem en simulación. Para mandarla por UART, cada palabra se envía en **little-endian** (`003100b3` → `B3 00 31 00`).

El programa no puede ocupar más de **256 palabras** (tamaño de la imem).

## Sintaxis

- **Comentarios**: desde `#` o `;` hasta el fin de línea.
- **Etiquetas**: `nombre:`, solas en una línea o antes de una instrucción.
- **Registros**: `x0`–`x31` o nombres ABI (`zero`, `ra`, `sp`, `gp`, `tp`, `t0`–`t6`, `s0`/`fp`, `s1`–`s11`, `a0`–`a7`).
- **Inmediatos**: decimal (`10`, `-4`), hexadecimal (`0x1F`, `-0x10`) o binario (`0b101`).
- No distingue mayúsculas en instrucciones ni registros (sí en etiquetas).

| Tipo | Instrucciones | Sintaxis | Rango |
|---|---|---|---|
| R | add sub sll srl sra and or xor slt sltu | `add rd, rs1, rs2` | |
| I | addi andi ori xori slti sltiu | `addi rd, rs1, imm` | −2048 … 2047 |
| I | slli srli srai | `slli rd, rs1, shamt` | 0 … 31 |
| I | lb lh lw lbu lhu | `lw rd, imm(rs1)` | −2048 … 2047 |
| I | jalr | `jalr rd, imm(rs1)` o `jalr rd, rs1, imm` | −2048 … 2047 |
| S | sb sh sw | `sw rs2, imm(rs1)` | −2048 … 2047 |
| B | beq bne | `beq rs1, rs2, etiqueta` | −4096 … 4094, par |
| J | jal | `jal rd, etiqueta` | ±1 MiB, par |
| U | lui | `lui rd, imm20` | 0 … 0xFFFFF |
| — | ebreak | `ebreak` | |

En `beq`/`bne`/`jal` se puede poner un número en lugar de una etiqueta: se toma como offset relativo al PC, en bytes.

### Pseudoinstrucciones

| Pseudo | Se traduce a |
|---|---|
| `nop` | `addi x0, x0, 0` |
| `mv rd, rs` | `addi rd, rs, 0` |
| `j etiqueta` | `jal x0, etiqueta` |
| `ret` | `jalr x0, 0(ra)` |
| `li rd, imm` | `addi rd, x0, imm` si entra en 12 bits; si no, `lui` + `addi` |
| `halt` | `ebreak` (`0x00100073`) |

## Pruebas

```
py -m unittest -v test_asm
```

## Ejemplos

En [`ejemplos/`](ejemplos/) hay programas cortos que terminan en `halt`, con el valor esperado de cada registro en los comentarios:

- `prueba_r.asm`: instrucciones tipo R e I, con dependencias para probar el forwarding.
- `prueba_memoria.asm`: loads y stores de byte, media palabra y palabra, con y sin signo.
- `prueba_saltos.asm`: bucle con `bne`, `beq` tomado y no tomado, llamada con `jal` y retorno con `jalr`.
