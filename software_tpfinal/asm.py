#!/usr/bin/env python3
"""
Ensamblador RV32I para el trabajo final de Arquitectura de Computadoras.

Uso:
    py asm.py programa.asm [-o salida.hex]

Genera un .hex con una palabra de 32 bits por linea (8 digitos hex, apto
para $readmemh) e imprime un listado "direccion: codigo  instruccion".

Funciona en dos pasadas:
  1) recorre el fuente, expande pseudoinstrucciones y asigna una direccion
     a cada instruccion y a cada etiqueta;
  2) codifica cada instruccion (ya se conocen todas las etiquetas, asi que
     los saltos hacia adelante funcionan).
"""

import argparse
import os
import re
import sys
from collections import namedtuple

IMEM_WORDS = 256        # tamano de la memoria de instrucciones (palabras)


class AsmError(Exception):
    """Error de ensamblado. Lleva el numero y el texto de la linea fuente."""

    def __init__(self, msg, line_no=None, line=None):
        super().__init__(msg)
        self.msg = msg
        self.line_no = line_no
        self.line = line

    def __str__(self):
        if self.line_no is None:
            return self.msg
        return "linea {}: {}\n    {}".format(self.line_no, self.msg, self.line)


# ============================================================
# Tabla de instrucciones
# ============================================================
# formato:
#   R        rd, rs1, rs2
#   I        rd, rs1, imm            (aritmeticas con inmediato)
#   I_SHIFT  rd, rs1, shamt          (slli/srli/srai: funct7 va en imm[11:5])
#   I_LOAD   rd, imm(rs1)
#   I_JALR   rd, imm(rs1)  o  rd, rs1, imm
#   S        rs2, imm(rs1)
#   B        rs1, rs2, etiqueta
#   U        rd, imm20
#   J        rd, etiqueta
#   SYS      sin operandos           (ebreak = HALT)
InstrInfo = namedtuple("InstrInfo", "fmt opcode funct3 funct7")

OP_R      = 0b0110011
OP_I      = 0b0010011
OP_LOAD   = 0b0000011
OP_STORE  = 0b0100011
OP_BRANCH = 0b1100011
OP_JAL    = 0b1101111
OP_JALR   = 0b1100111
OP_LUI    = 0b0110111
OP_SYSTEM = 0b1110011

INSTRUCCIONES = {
    # ---- tipo R ----
    "add":   InstrInfo("R",       OP_R,      0b000, 0b0000000),
    "sub":   InstrInfo("R",       OP_R,      0b000, 0b0100000),
    "sll":   InstrInfo("R",       OP_R,      0b001, 0b0000000),
    "slt":   InstrInfo("R",       OP_R,      0b010, 0b0000000),
    "sltu":  InstrInfo("R",       OP_R,      0b011, 0b0000000),
    "xor":   InstrInfo("R",       OP_R,      0b100, 0b0000000),
    "srl":   InstrInfo("R",       OP_R,      0b101, 0b0000000),
    "sra":   InstrInfo("R",       OP_R,      0b101, 0b0100000),
    "or":    InstrInfo("R",       OP_R,      0b110, 0b0000000),
    "and":   InstrInfo("R",       OP_R,      0b111, 0b0000000),
    # ---- tipo I: aritmeticas ----
    "addi":  InstrInfo("I",       OP_I,      0b000, None),
    "slti":  InstrInfo("I",       OP_I,      0b010, None),
    "sltiu": InstrInfo("I",       OP_I,      0b011, None),
    "xori":  InstrInfo("I",       OP_I,      0b100, None),
    "ori":   InstrInfo("I",       OP_I,      0b110, None),
    "andi":  InstrInfo("I",       OP_I,      0b111, None),
    # ---- tipo I: shifts con inmediato ----
    "slli":  InstrInfo("I_SHIFT", OP_I,      0b001, 0b0000000),
    "srli":  InstrInfo("I_SHIFT", OP_I,      0b101, 0b0000000),
    "srai":  InstrInfo("I_SHIFT", OP_I,      0b101, 0b0100000),
    # ---- tipo I: loads ----
    "lb":    InstrInfo("I_LOAD",  OP_LOAD,   0b000, None),
    "lh":    InstrInfo("I_LOAD",  OP_LOAD,   0b001, None),
    "lw":    InstrInfo("I_LOAD",  OP_LOAD,   0b010, None),
    "lbu":   InstrInfo("I_LOAD",  OP_LOAD,   0b100, None),
    "lhu":   InstrInfo("I_LOAD",  OP_LOAD,   0b101, None),
    # ---- tipo I: jalr ----
    "jalr":  InstrInfo("I_JALR",  OP_JALR,   0b000, None),
    # ---- tipo S ----
    "sb":    InstrInfo("S",       OP_STORE,  0b000, None),
    "sh":    InstrInfo("S",       OP_STORE,  0b001, None),
    "sw":    InstrInfo("S",       OP_STORE,  0b010, None),
    # ---- tipo B ----
    "beq":   InstrInfo("B",       OP_BRANCH, 0b000, None),
    "bne":   InstrInfo("B",       OP_BRANCH, 0b001, None),
    # ---- tipo J ----
    "jal":   InstrInfo("J",       OP_JAL,    None,  None),
    # ---- tipo U ----
    "lui":   InstrInfo("U",       OP_LUI,    None,  None),
    # ---- sistema ----
    "ebreak": InstrInfo("SYS",    OP_SYSTEM, 0b000, None),
}

PSEUDOS = {"nop", "mv", "j", "ret", "li", "halt"}


# ============================================================
# Registros e inmediatos
# ============================================================
REG_ABI = {
    "zero": 0, "ra": 1, "sp": 2, "gp": 3, "tp": 4,
    "t0": 5, "t1": 6, "t2": 7,
    "s0": 8, "fp": 8, "s1": 9,
    "a0": 10, "a1": 11, "a2": 12, "a3": 13,
    "a4": 14, "a5": 15, "a6": 16, "a7": 17,
    "s2": 18, "s3": 19, "s4": 20, "s5": 21, "s6": 22, "s7": 23,
    "s8": 24, "s9": 25, "s10": 26, "s11": 27,
    "t3": 28, "t4": 29, "t5": 30, "t6": 31,
}


def parse_reg(tok):
    """'x5', 't0', 'zero', ... -> numero de registro (0..31)."""
    t = tok.strip().lower()
    if t in REG_ABI:
        return REG_ABI[t]
    m = re.fullmatch(r"x(\d+)", t)
    if m and int(m.group(1)) <= 31:
        return int(m.group(1))
    raise AsmError("registro invalido: '{}'".format(tok.strip()))


def parse_imm(tok):
    """Inmediato decimal ('10', '-4'), hex ('0x1F', '-0x10') o binario ('0b101')."""
    t = tok.strip().lower()
    signo = 1
    if t[:1] in ("+", "-"):
        signo = -1 if t[0] == "-" else 1
        t = t[1:]
    try:
        if t.startswith("0x"):
            valor = int(t[2:], 16)
        elif t.startswith("0b"):
            valor = int(t[2:], 2)
        else:
            if not t.isdigit():
                raise ValueError
            valor = int(t, 10)
    except ValueError:
        raise AsmError("inmediato invalido: '{}'".format(tok.strip()))
    return signo * valor


def is_number(tok):
    """True si el token parece un numero (si no, es una etiqueta)."""
    return re.match(r"^[+-]?\d", tok.strip()) is not None


def parse_mem(tok):
    """'imm(rs1)' -> (imm, rs1). '(rs1)' equivale a '0(rs1)'."""
    m = re.fullmatch(r"\s*([^()]*?)\s*\(\s*([^()]+?)\s*\)\s*", tok)
    if not m:
        raise AsmError("se esperaba 'imm(registro)': '{}'".format(tok.strip()))
    imm = parse_imm(m.group(1)) if m.group(1) else 0
    return imm, parse_reg(m.group(2))


def check_range(valor, lo, hi, que, par=False):
    if not lo <= valor <= hi:
        raise AsmError("{} fuera de rango: {} (debe estar entre {} y {})"
                       .format(que, valor, lo, hi))
    if par and valor % 2 != 0:
        raise AsmError("{} debe ser par: {}".format(que, valor))


# ============================================================
# Codificacion  (TODO: implementarlas una por una)
# ============================================================
# Todas reciben los campos ya validados (registros 0..31, inmediatos dentro
# de rango, pueden ser negativos) y devuelven la palabra de 32 bits como int
# sin signo (0 .. 2**32-1). Para meter un inmediato negativo en un campo de
# n bits hay que quedarse con sus n bits bajos: imm & ((1 << n) - 1).

def encode_r(opcode, funct3, funct7, rd, rs1, rs2):
    """
    Tipo R:  add rd, rs1, rs2

     31      25 24  20 19  15 14  12 11   7 6      0
    +----------+------+------+------+------+--------+
    |  funct7  | rs2  | rs1  |funct3|  rd  | opcode |
    +----------+------+------+------+------+--------+
         7        5      5      3      5       7
    """
    raise NotImplementedError("TODO: encode_r")


def encode_i(opcode, funct3, rd, rs1, imm):
    """
    Tipo I:  addi rd, rs1, imm  /  lw rd, imm(rs1)  /  jalr rd, imm(rs1)

     31          20 19  15 14  12 11   7 6      0
    +--------------+------+------+------+--------+
    |   imm[11:0]  | rs1  |funct3|  rd  | opcode |
    +--------------+------+------+------+--------+
           12         5      3      5       7

    imm: -2048..2047 (12 bits en complemento a 2).
    Shifts (slli/srli/srai): el ensamblador ya arma imm = funct7 << 5 | shamt,
    es decir imm[11:5] = funct7 e imm[4:0] = shamt.
    ebreak (HALT): rd = rs1 = 0, funct3 = 0, imm = 1.
    """
    raise NotImplementedError("TODO: encode_i")


def encode_s(opcode, funct3, rs1, rs2, imm):
    """
    Tipo S:  sw rs2, imm(rs1)
    El inmediato se parte en dos para que rs1/rs2 queden en el mismo lugar
    que en el tipo R.

     31      25 24  20 19  15 14  12 11      7 6      0
    +----------+------+------+------+---------+--------+
    | imm[11:5]| rs2  | rs1  |funct3| imm[4:0]| opcode |
    +----------+------+------+------+---------+--------+
         7        5      5      3        5        7

    imm: -2048..2047.
    """
    raise NotImplementedError("TODO: encode_s")


def encode_b(opcode, funct3, rs1, rs2, offset):
    """
    Tipo B:  beq rs1, rs2, etiqueta     (offset = destino - PC, en bytes)
    El bit 0 del offset siempre es 0 y NO se guarda. Los bits se mezclan:

        31      30    25 24  20 19  15 14  12 11     8     7     6      0
    +--------+----------+------+------+------+--------+-------+--------+
    |imm[12] |imm[10:5] | rs2  | rs1  |funct3|imm[4:1]|imm[11]| opcode |
    +--------+----------+------+------+------+--------+-------+--------+
        1         6        5      5      3       4        1        7

    offset: -4096..4094, par.
    (Ojo: la slide dice rs1 dos veces; [24:20] es rs2.)
    """
    raise NotImplementedError("TODO: encode_b")


def encode_u(opcode, rd, imm20):
    """
    Tipo U:  lui rd, imm20      ->  rd = imm20 << 12

     31                    12 11   7 6      0
    +------------------------+------+--------+
    |       imm[31:12]       |  rd  | opcode |
    +------------------------+------+--------+
               20               5       7

    imm20: 0..0xFFFFF (son directamente los 20 bits altos del resultado).
    """
    raise NotImplementedError("TODO: encode_u")


def encode_j(opcode, rd, offset):
    """
    Tipo J:  jal rd, etiqueta    (offset = destino - PC; en rd se guarda PC+4)
    El bit 0 del offset no se guarda. Los bits se mezclan:

        31      30       21     20     19        12 11   7 6      0
    +--------+------------+-------+-------------+------+--------+
    |imm[20] | imm[10:1]  |imm[11]| imm[19:12]  |  rd  | opcode |
    +--------+------------+-------+-------------+------+--------+
        1          10         1          8          5       7

    offset: -1048576..1048574 (+-1 MiB), par.
    """
    raise NotImplementedError("TODO: encode_j")


def expand_pseudo(mnem, ops):
    """
    Expande una pseudoinstruccion en una lista de instrucciones reales.
    Recibe y devuelve operandos como texto, p. ej.:
        expand_pseudo("mv", ["a0", "a1"]) -> [("addi", ["a0", "a1", "0"])]
    Si mnem no es pseudoinstruccion, la devuelve tal cual.

    Expansiones:
        nop          -> addi x0, x0, 0
        mv  rd, rs   -> addi rd, rs, 0
        j   etiqueta -> jal  x0, etiqueta
        ret          -> jalr x0, 0(ra)
        halt         -> ebreak                       (= 0x00100073)
        li  rd, imm  -> si imm entra en 12 bits (-2048..2047):
                            addi rd, x0, imm
                        si no:
                            lui  rd, hi20
                            addi rd, rd, lo12
                        donde lo12 son los 12 bits bajos interpretados CON
                        signo (addi los extiende) y hi20 se corrige por eso:
                            hi20 = ((imm + 0x800) >> 12) & 0xFFFFF
                        imm valido: -2**31 .. 2**32-1.

    Se llama en la primera pasada, asi que la cantidad de instrucciones que
    devuelve define las direcciones (li puede ocupar 1 o 2 palabras).
    Debe validar la cantidad de operandos (lanzar AsmError si no coincide).
    """
    if mnem not in PSEUDOS:
        return [(mnem, ops)]
    raise NotImplementedError("TODO: expand_pseudo ({})".format(mnem))


# ============================================================
# Lectura del fuente
# ============================================================
Item = namedtuple("Item", "addr mnem ops line_no line src")
Resultado = namedtuple("Resultado", "addr word text line_no")

LABEL_RE = re.compile(r"^\s*([A-Za-z_.][A-Za-z0-9_.]*)\s*:")


def strip_comment(line):
    """Corta todo lo que hay desde el primer '#' o ';'."""
    for i, c in enumerate(line):
        if c in "#;":
            return line[:i]
    return line


def parse_line(line):
    """
    'etq: addi x1, x0, 5  # coment' -> (['etq'], 'addi', ['x1', 'x0', '5'])
    Puede haber varias etiquetas, y lineas con solo etiqueta o vacias.
    """
    text = strip_comment(line)
    labels = []
    m = LABEL_RE.match(text)
    while m:
        labels.append(m.group(1))
        text = text[m.end():]
        m = LABEL_RE.match(text)
    text = text.strip()
    if not text:
        return labels, None, []
    partes = text.split(None, 1)
    mnem = partes[0].lower()
    ops = []
    if len(partes) > 1:
        ops = [o.strip() for o in partes[1].split(",")]
        if any(o == "" for o in ops):
            raise AsmError("operando vacio (sobra o falta una coma)")
    return labels, mnem, ops


def first_pass(source):
    """Asigna direcciones. Devuelve (items, labels) con labels = {nombre: dir}."""
    items = []
    labels = {}
    addr = 0
    for line_no, line in enumerate(source.splitlines(), start=1):
        try:
            lbls, mnem, ops = parse_line(line)
            for lbl in lbls:
                if lbl in labels:
                    raise AsmError("etiqueta repetida: '{}'".format(lbl))
                labels[lbl] = addr
            if mnem is None:
                continue
            if mnem.startswith("."):
                raise AsmError("directivas no soportadas: '{}'".format(mnem))
            if mnem not in INSTRUCCIONES and mnem not in PSEUDOS:
                raise AsmError("instruccion desconocida: '{}'".format(mnem))
            # texto original sin etiquetas ni comentario (para el listado)
            src = strip_comment(line)
            while LABEL_RE.match(src):
                src = LABEL_RE.sub("", src, count=1)
            src = src.strip()
            for real_mnem, real_ops in expand_pseudo(mnem, ops):
                items.append(Item(addr, real_mnem, real_ops, line_no,
                                  line.rstrip(), src if mnem in PSEUDOS else None))
                addr += 4
        except AsmError as e:
            if e.line_no is None:
                e.line_no, e.line = line_no, line.rstrip()
            raise
    if len(items) > IMEM_WORDS:
        raise AsmError("el programa ocupa {} palabras y la imem tiene {}"
                       .format(len(items), IMEM_WORDS))
    return items, labels


# ============================================================
# Segunda pasada: validar operandos y codificar
# ============================================================
def expect_ops(ops, n, sintaxis):
    if len(ops) != n:
        raise AsmError("se esperaban {} operandos ({}), hay {}"
                       .format(n, sintaxis, len(ops)))


def resolve_offset(tok, labels, pc):
    """Etiqueta -> destino - pc. Numero -> se toma como offset relativo en bytes."""
    if is_number(tok):
        return parse_imm(tok)
    nombre = tok.strip()
    if nombre not in labels:
        raise AsmError("etiqueta inexistente: '{}'".format(nombre))
    return labels[nombre] - pc


def encode_item(item, labels):
    info = INSTRUCCIONES.get(item.mnem)
    if info is None:
        raise AsmError("instruccion desconocida: '{}'".format(item.mnem))
    ops = item.ops

    if info.fmt == "R":
        expect_ops(ops, 3, "rd, rs1, rs2")
        rd, rs1, rs2 = (parse_reg(o) for o in ops)
        return encode_r(info.opcode, info.funct3, info.funct7, rd, rs1, rs2)

    if info.fmt == "I":
        expect_ops(ops, 3, "rd, rs1, imm")
        rd, rs1, imm = parse_reg(ops[0]), parse_reg(ops[1]), parse_imm(ops[2])
        check_range(imm, -2048, 2047, "inmediato")
        return encode_i(info.opcode, info.funct3, rd, rs1, imm)

    if info.fmt == "I_SHIFT":
        expect_ops(ops, 3, "rd, rs1, shamt")
        rd, rs1, shamt = parse_reg(ops[0]), parse_reg(ops[1]), parse_imm(ops[2])
        check_range(shamt, 0, 31, "shamt")
        return encode_i(info.opcode, info.funct3, rd, rs1, (info.funct7 << 5) | shamt)

    if info.fmt == "I_LOAD":
        expect_ops(ops, 2, "rd, imm(rs1)")
        rd = parse_reg(ops[0])
        imm, rs1 = parse_mem(ops[1])
        check_range(imm, -2048, 2047, "offset")
        return encode_i(info.opcode, info.funct3, rd, rs1, imm)

    if info.fmt == "I_JALR":
        if len(ops) == 2:                       # jalr rd, imm(rs1)
            rd = parse_reg(ops[0])
            imm, rs1 = parse_mem(ops[1])
        else:                                   # jalr rd, rs1, imm
            expect_ops(ops, 3, "rd, imm(rs1)")
            rd, rs1, imm = parse_reg(ops[0]), parse_reg(ops[1]), parse_imm(ops[2])
        check_range(imm, -2048, 2047, "offset")
        return encode_i(info.opcode, info.funct3, rd, rs1, imm)

    if info.fmt == "S":
        expect_ops(ops, 2, "rs2, imm(rs1)")
        rs2 = parse_reg(ops[0])
        imm, rs1 = parse_mem(ops[1])
        check_range(imm, -2048, 2047, "offset")
        return encode_s(info.opcode, info.funct3, rs1, rs2, imm)

    if info.fmt == "B":
        expect_ops(ops, 3, "rs1, rs2, etiqueta")
        rs1, rs2 = parse_reg(ops[0]), parse_reg(ops[1])
        offset = resolve_offset(ops[2], labels, item.addr)
        check_range(offset, -4096, 4094, "offset de salto", par=True)
        return encode_b(info.opcode, info.funct3, rs1, rs2, offset)

    if info.fmt == "U":
        expect_ops(ops, 2, "rd, imm20")
        rd, imm = parse_reg(ops[0]), parse_imm(ops[1])
        check_range(imm, 0, 0xFFFFF, "inmediato de 20 bits")
        return encode_u(info.opcode, rd, imm)

    if info.fmt == "J":
        expect_ops(ops, 2, "rd, etiqueta")
        rd = parse_reg(ops[0])
        offset = resolve_offset(ops[1], labels, item.addr)
        check_range(offset, -(1 << 20), (1 << 20) - 2, "offset de salto", par=True)
        return encode_j(info.opcode, rd, offset)

    if info.fmt == "SYS":
        expect_ops(ops, 0, "sin operandos")
        return encode_i(info.opcode, info.funct3, 0, 0, 1)

    raise AsmError("formato desconocido: {}".format(info.fmt))


def item_text(item):
    text = item.mnem + (" " + ", ".join(item.ops) if item.ops else "")
    if item.src is not None:                    # vino de una pseudoinstruccion
        text = "{:<24}# {}".format(text, item.src)
    return text


def assemble(source):
    """Texto fuente -> lista de Resultado(addr, word, text, line_no)."""
    items, labels = first_pass(source)
    resultados = []
    for item in items:
        try:
            word = encode_item(item, labels)
            if not isinstance(word, int) or not 0 <= word < (1 << 32):
                raise AsmError("encode devolvio {!r}: no es un entero de 32 bits sin signo"
                               .format(word))
        except AsmError as e:
            if e.line_no is None:
                e.line_no, e.line = item.line_no, item.line
            raise
        resultados.append(Resultado(item.addr, word, item_text(item), item.line_no))
    return resultados


# ============================================================
# Salida
# ============================================================
def format_hex(resultados):
    """Una palabra por linea, 8 digitos hex (formato de $readmemh)."""
    return "".join("{:08x}\n".format(r.word) for r in resultados)


def format_listing(resultados):
    return "".join("0x{:08x}: {:08x}  {}\n".format(r.addr, r.word, r.text)
                   for r in resultados)


def main(argv=None):
    parser = argparse.ArgumentParser(description="Ensamblador RV32I (TP final)")
    parser.add_argument("entrada", help="archivo .asm")
    parser.add_argument("-o", "--output", help="archivo .hex de salida "
                        "(por defecto, el mismo nombre con extension .hex)")
    args = parser.parse_args(argv)

    salida = args.output or os.path.splitext(args.entrada)[0] + ".hex"
    try:
        with open(args.entrada, encoding="utf-8") as f:
            source = f.read()
        resultados = assemble(source)
    except OSError as e:
        print("error: no se pudo leer '{}': {}".format(args.entrada, e.strerror),
              file=sys.stderr)
        return 1
    except AsmError as e:
        print("error: {}".format(e), file=sys.stderr)
        return 1
    except NotImplementedError as e:
        print("falta implementar: {}".format(e), file=sys.stderr)
        return 1

    with open(salida, "w", encoding="ascii") as f:
        f.write(format_hex(resultados))
    sys.stdout.write(format_listing(resultados))
    print("{} instrucciones -> {}".format(len(resultados), salida))
    return 0


if __name__ == "__main__":
    sys.exit(main())
