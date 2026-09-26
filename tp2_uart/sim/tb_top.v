`timescale 1ns / 1ps
// ============================================================
// Testbench del sistema completo (top).
// Hace de "PC": manda A, B y Op por la linea serie, recibe el
// resultado y lo compara con un modelo de referencia.
// Entradas aleatorias + chequeo automatico (igual que en el TP1).
// ============================================================
module tb_top;
    localparam CLK_FREQ  = 100_000_000;
    localparam BAUD_RATE = 19200;
    localparam BIT_NS    = 1_000_000_000 / BAUD_RATE;   // duracion de 1 bit
    localparam N_TESTS   = 16;

    reg        clk   = 0;
    reg        reset = 1;
    reg        rx    = 1;         // linea serie hacia la FPGA (reposo = 1)
    wire       tx;                // linea serie desde la FPGA
    wire [7:0] leds_res;
    wire [2:0] leds_state;

    reg  [7:0] a, b, res, expected;
    reg  [5:0] op;
    integer    i, errors = 0;

    reg [5:0] ops [0:7];
    initial begin
        ops[0] = 6'b100000; // ADD
        ops[1] = 6'b100010; // SUB
        ops[2] = 6'b100100; // AND
        ops[3] = 6'b100101; // OR
        ops[4] = 6'b100110; // XOR
        ops[5] = 6'b000011; // SRA
        ops[6] = 6'b000010; // SRL
        ops[7] = 6'b100111; // NOR
    end

    always #5 clk = ~clk;   // 100 MHz

    top #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) dut (
        .i_clk       (clk),
        .i_reset     (reset),
        .i_rx        (rx),
        .o_tx        (tx),
        .o_leds_res  (leds_res),
        .o_leds_state(leds_state)
    );

    // ---- La "PC" manda un byte: start, 8 datos (LSB primero), stop ----
    task send_byte(input [7:0] data);
        integer k;
        begin
            rx = 0;                 #(BIT_NS);
            for (k = 0; k < 8; k = k + 1) begin
                rx = data[k];       #(BIT_NS);
            end
            rx = 1;                 #(BIT_NS);
        end
    endtask

    // ---- La "PC" recibe un byte: espera start, muestrea en mitad de bit ----
    task recv_byte(output [7:0] data);
        integer k;
        begin
            @(negedge tx);          // flanco del start bit
            #(BIT_NS + BIT_NS/2);   // saltar start y pararse en la mitad de D0
            for (k = 0; k < 8; k = k + 1) begin
                data[k] = tx;       #(BIT_NS);
            end
            if (tx !== 1'b1) $display("  ! stop bit invalido");
        end
    endtask

    // ---- Modelo de referencia ----
    function [7:0] ref_alu(input [7:0] x, input [7:0] y, input [5:0] o);
        case (o)
            6'b100000: ref_alu = x + y;
            6'b100010: ref_alu = x - y;
            6'b100100: ref_alu = x & y;
            6'b100101: ref_alu = x | y;
            6'b100110: ref_alu = x ^ y;
            6'b000011: ref_alu = $signed(x) >>> y;
            6'b000010: ref_alu = x >> y;
            6'b100111: ref_alu = ~(x | y);
            default:   ref_alu = 8'h00;
        endcase
    endfunction

    initial begin
        #200 reset = 0;
        #1000;

        for (i = 0; i < N_TESTS; i = i + 1) begin
            a  = $random;
            b  = $random;
            op = ops[i % 8];
            // los shifts con B chico para que se vea el efecto
            if (op == 6'b000011 || op == 6'b000010) b = b % 8;

            expected = ref_alu(a, b, op);

            fork
                begin
                    send_byte(a);
                    send_byte(b);
                    send_byte({2'b00, op});
                end
                recv_byte(res);
            join

            if (res !== expected) begin
                $display("ERROR  A=%h B=%h Op=%b -> recibido=%h esperado=%h",
                         a, b, op, res, expected);
                errors = errors + 1;
            end else
                $display("OK     A=%h B=%h Op=%b -> %h", a, b, op, res);

            #(2*BIT_NS);
        end

        if (errors == 0) $display("\n*** TOP PASO: %0d/%0d operaciones correctas ***", N_TESTS, N_TESTS);
        else             $display("\n*** TOP FALLO: %0d errores ***", errors);
        $finish;
    end
endmodule
