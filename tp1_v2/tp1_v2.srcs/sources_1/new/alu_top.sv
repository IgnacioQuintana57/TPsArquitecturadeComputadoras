module alu_top #(
  parameter NB_DATA    = 8,
  parameter NB_OP_CODE = 6
)(
  input                       i_clk,
  input  [NB_DATA - 1:0]      i_data,
  input                       i_btn_A,
  input                       i_btn_B,
  input                       i_btn_c,
  input                       i_btn_rst,
  output reg [NB_DATA - 1:0]  o_resultado = {NB_DATA{1'b1}}
);

  reg [NB_DATA - 1:0]    dato_A;
  reg [NB_DATA - 1:0]    dato_B;
  reg [NB_OP_CODE - 1:0] codigo_op;

  reg a_cargado, b_cargado, c_cargado;
  wire todos_cargados = a_cargado && b_cargado && c_cargado;

  wire [NB_DATA - 1:0] resultado_comb;

  always @(posedge i_clk) begin
    // Carga de registros según qué botón se apretó
    if (i_btn_A) begin
      dato_A    <= i_data;
      a_cargado <= 1'b1;
    end else if (i_btn_B) begin
      dato_B    <= i_data;
      b_cargado <= 1'b1;
    end else if (i_btn_c) begin
      codigo_op <= i_data[NB_OP_CODE - 1:0];
      c_cargado <= 1'b1;
    end

    // Recién cuando ya entraron los 3, capturo el resultado y reseteo las banderas
    if (a_cargado && b_cargado && c_cargado) begin
      o_resultado <= resultado_comb;
      a_cargado   <= 1'b0;
      b_cargado   <= 1'b0;
      c_cargado   <= 1'b0;
    end
    
    if(i_btn_rst) begin
      o_resultado <= {NB_DATA{1'b0}};
      a_cargado   <= 1'b0;
      b_cargado   <= 1'b0;
      c_cargado   <= 1'b0;
      dato_A      <= {NB_DATA{1'b0}};
      dato_B      <= {NB_DATA{1'b0}};
      codigo_op   <= {NB_OP_CODE{1'b0}};
    end
  end

  alu_core #(
    .NB_DATA    (NB_DATA),
    .NB_OP_CODE (NB_OP_CODE)
  ) u_alu_core (
    .dato_A    (dato_A),
    .dato_B    (dato_B),
    .codigo_op (codigo_op),
    .resultado (resultado_comb)
  );

endmodule