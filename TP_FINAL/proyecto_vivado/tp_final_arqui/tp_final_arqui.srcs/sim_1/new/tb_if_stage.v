`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench de if_stage (autochequeable)
//
// Pruebas:
//   1) Reset                          -> PC = 0
//   2) Avance normal                  -> 4, 8, 12
//   3) Stall (i_enable = 0)           -> el PC se queda quieto; al volver sigue
//   4) Salto tomado                   -> PC = destino, y luego sigue de a 4
//   5) i_enable gana sobre i_pc_src   -> con enable = 0 no salta
//   6) Reset a mitad de ejecucion     -> vuelve a 0
//   7) Reset gana sobre i_pc_src      -> PC = 0
//   8) Reset gana sobre i_enable = 0  -> PC = 0
//
// Las entradas cambian 1 ns DESPUES del flanco de subida, asi estan estables
// cuando llega el flanco siguiente y se evitan carreras con el clock.
//////////////////////////////////////////////////////////////////////////////////

module tb_if_stage;

    reg         i_clk;
    reg         i_reset;
    reg         i_enable;
    reg         i_pc_src;
    reg  [31:0] i_pc_target;
    wire [31:0] o_pc;

    integer errores;

    // DUT (device under test)
    if_stage dut (
        .i_clk       (i_clk),
        .i_reset     (i_reset),
        .i_enable    (i_enable),
        .i_pc_src    (i_pc_src),
        .i_pc_target (i_pc_target),
        .o_pc        (o_pc)
    );

    // Clock de 100 MHz (periodo 10 ns)
    initial i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    // Espera un flanco de subida y 1 ns mas
    task tick;
        begin
            @(posedge i_clk);
            #1;
        end
    endtask

    // Compara o_pc con lo esperado. Se usa !== para detectar tambien X.
    task chequear;
        input [31:0]      esperado;
        input [8*32-1:0]  nombre;
        begin
            if (o_pc !== esperado) begin
                $display("ERROR [%0s] t=%0t ns: esperado 0x%08h, obtenido 0x%08h",
                         nombre, $time, esperado, o_pc);
                errores = errores + 1;
            end else begin
                $display("ok    [%0s] o_pc = 0x%08h", nombre, o_pc);
            end
        end
    endtask

    initial begin
        errores     = 0;
        i_reset     = 1'b0;
        i_enable    = 1'b1;
        i_pc_src    = 1'b0;
        i_pc_target = 32'd0;

        // 1) Reset
        i_reset = 1'b1;
        tick;
        chequear(32'h00000000, "1 reset");
        i_reset = 1'b0;

        // 2) Avance normal
        tick; chequear(32'h00000004, "2 avance");
        tick; chequear(32'h00000008, "2 avance");
        tick; chequear(32'h0000000C, "2 avance");

        // 3) Stall
        i_enable = 1'b0;
        tick; chequear(32'h0000000C, "3 stall");
        tick; chequear(32'h0000000C, "3 stall");
        tick; chequear(32'h0000000C, "3 stall");
        i_enable = 1'b1;
        tick; chequear(32'h00000010, "3 reanuda");

        // 4) Salto tomado
        i_pc_src    = 1'b1;
        i_pc_target = 32'h00000040;
        tick; chequear(32'h00000040, "4 salto");
        i_pc_src    = 1'b0;
        tick; chequear(32'h00000044, "4 sigue");
        tick; chequear(32'h00000048, "4 sigue");

        // 5) i_enable tiene prioridad sobre i_pc_src
        i_enable    = 1'b0;
        i_pc_src    = 1'b1;
        i_pc_target = 32'h00000100;
        tick; chequear(32'h00000048, "5 enable>salto");
        i_pc_src = 1'b0;
        i_enable = 1'b1;

        // 6) Reset a mitad de ejecucion
        i_reset = 1'b1;
        tick; chequear(32'h00000000, "6 reset medio");
        i_reset = 1'b0;
        tick; chequear(32'h00000004, "6 reanuda");

        // 7) Reset gana sobre i_pc_src
        i_reset     = 1'b1;
        i_pc_src    = 1'b1;
        i_pc_target = 32'h00000080;
        tick; chequear(32'h00000000, "7 reset>salto");
        i_reset  = 1'b0;
        i_pc_src = 1'b0;

        // 8) Reset gana sobre i_enable = 0
        tick; chequear(32'h00000004, "8 avanza");
        i_reset  = 1'b1;
        i_enable = 1'b0;
        tick; chequear(32'h00000000, "8 reset>enable");
        i_reset  = 1'b0;
        i_enable = 1'b1;

        // Resultado final
        if (errores == 0)
            $display("TEST OK: if_stage paso todas las pruebas");
        else
            $display("TEST FALLO: %0d errores", errores);
        $finish;
    end

endmodule
