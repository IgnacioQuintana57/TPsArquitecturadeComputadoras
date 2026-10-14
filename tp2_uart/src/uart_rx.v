`timescale 1ns / 1ps
// ============================================================
// Receptor UART  (implementa el "Diagrama de estados Rx" de los slides)
//   idle  -> espera rx == 0 (inicio del start bit)
//   start -> cuenta 7 ticks (mitad del start bit)
//   data  -> cada 16 ticks toma un bit (LSB primero) en un shift register
//   stop  -> espera SB_TICK ticks y levanta o_rx_done durante 1 ciclo
// ============================================================
module uart_rx #(
    parameter NB_DATA = 8,    // bits de datos
    parameter SB_TICK = 16    // ticks del stop bit (16 = 1 stop bit)
)(
    input  wire               i_clk,
    input  wire               i_reset,
    input  wire               i_rx,
    input  wire               i_tick,
    output reg                o_rx_done,
    output wire [NB_DATA-1:0] o_data
);
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     DATA  = 2'b10,
                     STOP  = 2'b11;

    reg [1:0]         state,  next_state;
    reg [3:0]         c_ticks;      // contador de ticks (0..15)
    reg [3:0]         c_ticks_next;      // Proximo valor delcontador de ticks (0..15)
    reg [2:0]         c_bits_procesados;      // contador de bits recibidos
    reg [2:0]         c_bits_procesados_next;      // Proximo valor del contador de bits recibidos
    reg [NB_DATA-1:0] dato_recibido;      // shift register de datos
    reg [NB_DATA-1:0] next_dato_recibido;      // Proximo valor del shift register de datos

    // Sincronizador de 2 FF: rx viene de afuera (asincronico al clk)
    reg rx_meta, rx_sync;
    always @(posedge i_clk) begin
        rx_meta <= i_rx;
        rx_sync <= rx_meta;
    end

    // ---------------- Memoria ----------------
    always @(posedge i_clk) begin
        if (i_reset) begin //se reseta todo a 0
            state <= IDLE;
            c_ticks <= 0;
            c_bits_procesados <= 0;
            dato_recibido <= 0;
        end else begin // Setea las variables a sus proximos valores. Esto lo hace en cada clock, pero la actualizacion de los next lo hace segun el tick del baudrate.
            state <= next_state;
            c_ticks <= c_ticks_next;
            c_bits_procesados <= c_bits_procesados_next;
            dato_recibido <= next_dato_recibido;
        end
    end

    // ------- Logica de proximo estado y salidas -------
    always @(*) begin
        next_state = state;
        c_ticks_next     = c_ticks;
        c_bits_procesados_next     = c_bits_procesados;
        next_dato_recibido     = dato_recibido;
        o_rx_done  = 1'b0;

        case (state)
            IDLE:
                if (~rx_sync) begin
                    next_state = START;
                    c_ticks_next     = 0;
                end

            START:
                if (i_tick) begin
                    if (c_ticks == 7) begin
                        next_state = DATA;
                        c_ticks_next     = 0;
                        c_bits_procesados_next     = 0;
                    end else
                        c_ticks_next = c_ticks + 1'b1;
                end

            DATA:
                if (i_tick) begin
                    if (c_ticks == 15) begin
                        c_ticks_next = 0;
                     next_dato_recibido = {rx_sync, dato_recibido[NB_DATA-1:1]};
                        if (c_bits_procesados == NB_DATA - 1)
                            next_state = STOP;
                        else
                            c_bits_procesados_next = c_bits_procesados + 1'b1;
                    end else
                        c_ticks_next = c_ticks + 1'b1;
                end

            STOP:
                if (i_tick) begin
                    if (c_ticks == SB_TICK - 1) begin
                        next_state = IDLE;
                        o_rx_done  = 1'b1;
                    end else
                        c_ticks_next = c_ticks + 1'b1;
                end

            default: next_state = IDLE;   // fault recovery
        endcase
    end

    assign o_data = dato_recibido;
endmodule
