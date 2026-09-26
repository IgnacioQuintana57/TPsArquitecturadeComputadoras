`timescale 1ns / 1ps
// ============================================================
// Receptor UART  (implementa el "Diagrama de estados Rx" de los slides)
//   idle  -> espera rx == 0 (inicio del start bit)
//   start -> cuenta 7 ticks (mitad del start bit)
//   data  -> cada 16 ticks toma un bit (LSB primero) en un shift register
//   stop  -> espera SB_TICK ticks y levanta o_rx_done durante 1 ciclo
// ============================================================
module uart_rx #(
    parameter NB_DATA = 8,    // bits de datos
    parameter SB_TICK = 16    // ticks del stop bit (16 = 1 stop bit)
)(
    input  wire               i_clk,
    input  wire               i_reset,
    input  wire               i_rx,
    input  wire               i_tick,
    output reg                o_rx_done,
    output wire [NB_DATA-1:0] o_data
);
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0]         state,  next_state;
    reg [3:0]         s_reg,  s_next;      // contador de ticks (0..15)
    reg [2:0]         n_reg,  n_next;      // contador de bits recibidos
    reg [NB_DATA-1:0] b_reg,  b_next;      // shift register de datos

    // Sincronizador de 2 FF: rx viene de afuera (asincronico al clk)
    reg rx_meta, rx_sync;
    always @(posedge i_clk) begin
        rx_meta <= i_rx;
        rx_sync <= rx_meta;
    end

    // ---------------- Memoria ----------------
    always @(posedge i_clk) begin
        if (i_reset) begin
            state <= IDLE;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end else begin
            state <= next_state;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end

    // ------- Logica de proximo estado y salidas -------
    always @(*) begin
        next_state = state;
        s_next     = s_reg;
        n_next     = n_reg;
        b_next     = b_reg;
        o_rx_done  = 1'b0;

        case (state)
            IDLE:
                if (~rx_sync) begin
                    next_state = START;
                    s_next     = 0;
                end

            START:
                if (i_tick) begin
                    if (s_reg == 7) begin
                        next_state = DATA;
                        s_next     = 0;
                        n_next     = 0;
                    end else
                        s_next = s_reg + 1'b1;
                end

            DATA:
                if (i_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {rx_sync, b_reg[NB_DATA-1:1]};
                        if (n_reg == NB_DATA - 1)
                            next_state = STOP;
                        else
                            n_next = n_reg + 1'b1;
                    end else
                        s_next = s_reg + 1'b1;
                end

            STOP:
                if (i_tick) begin
                    if (s_reg == SB_TICK - 1) begin
                        next_state = IDLE;
                        o_rx_done  = 1'b1;
                    end else
                        s_next = s_reg + 1'b1;
                end

            default: next_state = IDLE;   // fault recovery
        endcase
    end

    assign o_data = b_reg;
endmodule
