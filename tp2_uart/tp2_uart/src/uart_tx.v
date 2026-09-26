`timescale 1ns / 1ps
// ============================================================
// Transmisor UART  (la misma FSM que el Rx, pero generando la trama)
//   idle  -> linea en 1; con i_tx_start carga el dato y pasa a start
//   start -> saca 0 durante 16 ticks
//   data  -> saca cada bit (LSB primero) durante 16 ticks
//   stop  -> saca 1 durante SB_TICK ticks, levanta o_tx_done 1 ciclo
// ============================================================
module uart_tx #(
    parameter NB_DATA = 8,
    parameter SB_TICK = 16
)(
    input  wire               i_clk,
    input  wire               i_reset,
    input  wire               i_tx_start,
    input  wire               i_tick,
    input  wire [NB_DATA-1:0] i_data,
    output reg                o_tx_done,
    output wire               o_tx
);
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0]         state, next_state;
    reg [3:0]         s_reg, s_next;
    reg [2:0]         n_reg, n_next;
    reg [NB_DATA-1:0] b_reg, b_next;
    reg               tx_reg, tx_next;   // salida registrada (sin glitches)

    // ---------------- Memoria ----------------
    always @(posedge i_clk) begin
        if (i_reset) begin
            state  <= IDLE;
            s_reg  <= 0;
            n_reg  <= 0;
            b_reg  <= 0;
            tx_reg <= 1'b1;             // linea en reposo = 1
        end else begin
            state  <= next_state;
            s_reg  <= s_next;
            n_reg  <= n_next;
            b_reg  <= b_next;
            tx_reg <= tx_next;
        end
    end

    // ------- Logica de proximo estado y salidas -------
    always @(*) begin
        next_state = state;
        s_next     = s_reg;
        n_next     = n_reg;
        b_next     = b_reg;
        tx_next    = tx_reg;
        o_tx_done  = 1'b0;

        case (state)
            IDLE: begin
                tx_next = 1'b1;
                if (i_tx_start) begin
                    next_state = START;
                    s_next     = 0;
                    b_next     = i_data;
                end
            end

            START: begin
                tx_next = 1'b0;
                if (i_tick) begin
                    if (s_reg == 15) begin
                        next_state = DATA;
                        s_next     = 0;
                        n_next     = 0;
                    end else
                        s_next = s_reg + 1'b1;
                end
            end

            DATA: begin
                tx_next = b_reg[0];
                if (i_tick) begin
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = b_reg >> 1;
                        if (n_reg == NB_DATA - 1)
                            next_state = STOP;
                        else
                            n_next = n_reg + 1'b1;
                    end else
                        s_next = s_reg + 1'b1;
                end
            end

            STOP: begin
                tx_next = 1'b1;
                if (i_tick) begin
                    if (s_reg == SB_TICK - 1) begin
                        next_state = IDLE;
                        o_tx_done  = 1'b1;
                    end else
                        s_next = s_reg + 1'b1;
                end
            end

            default: next_state = IDLE;   // fault recovery
        endcase
    end

    assign o_tx = tx_reg;
endmodule
