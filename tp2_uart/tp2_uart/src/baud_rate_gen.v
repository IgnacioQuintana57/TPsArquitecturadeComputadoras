`timescale 1ns / 1ps
// ============================================================
// Baud Rate Generator
// Genera un pulso (tick) de 1 ciclo de reloj, 16 veces por bit.
//   DIVISOR = CLK_FREQ / (BAUD_RATE * 16)
//   100 MHz / (19200 * 16) = 325   (Basys 3)
//    50 MHz / (19200 * 16) = 163   (ejemplo de los slides)
// Es un contador modulo DIVISOR.
// ============================================================
module baud_rate_gen #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 19200
)(
    input  wire i_clk,
    input  wire i_reset,
    output wire o_tick
);
    localparam DIVISOR = CLK_FREQ / (BAUD_RATE * 16);
    localparam NB_CNT  = $clog2(DIVISOR);

    reg [NB_CNT-1:0] count;

    always @(posedge i_clk) begin
        if (i_reset)
            count <= 0;
        else if (count == DIVISOR - 1)
            count <= 0;
        else
            count <= count + 1'b1;
    end

    assign o_tick = (count == DIVISOR - 1);
endmodule
