module alu_core #(
  parameter NB_DATA    = 8,
  parameter NB_OP_CODE = 6
)(
  input  [NB_DATA - 1:0]    dato_A,
  input  [NB_DATA - 1:0]    dato_B,
  input  [NB_OP_CODE - 1:0] codigo_op,
  output reg [NB_DATA - 1:0] resultado
);

  always @(*) begin
    resultado = 0;
    case (codigo_op)
      6'b100000: resultado = dato_A + dato_B; //ADD
      6'b100010: resultado = dato_A - dato_B; //SUB
      6'b100100: resultado = dato_A & dato_B; //AND
      6'b100101: resultado = dato_A | dato_B; //OR
      6'b100110: resultado = dato_A ^ dato_B; //XOR
      6'b000011: resultado = $signed(dato_A) >>> dato_B; //SRA
      6'b000010: resultado = dato_A >> dato_B; //SRL
      6'b100111: resultado = ~(dato_A | dato_B); //NOR
      default:   resultado = 0;
    endcase
  end

endmodule