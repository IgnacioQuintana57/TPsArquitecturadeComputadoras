`timescale 1ns / 1ps

// Focused proof for the isolated Basys 3 UART smoke path.
module tb_uart_smoke;
    localparam integer CLK_FREQ_HZ = 100_000_000;
    localparam integer BAUD_RATE   = 192_000;
    localparam integer BIT_NS      = 1_000_000_000 / BAUD_RATE;
    localparam integer FRAME_NS    = 10 * BIT_NS;
    localparam integer FRAME_TOL   = 100;
    localparam integer N_FRAMES    = 8;

    reg  clk   = 1'b0;
    reg  reset = 1'b1;
    wire tx;

    integer errors = 0;
    integer timing_errors = 0;
    integer frame_count = 0;
    reg seen_start = 1'b0;
    time previous_start;

    always #5 clk = ~clk;

    uart_smoke_top #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE)
    ) dut (
        .i_clk  (clk),
        .i_reset(reset),
        .o_tx   (tx)
    );

    // Every repeated frame must begin at approximately ten bit periods.
    // The tolerance covers the deterministic 520/521-clock NCO cadence.
    always @(negedge tx) begin
        frame_count = frame_count + 1;
        if (seen_start && (($time - previous_start) < FRAME_NS - FRAME_TOL ||
                           ($time - previous_start) > FRAME_NS + FRAME_TOL)) begin
            $display("ERROR: start interval=%0t ns expected=%0d +/- %0d ns",
                     $time - previous_start, FRAME_NS, FRAME_TOL);
            timing_errors = timing_errors + 1;
        end
        previous_start = $time;
        seen_start = 1'b1;
    end

    task automatic receive_byte(output reg [7:0] data);
        integer bit_index;
        begin
            @(negedge tx);
            #(BIT_NS + BIT_NS / 2);
            for (bit_index = 0; bit_index < 8; bit_index = bit_index + 1) begin
                data[bit_index] = tx;
                #(BIT_NS);
            end
            if (tx !== 1'b1) begin
                $display("ERROR: invalid stop bit");
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        reg [7:0] received;
        repeat (20) @(posedge clk);
        reset = 1'b0;

        repeat (N_FRAMES) begin
            receive_byte(received);
            if (received !== 8'h35) begin
                $display("ERROR: received=%h expected=35", received);
                errors = errors + 1;
            end
        end

        if (frame_count != N_FRAMES)
            $display("ERROR: observed %0d starts expected %0d", frame_count, N_FRAMES);

        if (errors != 0 || timing_errors != 0)
            $fatal(1, "UART smoke failed: data/stop=%0d timing=%0d", errors, timing_errors);

        $display("UART smoke passed: %0d repeated 8N1 frames at ~%0d baud", N_FRAMES, BAUD_RATE);
        $finish;
    end

    // A broken transmitter must fail the proof instead of hanging forever.
    initial begin
        #1_000_000;
        $fatal(1, "UART smoke timeout");
    end
endmodule
