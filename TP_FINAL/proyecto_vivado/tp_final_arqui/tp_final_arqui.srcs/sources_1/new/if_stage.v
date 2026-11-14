`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Modulo : if_stage
// Etapa  : IF (Instruction Fetch)
//
// Maneja el PC (Program Counter). No contiene la memoria de programa: la imem
// es un modulo aparte y cpu_core conecta o_pc[9:2] a su direccion de lectura.
//
// Prioridad en cada flanco de clock:
//   1) i_reset  -> PC = 0           (gana sobre todo lo demas)
//   2) !i_enable -> PC se mantiene  (stall o pausa de la Debug Unit)
//   3) i_pc_src  -> PC = i_pc_target (branch/jump tomado)
//   4) si no     -> PC = PC + 4
//////////////////////////////////////////////////////////////////////////////////

module if_stage (
    input  wire        i_clk,
    input  wire        i_reset,      // reset sincronico, pone el PC en 0
    input  wire        i_enable,     // 0 = el PC no cambia
    input  wire        i_pc_src,     // 1 = tomar i_pc_target en vez de PC+4
    input  wire [31:0] i_pc_target,  // destino del salto (lo calcula EX)
    output wire [31:0] o_pc          // PC de la instruccion que se busca ahora
);

    // Registro del PC y su proximo valor (estilo _reg / _next del TP2)
    reg  [31:0] pc_reg;
    reg  [31:0] pc_next;
    wire [31:0] pc_plus4;

    assign pc_plus4 = pc_reg + 32'd4;

    // Secuencial: solo actualiza el registro
    always @(posedge i_clk) begin
        if (i_reset)
            pc_reg <= 32'd0;
        else
            pc_reg <= pc_next;
    end

    // Combinacional: logica del proximo PC
    always @(*) begin
        pc_next = pc_reg;                 // por defecto: se queda quieto
        if (i_enable) begin
            if (i_pc_src)
                pc_next = i_pc_target;    // salto tomado
            else
                pc_next = pc_plus4;       // avance normal
        end
    end

    assign o_pc = pc_reg;

endmodule
