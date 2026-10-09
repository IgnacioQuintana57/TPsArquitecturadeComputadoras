`timescale 1ns / 1ps

// Deterministic fractional baud generator and fixed-byte UART transmitter.
//
// With the Basys 3 defaults below, a 24-bit NCO uses
// round(192000 * 2^24 / 100000000) = 32212. Its effective baud is
// 100000000 * 32212 / 2^24 = 191998.4818 baud, an error of -0.0007908%.
// Consequently, baud ticks alternate between 520 and 521 clock cycles.
module uart_smoke_tx #(
    parameter integer CLK_FREQ_HZ = 100_000_000,
    parameter integer BAUD_RATE   = 192_000,
    parameter integer PHASE_BITS  = 24,
    parameter [7:0]   DATA_BYTE   = 8'h35
)(
    input  wire i_clk,
    input  wire i_reset,
    output reg  o_tx
);
    localparam longint unsigned PHASE_SCALE = 64'd1 << PHASE_BITS;
    localparam longint unsigned NCO_INCREMENT =
        (BAUD_RATE * PHASE_SCALE + CLK_FREQ_HZ / 2) / CLK_FREQ_HZ;

    localparam [1:0] IDLE  = 2'd0;
    localparam [1:0] START = 2'd1;
    localparam [1:0] DATA  = 2'd2;
    localparam [1:0] STOP  = 2'd3;

    reg [PHASE_BITS-1:0] phase_acc;
    wire [PHASE_BITS:0] phase_sum =
        {1'b0, phase_acc} + NCO_INCREMENT;
    wire baud_tick = phase_sum[PHASE_BITS];

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge i_clk) begin
        if (i_reset) begin
            phase_acc <= {PHASE_BITS{1'b0}};
            state     <= IDLE;
            bit_index <= 3'd0;
            data_reg  <= DATA_BYTE;
            o_tx      <= 1'b1;
        end else begin
            phase_acc <= phase_sum[PHASE_BITS-1:0];

            if (baud_tick) begin
                case (state)
                    IDLE: begin
                        // Start the next identical frame as soon as the
                        // previous stop bit has completed.
                        state <= START;
                        o_tx  <= 1'b0;
                    end

                    START: begin
                        state     <= DATA;
                        bit_index <= 3'd0;
                        o_tx      <= data_reg[0];
                    end

                    DATA: begin
                        if (bit_index == 3'd7) begin
                            state <= STOP;
                            o_tx  <= 1'b1;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                            o_tx      <= data_reg[bit_index + 1'b1];
                        end
                    end

                    STOP: begin
                        // The stop bit occupied the preceding baud period;
                        // begin the next frame immediately at this tick.
                        state <= START;
                        o_tx  <= 1'b0;
                    end

                    default: begin
                        state <= IDLE;
                        o_tx  <= 1'b1;
                    end
                endcase
            end
        end
    end
endmodule
