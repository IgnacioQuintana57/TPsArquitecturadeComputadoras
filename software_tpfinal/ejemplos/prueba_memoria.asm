# ============================================================
# prueba_memoria.asm - loads y stores de distintos anchos
# Memoria little-endian: el byte de la direccion mas baja es el menos
# significativo de la palabra.  Todos los accesos estan alineados.
# ============================================================

        addi  x1, x0, 16          # x1 = 16 (base; usamos offsets negativos)
        lui   x2, 0x12345         # x2 = 0x12345000
        addi  x2, x2, 0x678       # x2 = 0x12345678
        addi  x3, x0, -1          # x3 = 0xFFFFFFFF

# ---- palabra ----
        sw    x2, -16(x1)         # mem[0..3]   = 78 56 34 12
        lw    x4, -16(x1)         # x4  = 0x12345678
        add   x5, x4, x0          # x5  = 0x12345678  (riesgo load-use: stall)

# ---- bytes de la palabra guardada ----
        lbu   x6, -16(x1)         # x6  = 0x78   (byte 0)
        lbu   x7, -13(x1)         # x7  = 0x12   (byte 3)
        lhu   x8, -14(x1)         # x8  = 0x1234 (media palabra alta)

# ---- extension de signo ----
        sb    x3, -12(x1)         # mem[4]      = FF
        lb    x9, -12(x1)         # x9  = -1     (0xFFFFFFFF)
        lbu   x10, -12(x1)        # x10 = 255    (0x000000FF)
        sh    x3, -8(x1)          # mem[8..9]   = FF FF
        lh    x11, -8(x1)         # x11 = -1
        lhu   x12, -8(x1)         # x12 = 65535  (0x0000FFFF)

# ---- store parcial sobre una palabra existente ----
        sw    x2, 0(x1)           # mem[16..19] = 78 56 34 12
        sb    x0, 1(x1)           # mem[17]     = 00
        lw    x13, 0(x1)          # x13 = 0x12340078
        sh    x3, 2(x1)           # mem[18..19] = FF FF
        lw    x14, 0(x1)          # x14 = 0xFFFF0078

# ---- store que guarda el dato del load inmediatamente anterior (riesgo) ----
        lw    x15, -16(x1)        # x15 = 0x12345678
        sw    x15, 4(x1)          # mem[20..23] = 78 56 34 12
        lw    x16, 4(x1)          # x16 = 0x12345678

        halt
