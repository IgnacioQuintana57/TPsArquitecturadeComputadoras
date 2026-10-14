import serial

with serial.Serial("COM7", 19200, bytesize=8, parity="N",
                   stopbits=1, timeout=2) as puerto:
    puerto.reset_input_buffer()
    puerto.write(bytes([0x05, 0x06, 0x20]))

    respuesta = puerto.read(1)
    if respuesta:
        valor = respuesta[0]
        print(f"Resultado: {valor} (0x{valor:02X})")
    else:
        print("No llegó respuesta")