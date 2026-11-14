#!/usr/bin/env python3
"""
Pruebas del ensamblador.  Correr desde tp_final/software:

    py -m unittest -v test_asm

Mientras encode_* y expand_pseudo esten en TODO, los tests que codifican
instrucciones fallan con NotImplementedError: es lo esperado.
"""

import unittest

from asm import (AsmError, Resultado, assemble, first_pass, format_hex,
                 format_listing, parse_imm, parse_line, parse_reg)


def words(source):
    return [r.word for r in assemble(source)]


def word(source):
    """Codigo de la unica instruccion de 'source'."""
    ws = words(source)
    assert len(ws) == 1, ws
    return ws[0]


# ------------------------------------------------------------
# Infraestructura (ya implementada: estos tienen que pasar)
# ------------------------------------------------------------
class TestParseReg(unittest.TestCase):
    def test_numericos(self):
        self.assertEqual(parse_reg("x0"), 0)
        self.assertEqual(parse_reg("x31"), 31)
        self.assertEqual(parse_reg(" X5 "), 5)

    def test_abi(self):
        esperado = {"zero": 0, "ra": 1, "sp": 2, "gp": 3, "tp": 4,
                    "t0": 5, "t2": 7, "s0": 8, "fp": 8, "s1": 9,
                    "a0": 10, "a7": 17, "s2": 18, "s11": 27,
                    "t3": 28, "t6": 31}
        for nombre, num in esperado.items():
            self.assertEqual(parse_reg(nombre), num, nombre)

    def test_invalidos(self):
        for tok in ["x32", "x-1", "r1", "t7", "s12", "a8", "", "5"]:
            with self.assertRaises(AsmError, msg=tok):
                parse_reg(tok)


class TestParseImm(unittest.TestCase):
    def test_validos(self):
        self.assertEqual(parse_imm("10"), 10)
        self.assertEqual(parse_imm("-4"), -4)
        self.assertEqual(parse_imm("+7"), 7)
        self.assertEqual(parse_imm("0x1F"), 31)
        self.assertEqual(parse_imm("0XfF"), 255)
        self.assertEqual(parse_imm("-0x10"), -16)
        self.assertEqual(parse_imm("0b101"), 5)

    def test_invalidos(self):
        for tok in ["abc", "", "0x", "1.5", "0xG", "--1", "10a"]:
            with self.assertRaises(AsmError, msg=tok):
                parse_imm(tok)


class TestLectura(unittest.TestCase):
    def test_comentarios(self):
        self.assertEqual(parse_line("add x1, x2, x3  # comentario"),
                         ([], "add", ["x1", "x2", "x3"]))
        self.assertEqual(parse_line("add x1, x2, x3  ; comentario"),
                         ([], "add", ["x1", "x2", "x3"]))
        self.assertEqual(parse_line("   # solo comentario"), ([], None, []))
        self.assertEqual(parse_line(""), ([], None, []))

    def test_etiquetas(self):
        self.assertEqual(parse_line("loop: ADD x1,x2,x3"),
                         (["loop"], "add", ["x1", "x2", "x3"]))
        self.assertEqual(parse_line("a: b:"), (["a", "b"], None, []))

    def test_direcciones_de_etiquetas(self):
        src = """
        inicio:
            add x1, x2, x3
        medio: add x1, x2, x3
            add x1, x2, x3
        fin:
        """
        items, labels = first_pass(src)
        self.assertEqual(len(items), 3)
        self.assertEqual(labels, {"inicio": 0, "medio": 4, "fin": 12})
        self.assertEqual([i.addr for i in items], [0, 4, 8])


class TestSalida(unittest.TestCase):
    def test_hex_y_listado(self):
        rs = [Resultado(0, 0x003100B3, "add x1, x2, x3", 1),
              Resultado(4, 0x00100073, "ebreak", 2)]
        self.assertEqual(format_hex(rs), "003100b3\n00100073\n")
        self.assertEqual(format_listing(rs),
                         "0x00000000: 003100b3  add x1, x2, x3\n"
                         "0x00000004: 00100073  ebreak\n")


# ------------------------------------------------------------
# Valores de referencia (verificados con riscv64-unknown-elf-as -march=rv32i)
# ------------------------------------------------------------
class TestReferencia(unittest.TestCase):
    def test_r_add(self):
        self.assertEqual(word("add x1, x2, x3"), 0x003100B3)

    def test_r_con_nombres_abi(self):
        self.assertEqual(word("add ra, sp, gp"), 0x003100B3)

    def test_i_addi(self):
        self.assertEqual(word("addi x5, x0, 10"), 0x00A00293)

    def test_i_srai(self):
        self.assertEqual(word("srai x6, x7, 3"), 0x4033D313)

    def test_i_lw_offset_negativo(self):
        self.assertEqual(word("lw x4, -4(x8)"), 0xFFC42203)

    def test_s_sw(self):
        self.assertEqual(word("sw x5, 8(x2)"), 0x00512423)

    def test_u_lui(self):
        self.assertEqual(word("lui x5, 0x12345"), 0x123452B7)

    def test_b_beq_hacia_atras(self):
        src = """
        loop:
            add x0, x0, x0
            add x0, x0, x0
            beq x1, x2, loop     # loop esta 8 bytes antes
        """
        self.assertEqual(words(src)[2], 0xFE208CE3)

    def test_ebreak(self):
        self.assertEqual(word("ebreak"), 0x00100073)

    def test_halt(self):
        self.assertEqual(word("halt"), 0x00100073)


# ------------------------------------------------------------
# Pseudoinstrucciones (valores calculados a mano, no con GNU as)
# ------------------------------------------------------------
class TestPseudo(unittest.TestCase):
    def test_nop(self):
        self.assertEqual(word("nop"), 0x00000013)           # addi x0, x0, 0

    def test_mv(self):
        self.assertEqual(word("mv a0, a1"), 0x00058513)     # addi x10, x11, 0

    def test_ret(self):
        self.assertEqual(word("ret"), 0x00008067)           # jalr x0, 0(x1)

    def test_j(self):
        self.assertEqual(word("aca: j aca"), 0x0000006F)    # jal x0, 0

    def test_li_chico(self):
        self.assertEqual(words("li a0, 5"), [0x00500513])   # addi x10, x0, 5

    def test_li_grande(self):
        # lui x10, 0x12345 ; addi x10, x10, 0x678
        self.assertEqual(words("li a0, 0x12345678"), [0x12345537, 0x67850513])

    def test_li_grande_con_correccion(self):
        # 12 bits bajos = 0xFFF = -1 con signo -> hi20 = 0x12345 + 1
        # lui x10, 0x12346 ; addi x10, x10, -1
        self.assertEqual(words("li a0, 0x12345FFF"), [0x12346537, 0xFFF50513])

    def test_li_ocupa_dos_palabras(self):
        _, labels = first_pass("li a0, 0x12345678\nfin: halt")
        self.assertEqual(labels["fin"], 8)


# ------------------------------------------------------------
# Limites de rango que SI son validos (necesitan encode_* implementadas)
# ------------------------------------------------------------
class TestLimitesValidos(unittest.TestCase):
    def test_limites(self):
        for src in ["addi x1, x0, 2047", "addi x1, x0, -2048",
                    "sw x1, 2047(x2)", "sw x1, -2048(x2)",
                    "slli x1, x2, 0", "slli x1, x2, 31",
                    "beq x1, x2, 4094", "beq x1, x2, -4096",
                    "jal x1, 1048574", "jal x1, -1048576",
                    "lui x1, 0", "lui x1, 0xFFFFF"]:
            word(src)       # no tiene que lanzar AsmError


# ------------------------------------------------------------
# Errores (se detectan antes de codificar: tienen que pasar ya)
# ------------------------------------------------------------
class TestErrores(unittest.TestCase):
    def assertError(self, src):
        with self.assertRaises(AsmError, msg=src):
            assemble(src)

    def test_registro_invalido(self):
        self.assertError("add x1, x2, x32")
        self.assertError("addi foo, x0, 1")
        self.assertError("lw x1, 0(x40)")

    def test_inmediato_i(self):
        self.assertError("addi x1, x0, 2048")
        self.assertError("addi x1, x0, -2049")
        self.assertError("lw x1, 2048(x2)")
        self.assertError("jalr x1, -2049(x2)")

    def test_inmediato_s(self):
        self.assertError("sw x1, 2048(x2)")
        self.assertError("sb x1, -2049(x2)")

    def test_shamt(self):
        self.assertError("slli x1, x2, 32")
        self.assertError("srai x1, x2, -1")

    def test_offset_b(self):
        self.assertError("beq x1, x2, 4096")
        self.assertError("beq x1, x2, -4098")
        self.assertError("bne x1, x2, 3")           # impar

    def test_offset_j(self):
        self.assertError("jal x1, 1048576")
        self.assertError("jal x1, -1048578")
        self.assertError("jal x1, 7")               # impar

    def test_inmediato_u(self):
        self.assertError("lui x1, 0x100000")
        self.assertError("lui x1, -1")

    def test_etiqueta_inexistente(self):
        self.assertError("beq x1, x2, no_existe")
        self.assertError("jal ra, no_existe")

    def test_etiqueta_repetida(self):
        self.assertError("a: add x1, x2, x3\na: add x1, x2, x3")

    def test_instruccion_desconocida(self):
        self.assertError("mul x1, x2, x3")

    def test_cantidad_de_operandos(self):
        self.assertError("add x1, x2")
        self.assertError("add x1, x2, x3, x4")
        self.assertError("ebreak x1")
        self.assertError("add x1,, x3")

    def test_programa_demasiado_largo(self):
        self.assertError("add x0, x0, x0\n" * 257)

    def test_error_indica_linea(self):
        with self.assertRaises(AsmError) as ctx:
            assemble("add x1, x2, x3\n\nadd x1, x2, x99")
        self.assertEqual(ctx.exception.line_no, 3)


if __name__ == "__main__":
    unittest.main()
