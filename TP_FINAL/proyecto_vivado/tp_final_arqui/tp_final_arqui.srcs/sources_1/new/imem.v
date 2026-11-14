`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Modulo : imem
// Funcion: memoria de programa (Instruction Memory), 256 palabras x 32 bits.
//
//   - Lectura ASINCRONICA: o_rdata = mem[i_raddr], sin esperar al clock.
//   - Escritura SINCRONICA: en el flanco de subida, solo si i_we = 1.
//   - Arranca en cero: memoria vacia = 0x00000000 = NOP (decision del grupo).
//   - NO valida nada: guarda y entrega palabras. La validacion del programa
//     (ultima palabra = HALT, cantidad) la hace program_checker en la Debug Unit.
//
// La escritura no depende de i_enable del procesador: la Debug Unit carga el
// programa con el procesador frenado.
//////////////////////////////////////////////////////////////////////////////////

module imem (
    input  wire        i_clk,
    input  wire        i_we,       // 1 = escribir i_wdata en el cajon i_waddr
    input  wire [7:0]  i_waddr,    // numero de cajon a escribir (0 a 255)
    input  wire [31:0] i_wdata,    // instruccion a guardar
    input  wire [7:0]  i_raddr,    // numero de cajon a leer (o_pc[9:2])
    output wire [31:0] o_rdata     // instruccion del cajon i_raddr
);

    reg [31:0] mem [0:255];
    integer    k;

    // Inicializacion en cero (Vivado la respeta en la FPGA)
    initial begin
        for (k = 0; k < 256; k = k + 1)
            mem[k] = 32'h00000000;
    end

    // Escritura sincronica
    always @(posedge i_clk) begin
        if (i_we)
            mem[i_waddr] <= i_wdata;
    end

    // Lectura asincronica
    assign o_rdata = mem[i_raddr];

endmodule
