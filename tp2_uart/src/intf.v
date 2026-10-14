`timescale 1ns / 1ps
// ============================================================
// Interface Circuit: une la UART con la ALU.
// Basicamente, espera a tener todos los datos necesarios para luego ir a hacer 
// el calculo a la ALU.
// Reemplaza a los switches y botones del TP1:
//   1er byte recibido -> registro A   (antes: boton 1)
//   2do byte recibido -> registro B   (antes: boton 2)
//   3er byte recibido -> registro Op  (antes: boton 3)
//   Despues envia el resultado de la ALU por Tx (antes: LEDs)
// ============================================================
module intf #(
    parameter NB_DATA = 8,
    parameter NB_OP   = 6
)(
    input  wire               i_clk,
    input  wire               i_reset,
    // desde el Rx
    input  wire [NB_DATA-1:0] i_rx_data,
    input  wire               i_rx_done,
    // desde/hacia el Tx
    input  wire               i_tx_done,
    output reg                o_tx_start,
    output wire [NB_DATA-1:0] o_tx_data,
    // hacia/desde la ALU
    input  wire [NB_DATA-1:0] i_alu_res,
    output reg  [NB_DATA-1:0] o_a,
    output reg  [NB_DATA-1:0] o_b,
    output reg  [NB_OP-1:0]   o_op,
    // debug (para mostrar en LEDs)
    output wire [2:0]         o_state
);
    localparam [2:0] S_A    = 3'd0,   // esperando dato A
                     S_B    = 3'd1,   // esperando dato B
                     S_OP   = 3'd2,   // esperando operacion
                     S_SEND = 3'd3,   // disparar transmision
                     S_WAIT = 3'd4;   // esperar fin de transmision

    reg [2:0] state, next_state;

    // ---------------- Memoria ----------------
    always @(posedge i_clk) begin
        if (i_reset) begin
            state <= S_A;
            o_a   <= 0;
            o_b   <= 0;
            o_op  <= 0;
        end else begin
            state <= next_state;
            if (state == S_A  && i_rx_done) o_a  <= i_rx_data;
            if (state == S_B  && i_rx_done) o_b  <= i_rx_data;
            if (state == S_OP && i_rx_done) o_op <= i_rx_data[NB_OP-1:0];
        end
    end

    // ------- Logica de proximo estado y salidas -------
    always @(*) begin
        next_state = state;
        o_tx_start = 1'b0;
        case (state)
            S_A:    if (i_rx_done) next_state = S_B;
            S_B:    if (i_rx_done) next_state = S_OP;
            S_OP:   if (i_rx_done) next_state = S_SEND;
            S_SEND: begin
                        o_tx_start = 1'b1;
                        next_state = S_WAIT;
                    end
            S_WAIT: if (i_tx_done) next_state = S_A;
            default: next_state = S_A;   // fault recovery
        endcase
    end

    // La ALU es combinacional: cuando llegamos a S_SEND el resultado ya esta.
    // El Tx lo copia a su registro interno en el ciclo de tx_start.
    assign o_tx_data = i_alu_res;
    assign o_state   = state;
endmodule
