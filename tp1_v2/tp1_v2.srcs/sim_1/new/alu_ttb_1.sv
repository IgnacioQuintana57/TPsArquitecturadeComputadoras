`timescale 1ns/1ps

module alu_top_tb;

  localparam NB_DATA    = 8;
  localparam NB_OP_CODE = 6;
  localparam CLK_PERIOD = 10;
  localparam NUM_OPS    = 8;
  localparam [NB_OP_CODE-1:0] OP_ADD = 6'b100000;
  localparam [NB_OP_CODE-1:0] OP_SUB = 6'b100010;
  localparam [NB_OP_CODE-1:0] OP_AND = 6'b100100;
  localparam [NB_OP_CODE-1:0] OP_OR  = 6'b100101;
  localparam [NB_OP_CODE-1:0] OP_XOR = 6'b100110;
  localparam [NB_OP_CODE-1:0] OP_SRA = 6'b000011;
  localparam [NB_OP_CODE-1:0] OP_SRL = 6'b000010;
  localparam [NB_OP_CODE-1:0] OP_NOR = 6'b100111;

  reg                clk;
  reg  [NB_DATA-1:0] data;
  reg                btn_A;
  reg                btn_B;
  reg                btn_c;
  wire [NB_DATA-1:0] resultado;

  alu_top #(
    .NB_DATA    (NB_DATA),
    .NB_OP_CODE (NB_OP_CODE)
  ) dut (
    .i_clk       (clk),
    .i_data      (data),
    .i_btn_A     (btn_A),
    .i_btn_B     (btn_B),
    .i_btn_c     (btn_c),
    .o_resultado (resultado)
  );

  // Generación de clock (100MHz)
  initial clk = 0;
  always #(CLK_PERIOD/2) clk = ~clk;

  // Simula "apretar" un botón por un flanco de clock
  task cargar(input [NB_DATA-1:0] valor, input btnA, input btnB, input btnC);
    begin
      data  = valor;
      btn_A = btnA;
      btn_B = btnB;
      btn_c = btnC;
      @(posedge clk);
      #1;
      btn_A = 0; btn_B = 0; btn_c = 0;
    end
  endtask

  // Independent reference model used to check the DUT output.
  function [NB_DATA-1:0] calcular_esperado(
    input [NB_DATA-1:0]    a,
    input [NB_DATA-1:0]    b,
    input [NB_OP_CODE-1:0] op
  );
    begin
      case (op)
        OP_ADD: calcular_esperado = a + b;
        OP_SUB: calcular_esperado = a - b;
        OP_AND: calcular_esperado = a & b;
        OP_OR:  calcular_esperado = a | b;
        OP_XOR: calcular_esperado = a ^ b;
        OP_SRA: calcular_esperado = $signed(a) >>> b;
        OP_SRL: calcular_esperado = a >> b;
        OP_NOR: calcular_esperado = ~(a | b);
        default:   calcular_esperado = 0;
      endcase
    end
  endfunction

  reg [NB_OP_CODE-1:0] ops [0:NUM_OPS-1];
  string nombres_ops [0:NUM_OPS-1];
  integer test_a [0:NUM_OPS-1];
  integer test_b [0:NUM_OPS-1];
  integer ok_count, fail_count;
  integer operation_ok, operation_fail;

  task automatic probar_caso(
    input integer a_value,
    input integer b_value,
    input [NB_OP_CODE-1:0] op_value,
    input string op_name
  );
    reg [NB_DATA-1:0] expected;
    begin
      cargar(a_value[NB_DATA-1:0], 1, 0, 0);
      cargar(b_value[NB_DATA-1:0], 0, 1, 0);
      cargar(op_value, 0, 0, 1);

      // alu_top captures the result on the clock after the third load.
      @(posedge clk);
      #1;

      expected = calcular_esperado(a_value[NB_DATA-1:0], b_value[NB_DATA-1:0], op_value);
      if (resultado === expected) begin
        ok_count = ok_count + 1;
        operation_ok = operation_ok + 1;
        $display("PASS %-3s: %0d %s %0d = %0d",
                 op_name, a_value, op_name, b_value, resultado);
      end else begin
        fail_count = fail_count + 1;
        operation_fail = operation_fail + 1;
        $display("FAIL %-3s A=%0d B=%0d expected=%0d (%b) actual=%0d (%b)",
                 op_name, a_value, b_value, expected, expected, resultado, resultado);
      end
    end
  endtask

  initial begin
    ops[0] = OP_ADD; nombres_ops[0] = "ADD";
    ops[1] = OP_SUB; nombres_ops[1] = "SUB";
    ops[2] = OP_AND; nombres_ops[2] = "AND";
    ops[3] = OP_OR;  nombres_ops[3] = "OR";
    ops[4] = OP_XOR; nombres_ops[4] = "XOR";
    ops[5] = OP_SRA; nombres_ops[5] = "SRA";
    ops[6] = OP_SRL; nombres_ops[6] = "SRL";
    ops[7] = OP_NOR; nombres_ops[7] = "NOR";

    // One easy-to-check vector per operation.
    test_a[0] = 1;  test_b[0] = 2;  // 1 + 2 = 3
    test_a[1] = 3;  test_b[1] = 2;  // 3 - 2 = 1
    test_a[2] = 6;  test_b[2] = 3;  // 6 & 3 = 2
    test_a[3] = 4;  test_b[3] = 1;  // 4 | 1 = 5
    test_a[4] = 7;  test_b[4] = 3;  // 7 ^ 3 = 4
    test_a[5] = 8;  test_b[5] = 1;  // 8 >>> 1 = 4
    test_a[6] = 8;  test_b[6] = 1;  // 8 >> 1 = 4
    test_a[7] = 4;  test_b[7] = 1;  // ~(4 | 1) = 250 (8 bits)

    ok_count   = 0;
    fail_count = 0;

    data = 0; btn_A = 0; btn_B = 0; btn_c = 0;
    @(posedge clk);

    for (integer i = 0; i < NUM_OPS; i = i + 1) begin
      operation_ok = 0;
      operation_fail = 0;

      probar_caso(test_a[i], test_b[i], ops[i], nombres_ops[i]);

      $display("%-3s: %0d OK / %0d FALLO", nombres_ops[i], operation_ok, operation_fail);
    end

    $display("---- Resumen: %0d OK / %0d FALLO (esperados: 8 casos) ----", ok_count, fail_count);
    if (fail_count != 0)
      $fatal(1, "Deterministic ALU testbench failed");
    else
      $finish;
  end

endmodule
