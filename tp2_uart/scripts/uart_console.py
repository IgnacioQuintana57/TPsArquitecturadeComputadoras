#!/usr/bin/env python3
"""Consola interactiva para operar con la ALU de la Basys 3 por UART."""

from dataclasses import dataclass
from typing import Optional

try:
    import serial
except ImportError:
    print("Falta pyserial. Instalalo con: python -m pip install pyserial")
    raise SystemExit(1)


# Configuración del puerto serial.
SERIAL_PORT = "COM7"
BAUD_RATE = 19_200
READ_TIMEOUT_SECONDS = 3
WRITE_TIMEOUT_SECONDS = 3


@dataclass(frozen=True)
class Operation:
    label: str
    mnemonic: str
    opcode: int
    is_shift: bool = False
    binary_input: bool = False


# Los códigos deben coincidir con los definidos en alu_core.sv.
OPERATIONS = (
    Operation("SUMA", "ADD", 0b100000),
    Operation("RESTA", "SUB", 0b100010),
    Operation("AND", "AND", 0b100100, binary_input=True),
    Operation("OR", "OR", 0b100101, binary_input=True),
    Operation("XOR", "XOR", 0b100110, binary_input=True),
    Operation(
        "Desplazamiento aritmético a derecha",
        "SRA",
        0b000011,
        is_shift=True,
    ),
    Operation(
        "Desplazamiento lógico a derecha",
        "SRL",
        0b000010,
        is_shift=True,
    ),
    Operation("NOR", "NOR", 0b100111, binary_input=True),
)


def parse_number(text: str) -> int:
    """Convierte un número decimal o hexadecimal con prefijo 0x."""
    value = text.strip().lower()

    if value.startswith(("0x", "+0x", "-0x")):
        return int(value, 16)

    return int(value, 10)


def read_operand(label: str, allow_negative: bool) -> int:
    """Lee un operando numérico y lo representa en 8 bits."""
    minimum = -128 if allow_negative else 0

    while True:
        raw = input(label).strip()

        try:
            value = parse_number(raw)
        except ValueError:
            print(
                "Ingresá un entero decimal o hexadecimal, "
                "por ejemplo 12 o 0x0C."
            )
            continue

        if minimum <= value <= 255:
            # Los negativos se representan en complemento a dos.
            return value & 0xFF

        if allow_negative:
            print("El dato debe estar entre -128 y 255 para representarse en 8 bits.")
        else:
            print("El dato debe ser un número no negativo.")


def read_binary_operand(label: str) -> int:
    """Lee exactamente 8 bits, por ejemplo 00001001, y los convierte a un byte."""
    while True:
        value = input(label).strip()

        if len(value) == 8 and all(bit in "01" for bit in value):
            return int(value, 2)

        print("Entrada inválida: ingresá exactamente 8 caracteres, solo 0 y 1.")


def read_shift_amount(label: str) -> int:
    """Lee en decimal la cantidad de posiciones que se desplaza el dato."""
    while True:
        raw = input(label).strip()

        if raw.isdigit():
            amount = int(raw, 10)

            if 0 <= amount <= 7:
                return amount

        print("Entrada inválida: ingresá una cantidad decimal entre 0 y 7.")


def choose_operation() -> Optional[Operation]:
    """Muestra el menú y devuelve la operación elegida."""
    while True:
        print("\nOperaciones disponibles:")

        for number, operation in enumerate(OPERATIONS, start=1):
            if operation.binary_input:
                input_hint = " — A y B en binario (8 bits)"
            elif operation.is_shift:
                input_hint = (
                    " — A binario (8 bits), "
                    "desplazamiento decimal (0 a 7)"
                )
            else:
                input_hint = ""

            print(
                f"  {number}. {operation.label} "
                f"({operation.mnemonic}){input_hint}"
            )

        print("  0. Salir")

        selection = input("Elegí una opción: ").strip()

        if selection == "0":
            return None

        if selection.isdigit() and 1 <= int(selection) <= len(OPERATIONS):
            return OPERATIONS[int(selection) - 1]

        print("Opción inválida; elegí uno de los números del menú.")


def ask_to_continue() -> bool:
    """Pregunta si se desea realizar otra operación."""
    while True:
        answer = input("¿Querés hacer otra operación? (S/N): ").strip().lower()

        if answer in ("s", "si", "sí"):
            return True

        if answer in ("n", "no"):
            return False

        print("Respondé S para continuar o N para salir.")


def show_result(value: int) -> None:
    """Muestra el resultado en decimal, hexadecimal y binario."""
    signed_value = value if value < 0x80 else value - 0x100

    print(
        f"Resultado recibido: {value} (sin signo), "
        f"0x{value:02X}, "
        f"0b{value:08b} "
        f"(con signo de 8 bits: {signed_value})"
    )


def run_session(connection: serial.Serial) -> None:
    print(f"\nConectado a {SERIAL_PORT} a {BAUD_RATE} baudios (8N1).")
    print("La placa debe tener cargado el diseño completo de la ALU.\n")

    while True:
        operation = choose_operation()

        if operation is None:
            print("Sesión finalizada.")
            return

        if operation.binary_input:
            # AND, OR, XOR y NOR: los dos datos se ingresan en binario.
            dato_a = read_binary_operand(
                "Dato A (8 bits, por ejemplo 00001001): "
            )
            dato_b = read_binary_operand(
                "Dato B (8 bits, por ejemplo 00000101): "
            )

        elif operation.is_shift:
            # SRA y SRL: A se ingresa en binario; la cantidad, en decimal.
            dato_a = read_binary_operand(
                "Dato A (8 bits, por ejemplo 11110000): "
            )
            dato_b = read_shift_amount(
                "Cantidad de bits a desplazar (decimal, 0 a 7): "
            )

        else:
            # SUMA y RESTA: ambos datos se ingresan en decimal o hexadecimal.
            dato_a = read_operand(
                "Dato A (-128 a 255; decimal o 0x...): ",
                allow_negative=True,
            )
            dato_b = read_operand(
                "Dato B (-128 a 255; decimal o 0x...): ",
                allow_negative=True,
            )

        # La interfaz UART espera tres bytes consecutivos: A, B y código de operación.
        payload = bytes((dato_a, dato_b, operation.opcode))

        if operation.binary_input:
            print(
                f"Enviando A=0b{dato_a:08b}, "
                f"B=0b{dato_b:08b}, "
                f"Op={operation.mnemonic} "
                f"(0b{operation.opcode:06b})..."
            )

        elif operation.is_shift:
            print(
                f"Enviando A=0b{dato_a:08b}, "
                f"desplazamiento={dato_b} bits, "
                f"Op={operation.mnemonic} "
                f"(0b{operation.opcode:06b})..."
            )

        else:
            print(
                f"Enviando A=0x{dato_a:02X}, "
                f"B=0x{dato_b:02X}, "
                f"Op={operation.mnemonic} "
                f"(0b{operation.opcode:06b})..."
            )

        connection.reset_input_buffer()
        connection.write(payload)
        connection.flush()

        response = connection.read(1)

        if response:
            show_result(response[0])
        else:
            print(
                "No llegó respuesta dentro del tiempo configurado. "
                "Revisá el puerto, los 19200 baudios y que esté cargado "
                "el diseño completo; si hace falta, pulsá reset en la placa."
            )

        if not ask_to_continue():
            print("Sesión finalizada.")
            return


def main() -> int:
    try:
        with serial.Serial(
            port=SERIAL_PORT,
            baudrate=BAUD_RATE,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=READ_TIMEOUT_SECONDS,
            write_timeout=WRITE_TIMEOUT_SECONDS,
            xonxoff=False,
            rtscts=False,
            dsrdtr=False,
        ) as connection:
            connection.reset_input_buffer()
            run_session(connection)

        return 0

    except serial.SerialException as error:
        print(f"No se pudo abrir o usar {SERIAL_PORT}: {error}")
        return 1

    except (KeyboardInterrupt, EOFError):
        print("\nSesión interrumpida.")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())