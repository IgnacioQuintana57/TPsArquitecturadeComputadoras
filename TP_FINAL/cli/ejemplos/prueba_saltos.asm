# ============================================================
# prueba_saltos.asm - beq, bne, jal, jalr con etiquetas
# Suma 1+2+3+4+5 con un bucle y llama a una subrutina que duplica el
# resultado.  Resultado esperado: x1 = 30, x31 = 1.
# Las instrucciones marcadas "NO se ejecuta" prueban el flush.
# ============================================================

        addi  x1, x0, 0         # x1 = acumulador
        addi  x2, x0, 1         # x2 = i
        addi  x3, x0, 6         # x3 = limite

bucle:
        add   x1, x1, x2        # acumulador += i
        addi  x2, x2, 1         # i++
        bne   x2, x3, bucle     # salto hacia atras mientras i != 6 -> x1 = 15

        beq   x1, x0, error     # NO se toma (x1 = 15)
        jal   ra, duplicar      # llamada: ra = direccion de la siguiente
        beq   x0, x0, fin       # siempre se toma (salto incondicional)
        addi  x1, x0, -1        # NO se ejecuta

duplicar:
        add   x1, x1, x1        # x1 = 30
        jalr  x0, 0(ra)         # retorno
        addi  x1, x0, -1        # NO se ejecuta

fin:
        addi  x31, x0, 1        # x31 = 1: el programa termino bien
        halt

error:
        addi  x31, x0, -1       # x31 = -1: algo salio mal
        halt
