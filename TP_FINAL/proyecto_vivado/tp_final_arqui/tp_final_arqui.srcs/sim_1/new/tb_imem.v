`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench de imem (autochequeable)
//
// Pruebas:
//   1) Cajones nunca escritos         -> 0x00000000 (nunca X)
//   2) Escribir y leer                -> el dato escrito
//   3) Lectura asincronica            -> la salida cambia sin flanco de clock
//   4) i_we = 0                       -> no escribe
//   5) Escribir no pisa vecinos       -> los cajones contiguos no cambian
//   6) Sobrescribir                   -> queda el valor nuevo
//   7) Extremos (cajon 0 y 255)       -> funcionan
//   8) Escritura sincronica           -> el valor cambia en el flanco, no antes
//
// Las entradas cambian 1 ns DESPUES del flanco de subida para evitar carreras.
//////////////////////////////////////////////////////////////////////////////////

module tb_imem;

    reg         i_clk;
    reg         i_we;
    reg  [7:0]  i_waddr;
    reg  [31:0] i_wdata;
    reg  [7:0]  i_raddr;
    wire [31:0] o_rdata;

    integer errores;

    imem dut (
        .i_clk   (i_clk),
        .i_we    (i_we),
        .i_waddr (i_waddr),
        .i_wdata (i_wdata),
        .i_raddr (i_raddr),
        .o_rdata (o_rdata)
    );

    // Clock de 100 MHz
    initial i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    // Espera un flanco de subida y 1 ns mas
    task tick;
        begin
            @(posedge i_clk);
            #1;
        end
    endtask

    // Escribe una palabra (ocupa un flanco de clock)
    task escribir;
        input [7:0]  addr;
        input [31:0] data;
        begin
            i_we    = 1'b1;
            i_waddr = addr;
            i_wdata = data;
            tick;
            i_we    = 1'b0;
        end
    endtask

    // Lee el cajon addr SIN esperar al clock (1 ns) y compara. Se usa !== para detectar X.
    task chequear;
        input [7:0]      addr;
        input [31:0]     esperado;
        input [8*32-1:0] nombre;
        begin
            i_raddr = addr;
            #1;
            if (o_rdata !== esperado) begin
                $display("ERROR [%0s] t=%0t ns: cajon %0d esperado 0x%08h, obtenido 0x%08h",
                         nombre, $time, addr, esperado, o_rdata);
                errores = errores + 1;
            end else begin
                $display("ok    [%0s] cajon %0d = 0x%08h", nombre, addr, o_rdata);
            end
        end
    endtask

    initial begin
        errores = 0;
        i_we    = 1'b0;
        i_waddr = 8'd0;
        i_wdata = 32'd0;
        i_raddr = 8'd0;
        #1;

        // 1) Cajones nunca escritos
        chequear(8'd0,   32'h00000000, "1 vacio");
        chequear(8'd100, 32'h00000000, "1 vacio");
        chequear(8'd255, 32'h00000000, "1 vacio");

        // 2) Escribir y leer
        escribir(8'd5, 32'hDEADBEEF);
        chequear(8'd5, 32'hDEADBEEF, "2 escribe-lee");

        // 3) Lectura asincronica: dos cajones leidos sin ningun flanco entre medio
        escribir(8'd7, 32'hAAAAAAAA);
        escribir(8'd8, 32'hBBBBBBBB);
        chequear(8'd7, 32'hAAAAAAAA, "3 asincrona");
        chequear(8'd8, 32'hBBBBBBBB, "3 asincrona");

        // 4) i_we = 0 no escribe
        i_we    = 1'b0;
        i_waddr = 8'd5;
        i_wdata = 32'h12345678;
        tick;
        chequear(8'd5, 32'hDEADBEEF, "4 we=0");

        // 5) Los vecinos del cajon 5 no cambiaron
        chequear(8'd4, 32'h00000000, "5 vecino");
        chequear(8'd6, 32'h00000000, "5 vecino");

        // 6) Sobrescribir
        escribir(8'd5, 32'h0BADCAFE);
        chequear(8'd5, 32'h0BADCAFE, "6 sobrescribe");

        // 7) Extremos
        escribir(8'd0,   32'h00000013);
        escribir(8'd255, 32'h00100073);
        chequear(8'd0,   32'h00000013, "7 extremo");
        chequear(8'd255, 32'h00100073, "7 extremo");

        // 8) Escritura sincronica: antes del flanco el valor es el viejo
        chequear(8'd20, 32'h00000000, "8 previo");
        i_we    = 1'b1;
        i_waddr = 8'd20;
        i_wdata = 32'hCAFEF00D;
        #1;
        chequear(8'd20, 32'h00000000, "8 antes flanco");
        tick;
        i_we = 1'b0;
        chequear(8'd20, 32'hCAFEF00D, "8 tras flanco");

        // Resultado final
        if (errores == 0)
            $display("TEST OK: imem paso todas las pruebas");
        else
            $display("TEST FALLO: %0d errores", errores);
        $finish;
    end

endmodule
