#!/usr/bin/env python3
"""
Prueba la ALU en la placa por el puerto serie.
Manda A, B y Op (3 bytes) y lee 1 byte de resultado.

Instalar:  pip install pyserial
Uso:       python test_uart.py COM5          (Windows)
           python test_uart.py /dev/ttyUSB1  (Linux)
"""
import random
import sys

import serial

OPS = {
    "ADD": 0b100000,
    "SUB": 0b100010,
    "AND": 0b100100,
    "OR":  0b100101,
    "XOR": 0b100110,
    "SRA": 0b000011,
    "SRL": 0b000010,
    "NOR": 0b100111,
}


def ref_alu(a, b, op):
    sa = a - 256 if a & 0x80 else a          # A con signo para SRA
    return {
        "ADD": a + b,
        "SUB": a - b,
        "AND": a & b,
        "OR":  a | b,
        "XOR": a ^ b,
        "SRA": sa >> b,
        "SRL": a >> b,
        "NOR": ~(a | b),
    }[op] & 0xFF


def main():
    port = sys.argv[1] if len(sys.argv) > 1 else "COM5"
    ser = serial.Serial(port, baudrate=19200, bytesize=8,
                        parity="N", stopbits=1, timeout=1)
    ser.reset_input_buffer()

    errors = 0
    for i in range(40):
        name = list(OPS)[i % len(OPS)]
        a = random.randint(0, 255)
        b = random.randint(0, 7) if name in ("SRA", "SRL") else random.randint(0, 255)

        ser.write(bytes([a, b, OPS[name]]))
        resp = ser.read(1)
        if not resp:
            print("Timeout: no llego respuesta (probar con reset en la placa)")
            return

        res, exp = resp[0], ref_alu(a, b, name)
        ok = res == exp
        errors += not ok
        print(f"{'OK ' if ok else 'ERR'}  {a:3d} {name:<3} {b:3d} = {res:3d}"
              f"  (0x{res:02X}){'' if ok else f'  esperado {exp}'}")

    print(f"\n{40 - errors}/40 correctas")
    ser.close()


if __name__ == "__main__":
    main()
