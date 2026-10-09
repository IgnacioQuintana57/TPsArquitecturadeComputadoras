`timescale 1ns / 1ps

// Isolated Basys 3 smoke top. It intentionally has only the clock, reset,
// and existing o_tx port so the ALU top and its behavior remain untouched.
module uart_smoke_top #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer BAUD_RATE   = 192_000
)(
    input  wire i_clk,
    input  wire i_reset,
    output wire o_tx
);
    uart_smoke_tx #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE),
        .DATA_BYTE  (8'h35)
    ) u_tx (
        .i_clk  (i_clk),
        .i_reset(i_reset),
        .o_tx   (o_tx)
    );
endmodule
