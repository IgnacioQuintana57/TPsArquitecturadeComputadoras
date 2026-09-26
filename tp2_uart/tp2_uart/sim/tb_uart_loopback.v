`timescale 1ns / 1ps
// ============================================================
// Testbench: uart_tx -> uart_rx (loopback)
// Manda bytes aleatorios por el Tx, los recibe con el Rx y
// verifica automaticamente que lleguen iguales.
// ============================================================
module tb_uart_loopback;
    localparam CLK_FREQ  = 100_000_000;
    localparam BAUD_RATE = 19200;
    localparam N_TESTS   = 20;

    reg        clk = 0;
    reg        reset = 1;
    reg        tx_start = 0;
    reg  [7:0] tx_data = 0;
    wire       tick, serial, tx_done, rx_done;
    wire [7:0] rx_data;

    integer i, errors = 0;

    always #5 clk = ~clk;   // 100 MHz

    baud_rate_gen #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) u_baud (
        .i_clk(clk), .i_reset(reset), .o_tick(tick));

    uart_tx u_tx (.i_clk(clk), .i_reset(reset), .i_tx_start(tx_start),
                  .i_tick(tick), .i_data(tx_data),
                  .o_tx_done(tx_done), .o_tx(serial));

    uart_rx u_rx (.i_clk(clk), .i_reset(reset), .i_rx(serial),
                  .i_tick(tick), .o_rx_done(rx_done), .o_data(rx_data));

    initial begin
        #100 reset = 0;
        #100;
        for (i = 0; i < N_TESTS; i = i + 1) begin
            @(posedge clk);
            tx_data  <= $random;
            tx_start <= 1;
            @(posedge clk);
            tx_start <= 0;
            @(posedge rx_done);
            #1;
            if (rx_data !== tx_data) begin
                $display("ERROR  enviado=%h recibido=%h", tx_data, rx_data);
                errors = errors + 1;
            end else
                $display("OK     byte=%h", rx_data);
            @(posedge tx_done);
        end
        if (errors == 0) $display("\n*** LOOPBACK PASO: %0d/%0d bytes correctos ***", N_TESTS, N_TESTS);
        else             $display("\n*** LOOPBACK FALLO: %0d errores ***", errors);
        $finish;
    end
endmodule
