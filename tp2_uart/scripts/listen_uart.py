#!/usr/bin/env python3
"""Listen to the UART output of the TP2 board."""

import argparse
import sys

import serial


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Escucha los bytes que transmite la placa por UART."
    )
    parser.add_argument("port", help="Puerto serie, por ejemplo COM7")
    parser.add_argument(
        "--baud",
        type=int,
        default=19200,
        help="Baudrate de la placa (por defecto: 19200)",
    )
    args = parser.parse_args()

    try:
        # UART 8N1: 8 bits, sin paridad y 1 bit de stop.
        # timeout=1 permite detener el programa con Ctrl+C aunque no llegue ningún byte.
        with serial.Serial(
            args.port,
            baudrate=args.baud,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=1,
        ) as connection:
            print(f"Escuchando {args.port} a {args.baud} baud. Ctrl+C para salir.")

            while True:
                data = connection.read(1)
                if not data:
                    continue

                value = data[0]
                character = chr(value) if 32 <= value <= 126 else "."
                print(f"Byte recibido: 0x{value:02X} ({value}) '{character}'", flush=True)

    except KeyboardInterrupt:
        print("\nListener detenido.")
        return 0
    except serial.SerialException as error:
        print(f"No se pudo abrir {args.port}: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
