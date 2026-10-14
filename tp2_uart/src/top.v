`timescale 1ns / 1ps
// ============================================================
// Top: Baud Rate Generator + Rx + Tx + Interface + ALU
//
//        RX ──► uart_rx ──► intf ──► alu
//                   ▲         │  ◄──┘
//   clk ─► baud_gen ┤         ▼
//                   └──► uart_tx ──► TX
//
// alu = alu_core.sv del TP1
// ============================================================
module top #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 19200,
    parameter NB_DATA   = 8,
    parameter NB_OP     = 6
)(
    input  wire               i_clk,
    input  wire               i_reset,     // btnD (T18), como en el TP1
    input  wire               i_rx,        // desde la PC
    output wire               o_tx,        // hacia la PC
    output wire [NB_DATA-1:0] o_leds_res,  // resultado en LEDs (debug)
    output wire [2:0]         o_leds_state // estado de la intf (debug)
);
    wire               tick;
    wire               rx_done, tx_done, tx_start;
    wire [NB_DATA-1:0] rx_data, tx_data;
    wire [NB_DATA-1:0] a, b, alu_res;
    wire [NB_OP-1:0]   op;


//Configuramos el modulo de baud rate. El mismo hace el calculo para saber cuantos CLKS contar.
    baud_rate_gen #(
        .CLK_FREQ (CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_baud (
        .i_clk  (i_clk),
        .i_reset(i_reset),
        .o_tick (tick)
    );

// Modulo de recepcion UART
    uart_rx #(.NB_DATA(NB_DATA)) u_rx (
        .i_clk    (i_clk),
        .i_reset  (i_reset),
        .i_rx     (i_rx),
        .i_tick   (tick),
        .o_rx_done(rx_done),
        .o_data   (rx_data)
    );

//Modulo de transmisión UART
    uart_tx #(.NB_DATA(NB_DATA)) u_tx (
        .i_clk     (i_clk),
        .i_reset   (i_reset),
        .i_tx_start(tx_start),
        .i_tick    (tick),
        .i_data    (tx_data),
        .o_tx_done (tx_done),
        .o_tx      (o_tx)
    );

//Interfaz. Toma los valores trasmitidos, los "envia" a la ALU. Toma el resultado de la 
//ALU y es el que inicia la transmision por el modulo de TX
    intf #(.NB_DATA(NB_DATA), .NB_OP(NB_OP)) u_intf (
        .i_clk     (i_clk),
        .i_reset   (i_reset),
        .i_rx_data (rx_data),
        .i_rx_done (rx_done),
        .i_tx_done (tx_done),
        .o_tx_start(tx_start),
        .o_tx_data (tx_data),
        .i_alu_res (alu_res),
        .o_a       (a),
        .o_b       (b),
        .o_op      (op),
        .o_state   (o_leds_state)
    );

    // ALU del TP1 (alu_core.sv), sin modificar.
    // alu_top del TP1 (botones/switches) NO se usa: lo reemplazan intf + UART.
    alu_core #(
        .NB_DATA    (NB_DATA),
        .NB_OP_CODE (NB_OP)
    ) u_alu_core (
        .dato_A    (a),
        .dato_B    (b),
        .codigo_op (op),
        .resultado (alu_res)
    );

    assign o_leds_res = alu_res;
endmodule
