# ============================================================
# prueba_r.asm - instrucciones tipo R e I (operaciones de la ALU)
# Varias instrucciones usan el resultado de la anterior: sirve para
# probar el forwarding.  Al final se indica el valor esperado de cada
# registro.
# ============================================================

        addi  x1, x0, 10        # x1  = 10
        addi  x2, x0, 3         # x2  = 3
        addi  x10, x0, -16      # x10 = -16 = 0xFFFFFFF0

# ---- tipo R ----
        add   x3, x1, x2        # x3  = 13
        sub   x4, x1, x2        # x4  = 7
        and   x5, x1, x2        # x5  = 2       (1010 & 0011)
        or    x6, x1, x2        # x6  = 11      (1010 | 0011)
        xor   x7, x1, x2        # x7  = 9       (1010 ^ 0011)
        sll   x8, x1, x2        # x8  = 80      (10 << 3)
        srl   x9, x1, x2        # x9  = 1       (10 >> 3)
        sra   x11, x10, x2      # x11 = -2      (0xFFFFFFFE, conserva el signo)
        srl   x12, x10, x2      # x12 = 0x1FFFFFFE (entra un 0 por la izquierda)
        slt   x13, x10, x1      # x13 = 1       (-16 < 10 con signo)
        sltu  x14, x10, x1      # x14 = 0       (0xFFFFFFF0 > 10 sin signo)

# ---- tipo I ----
        andi  x15, x1, 6        # x15 = 2       (1010 & 0110)
        ori   x16, x1, 5        # x16 = 15      (1010 | 0101)
        xori  x17, x1, -1       # x17 = -11     (~10)
        slti  x18, x10, 0       # x18 = 1       (-16 < 0)
        sltiu x19, x1, 11       # x19 = 1       (10 < 11)
        slli  x20, x2, 4        # x20 = 48      (3 << 4)
        srli  x21, x10, 28      # x21 = 15      (0xFFFFFFF0 >> 28)
        srai  x22, x10, 2       # x22 = -4

# ---- dependencias encadenadas (forwarding desde EX/MEM y MEM/WB) ----
        addi  x23, x0, 1        # x23 = 1
        add   x23, x23, x23     # x23 = 2  (usa el resultado de la anterior)
        add   x23, x23, x23     # x23 = 4
        add   x24, x23, x1      # x24 = 14
        sub   x0, x1, x2        # escribir en x0 no tiene efecto: x0 = 0
        add   x25, x0, x1       # x25 = 10 (x0 no se forwardea)

        halt
