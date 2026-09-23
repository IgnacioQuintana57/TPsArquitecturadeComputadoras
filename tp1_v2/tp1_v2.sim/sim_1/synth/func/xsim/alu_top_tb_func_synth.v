// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Wed Sep 16 19:00:51 2026
// Host        : ZENBOOK-NACHO running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               D:/Proyectos/Facultad/TPsArquitecturadeComputadoras/tp1_v2/tp1_v2.sim/sim_1/synth/func/xsim/alu_top_tb_func_synth.v
// Design      : alu_top
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module alu_core
   (D,
    Q,
    \o_resultado_reg[7] ,
    \o_resultado_reg[2] );
  output [7:0]D;
  input [7:0]Q;
  input [7:0]\o_resultado_reg[7] ;
  input [5:0]\o_resultado_reg[2] ;

  wire [7:0]D;
  wire [7:0]Q;
  wire [7:0]data0;
  wire [7:0]data1;
  wire i__carry__0_i_1_n_0;
  wire i__carry__0_i_2_n_0;
  wire i__carry__0_i_3_n_0;
  wire i__carry__0_i_4_n_0;
  wire i__carry_i_1_n_0;
  wire i__carry_i_2_n_0;
  wire i__carry_i_3_n_0;
  wire i__carry_i_4_n_0;
  wire \o_resultado[0]_i_2_n_0 ;
  wire \o_resultado[0]_i_3_n_0 ;
  wire \o_resultado[0]_i_4_n_0 ;
  wire \o_resultado[0]_i_5_n_0 ;
  wire \o_resultado[0]_i_6_n_0 ;
  wire \o_resultado[0]_i_7_n_0 ;
  wire \o_resultado[1]_i_2_n_0 ;
  wire \o_resultado[1]_i_3_n_0 ;
  wire \o_resultado[1]_i_4_n_0 ;
  wire \o_resultado[1]_i_5_n_0 ;
  wire \o_resultado[2]_i_2_n_0 ;
  wire \o_resultado[2]_i_3_n_0 ;
  wire \o_resultado[2]_i_4_n_0 ;
  wire \o_resultado[2]_i_5_n_0 ;
  wire \o_resultado[2]_i_6_n_0 ;
  wire \o_resultado[3]_i_2_n_0 ;
  wire \o_resultado[3]_i_3_n_0 ;
  wire \o_resultado[3]_i_4_n_0 ;
  wire \o_resultado[3]_i_5_n_0 ;
  wire \o_resultado[3]_i_6_n_0 ;
  wire \o_resultado[4]_i_2_n_0 ;
  wire \o_resultado[4]_i_3_n_0 ;
  wire \o_resultado[4]_i_4_n_0 ;
  wire \o_resultado[4]_i_5_n_0 ;
  wire \o_resultado[4]_i_6_n_0 ;
  wire \o_resultado[5]_i_2_n_0 ;
  wire \o_resultado[5]_i_3_n_0 ;
  wire \o_resultado[5]_i_4_n_0 ;
  wire \o_resultado[5]_i_5_n_0 ;
  wire \o_resultado[6]_i_2_n_0 ;
  wire \o_resultado[6]_i_3_n_0 ;
  wire \o_resultado[6]_i_4_n_0 ;
  wire \o_resultado[6]_i_5_n_0 ;
  wire \o_resultado[6]_i_6_n_0 ;
  wire \o_resultado[6]_i_7_n_0 ;
  wire \o_resultado[6]_i_8_n_0 ;
  wire \o_resultado[6]_i_9_n_0 ;
  wire \o_resultado[7]_i_2_n_0 ;
  wire \o_resultado[7]_i_3_n_0 ;
  wire \o_resultado[7]_i_4_n_0 ;
  wire \o_resultado[7]_i_5_n_0 ;
  wire \o_resultado[7]_i_6_n_0 ;
  wire \o_resultado[7]_i_7_n_0 ;
  wire \o_resultado[7]_i_8_n_0 ;
  wire [5:0]\o_resultado_reg[2] ;
  wire [7:0]\o_resultado_reg[7] ;
  wire resultado0_carry__0_i_1_n_0;
  wire resultado0_carry__0_i_2_n_0;
  wire resultado0_carry__0_i_3_n_0;
  wire resultado0_carry__0_i_4_n_0;
  wire resultado0_carry__0_n_1;
  wire resultado0_carry__0_n_2;
  wire resultado0_carry__0_n_3;
  wire resultado0_carry_i_1_n_0;
  wire resultado0_carry_i_2_n_0;
  wire resultado0_carry_i_3_n_0;
  wire resultado0_carry_i_4_n_0;
  wire resultado0_carry_n_0;
  wire resultado0_carry_n_1;
  wire resultado0_carry_n_2;
  wire resultado0_carry_n_3;
  wire \resultado0_inferred__0/i__carry__0_n_1 ;
  wire \resultado0_inferred__0/i__carry__0_n_2 ;
  wire \resultado0_inferred__0/i__carry__0_n_3 ;
  wire \resultado0_inferred__0/i__carry_n_0 ;
  wire \resultado0_inferred__0/i__carry_n_1 ;
  wire \resultado0_inferred__0/i__carry_n_2 ;
  wire \resultado0_inferred__0/i__carry_n_3 ;
  wire [3:3]NLW_resultado0_carry__0_CO_UNCONNECTED;
  wire [3:3]\NLW_resultado0_inferred__0/i__carry__0_CO_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h9)) 
    i__carry__0_i_1
       (.I0(Q[7]),
        .I1(\o_resultado_reg[7] [7]),
        .O(i__carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry__0_i_2
       (.I0(Q[6]),
        .I1(\o_resultado_reg[7] [6]),
        .O(i__carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry__0_i_3
       (.I0(Q[5]),
        .I1(\o_resultado_reg[7] [5]),
        .O(i__carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry__0_i_4
       (.I0(Q[4]),
        .I1(\o_resultado_reg[7] [4]),
        .O(i__carry__0_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_1
       (.I0(Q[3]),
        .I1(\o_resultado_reg[7] [3]),
        .O(i__carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_2
       (.I0(Q[2]),
        .I1(\o_resultado_reg[7] [2]),
        .O(i__carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_3
       (.I0(Q[1]),
        .I1(\o_resultado_reg[7] [1]),
        .O(i__carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    i__carry_i_4
       (.I0(Q[0]),
        .I1(\o_resultado_reg[7] [0]),
        .O(i__carry_i_4_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFF8F8F8F8F8)) 
    \o_resultado[0]_i_1 
       (.I0(\o_resultado[0]_i_2_n_0 ),
        .I1(\o_resultado[6]_i_5_n_0 ),
        .I2(\o_resultado[0]_i_3_n_0 ),
        .I3(\o_resultado[0]_i_4_n_0 ),
        .I4(\o_resultado[0]_i_5_n_0 ),
        .I5(\o_resultado[7]_i_6_n_0 ),
        .O(D[0]));
  LUT4 #(
    .INIT(16'h0008)) 
    \o_resultado[0]_i_2 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(\o_resultado_reg[2] [0]),
        .I2(\o_resultado_reg[2] [2]),
        .I3(\o_resultado[6]_i_8_n_0 ),
        .O(\o_resultado[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0808080808000000)) 
    \o_resultado[0]_i_3 
       (.I0(\o_resultado[6]_i_8_n_0 ),
        .I1(\o_resultado[6]_i_5_n_0 ),
        .I2(\o_resultado_reg[2] [2]),
        .I3(\o_resultado[1]_i_5_n_0 ),
        .I4(Q[0]),
        .I5(\o_resultado[0]_i_6_n_0 ),
        .O(\o_resultado[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[0]_i_4 
       (.I0(Q[0]),
        .I1(\o_resultado_reg[7] [0]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[0]),
        .O(\o_resultado[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[0]_i_5 
       (.I0(data0[0]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [0]),
        .I5(Q[0]),
        .O(\o_resultado[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FF00E2E2)) 
    \o_resultado[0]_i_6 
       (.I0(\o_resultado_reg[7] [0]),
        .I1(Q[2]),
        .I2(\o_resultado_reg[7] [4]),
        .I3(\o_resultado[0]_i_7_n_0 ),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(\o_resultado[0]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \o_resultado[0]_i_7 
       (.I0(\o_resultado_reg[7] [6]),
        .I1(Q[2]),
        .I2(\o_resultado_reg[7] [2]),
        .O(\o_resultado[0]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFE0E0E0)) 
    \o_resultado[1]_i_1 
       (.I0(\o_resultado[1]_i_2_n_0 ),
        .I1(\o_resultado[1]_i_3_n_0 ),
        .I2(\o_resultado[7]_i_6_n_0 ),
        .I3(\o_resultado[1]_i_4_n_0 ),
        .I4(\o_resultado[6]_i_5_n_0 ),
        .O(D[1]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[1]_i_2 
       (.I0(Q[1]),
        .I1(\o_resultado_reg[7] [1]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[1]),
        .O(\o_resultado[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[1]_i_3 
       (.I0(data0[1]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [1]),
        .I5(Q[1]),
        .O(\o_resultado[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFAABAAAAAAABAAA)) 
    \o_resultado[1]_i_4 
       (.I0(\o_resultado[0]_i_2_n_0 ),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado[1]_i_5_n_0 ),
        .I3(\o_resultado[6]_i_8_n_0 ),
        .I4(Q[0]),
        .I5(\o_resultado[2]_i_5_n_0 ),
        .O(\o_resultado[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFCFC0C0CFA0AFA0A)) 
    \o_resultado[1]_i_5 
       (.I0(\o_resultado_reg[7] [1]),
        .I1(\o_resultado_reg[7] [5]),
        .I2(Q[1]),
        .I3(\o_resultado_reg[7] [3]),
        .I4(\o_resultado_reg[7] [7]),
        .I5(Q[2]),
        .O(\o_resultado[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF000E0000)) 
    \o_resultado[2]_i_1 
       (.I0(\o_resultado[2]_i_2_n_0 ),
        .I1(\o_resultado[2]_i_3_n_0 ),
        .I2(\o_resultado_reg[2] [4]),
        .I3(\o_resultado_reg[2] [3]),
        .I4(\o_resultado_reg[2] [5]),
        .I5(\o_resultado[2]_i_4_n_0 ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[2]_i_2 
       (.I0(Q[2]),
        .I1(\o_resultado_reg[7] [2]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[2]),
        .O(\o_resultado[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[2]_i_3 
       (.I0(data0[2]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [2]),
        .I5(Q[2]),
        .O(\o_resultado[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAA8A008000)) 
    \o_resultado[2]_i_4 
       (.I0(\o_resultado[6]_i_5_n_0 ),
        .I1(\o_resultado[3]_i_5_n_0 ),
        .I2(Q[0]),
        .I3(\o_resultado[6]_i_8_n_0 ),
        .I4(\o_resultado[2]_i_5_n_0 ),
        .I5(\o_resultado[0]_i_2_n_0 ),
        .O(\o_resultado[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FF80FF00)) 
    \o_resultado[2]_i_5 
       (.I0(Q[1]),
        .I1(Q[2]),
        .I2(\o_resultado_reg[7] [7]),
        .I3(\o_resultado[2]_i_6_n_0 ),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[2] [2]),
        .O(\o_resultado[2]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \o_resultado[2]_i_6 
       (.I0(\o_resultado_reg[7] [4]),
        .I1(Q[1]),
        .I2(\o_resultado_reg[7] [6]),
        .I3(Q[2]),
        .I4(\o_resultado_reg[7] [2]),
        .O(\o_resultado[2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF000E0000)) 
    \o_resultado[3]_i_1 
       (.I0(\o_resultado[3]_i_2_n_0 ),
        .I1(\o_resultado[3]_i_3_n_0 ),
        .I2(\o_resultado_reg[2] [4]),
        .I3(\o_resultado_reg[2] [3]),
        .I4(\o_resultado_reg[2] [5]),
        .I5(\o_resultado[3]_i_4_n_0 ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[3]_i_2 
       (.I0(Q[3]),
        .I1(\o_resultado_reg[7] [3]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[3]),
        .O(\o_resultado[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[3]_i_3 
       (.I0(data0[3]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [3]),
        .I5(Q[3]),
        .O(\o_resultado[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAA0800080)) 
    \o_resultado[3]_i_4 
       (.I0(\o_resultado[6]_i_5_n_0 ),
        .I1(\o_resultado[3]_i_5_n_0 ),
        .I2(\o_resultado[6]_i_8_n_0 ),
        .I3(Q[0]),
        .I4(\o_resultado[4]_i_5_n_0 ),
        .I5(\o_resultado[0]_i_2_n_0 ),
        .O(\o_resultado[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000FF80FF00)) 
    \o_resultado[3]_i_5 
       (.I0(Q[1]),
        .I1(Q[2]),
        .I2(\o_resultado_reg[7] [7]),
        .I3(\o_resultado[3]_i_6_n_0 ),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[2] [2]),
        .O(\o_resultado[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h3300B8B8)) 
    \o_resultado[3]_i_6 
       (.I0(\o_resultado_reg[7] [5]),
        .I1(Q[1]),
        .I2(\o_resultado_reg[7] [3]),
        .I3(\o_resultado_reg[7] [7]),
        .I4(Q[2]),
        .O(\o_resultado[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF000E0000)) 
    \o_resultado[4]_i_1 
       (.I0(\o_resultado[4]_i_2_n_0 ),
        .I1(\o_resultado[4]_i_3_n_0 ),
        .I2(\o_resultado_reg[2] [4]),
        .I3(\o_resultado_reg[2] [3]),
        .I4(\o_resultado_reg[2] [5]),
        .I5(\o_resultado[4]_i_4_n_0 ),
        .O(D[4]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[4]_i_2 
       (.I0(Q[4]),
        .I1(\o_resultado_reg[7] [4]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[4]),
        .O(\o_resultado[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[4]_i_3 
       (.I0(data0[4]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [4]),
        .I5(Q[4]),
        .O(\o_resultado[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAA8A008000)) 
    \o_resultado[4]_i_4 
       (.I0(\o_resultado[6]_i_5_n_0 ),
        .I1(\o_resultado[5]_i_5_n_0 ),
        .I2(Q[0]),
        .I3(\o_resultado[6]_i_8_n_0 ),
        .I4(\o_resultado[4]_i_5_n_0 ),
        .I5(\o_resultado[0]_i_2_n_0 ),
        .O(\o_resultado[4]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h0000F8F0)) 
    \o_resultado[4]_i_5 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[2]),
        .I2(\o_resultado[4]_i_6_n_0 ),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[2] [2]),
        .O(\o_resultado[4]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h00CA)) 
    \o_resultado[4]_i_6 
       (.I0(\o_resultado_reg[7] [4]),
        .I1(\o_resultado_reg[7] [6]),
        .I2(Q[1]),
        .I3(Q[2]),
        .O(\o_resultado[4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF000E0000)) 
    \o_resultado[5]_i_1 
       (.I0(\o_resultado[5]_i_2_n_0 ),
        .I1(\o_resultado[5]_i_3_n_0 ),
        .I2(\o_resultado_reg[2] [4]),
        .I3(\o_resultado_reg[2] [3]),
        .I4(\o_resultado_reg[2] [5]),
        .I5(\o_resultado[5]_i_4_n_0 ),
        .O(D[5]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[5]_i_2 
       (.I0(Q[5]),
        .I1(\o_resultado_reg[7] [5]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[5]),
        .O(\o_resultado[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[5]_i_3 
       (.I0(data0[5]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [5]),
        .I5(Q[5]),
        .O(\o_resultado[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAAAA0800080)) 
    \o_resultado[5]_i_4 
       (.I0(\o_resultado[6]_i_5_n_0 ),
        .I1(\o_resultado[5]_i_5_n_0 ),
        .I2(\o_resultado[6]_i_8_n_0 ),
        .I3(Q[0]),
        .I4(\o_resultado[6]_i_9_n_0 ),
        .I5(\o_resultado[0]_i_2_n_0 ),
        .O(\o_resultado[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000ABA80B08)) 
    \o_resultado[5]_i_5 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(\o_resultado_reg[7] [5]),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[2] [2]),
        .O(\o_resultado[5]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'hFFE0E0E0)) 
    \o_resultado[6]_i_1 
       (.I0(\o_resultado[6]_i_2_n_0 ),
        .I1(\o_resultado[6]_i_3_n_0 ),
        .I2(\o_resultado[7]_i_6_n_0 ),
        .I3(\o_resultado[6]_i_4_n_0 ),
        .I4(\o_resultado[6]_i_5_n_0 ),
        .O(D[6]));
  LUT6 #(
    .INIT(64'h120FE0001200E000)) 
    \o_resultado[6]_i_2 
       (.I0(Q[6]),
        .I1(\o_resultado_reg[7] [6]),
        .I2(\o_resultado_reg[2] [0]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [1]),
        .I5(data1[6]),
        .O(\o_resultado[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0C0E000200C20002)) 
    \o_resultado[6]_i_3 
       (.I0(data0[6]),
        .I1(\o_resultado_reg[2] [2]),
        .I2(\o_resultado_reg[2] [1]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [6]),
        .I5(Q[6]),
        .O(\o_resultado[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hEAFFC0C0EA00C0C0)) 
    \o_resultado[6]_i_4 
       (.I0(\o_resultado[6]_i_6_n_0 ),
        .I1(\o_resultado_reg[7] [7]),
        .I2(\o_resultado[6]_i_7_n_0 ),
        .I3(Q[0]),
        .I4(\o_resultado[6]_i_8_n_0 ),
        .I5(\o_resultado[6]_i_9_n_0 ),
        .O(\o_resultado[6]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h0004)) 
    \o_resultado[6]_i_5 
       (.I0(\o_resultado_reg[2] [5]),
        .I1(\o_resultado_reg[2] [1]),
        .I2(\o_resultado_reg[2] [4]),
        .I3(\o_resultado_reg[2] [3]),
        .O(\o_resultado[6]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h0004)) 
    \o_resultado[6]_i_6 
       (.I0(\o_resultado_reg[2] [2]),
        .I1(\o_resultado_reg[7] [7]),
        .I2(Q[2]),
        .I3(Q[1]),
        .O(\o_resultado[6]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \o_resultado[6]_i_7 
       (.I0(\o_resultado_reg[2] [0]),
        .I1(\o_resultado_reg[2] [2]),
        .O(\o_resultado[6]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \o_resultado[6]_i_8 
       (.I0(Q[3]),
        .I1(Q[4]),
        .I2(Q[5]),
        .I3(Q[7]),
        .I4(Q[6]),
        .O(\o_resultado[6]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h00000000ABA80300)) 
    \o_resultado[6]_i_9 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(\o_resultado_reg[7] [6]),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[2] [2]),
        .O(\o_resultado[6]_i_9_n_0 ));
  LUT5 #(
    .INIT(32'hFFFEAAAA)) 
    \o_resultado[7]_i_1 
       (.I0(\o_resultado[7]_i_2_n_0 ),
        .I1(\o_resultado[7]_i_3_n_0 ),
        .I2(\o_resultado[7]_i_4_n_0 ),
        .I3(\o_resultado[7]_i_5_n_0 ),
        .I4(\o_resultado[7]_i_6_n_0 ),
        .O(D[7]));
  LUT6 #(
    .INIT(64'h00F0001000000000)) 
    \o_resultado[7]_i_2 
       (.I0(\o_resultado[7]_i_7_n_0 ),
        .I1(\o_resultado[7]_i_8_n_0 ),
        .I2(\o_resultado[6]_i_5_n_0 ),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[7] [7]),
        .O(\o_resultado[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000880088F0)) 
    \o_resultado[7]_i_3 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[7]),
        .I2(data0[7]),
        .I3(\o_resultado_reg[2] [2]),
        .I4(\o_resultado_reg[2] [0]),
        .I5(\o_resultado_reg[2] [1]),
        .O(\o_resultado[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h3008300830080008)) 
    \o_resultado[7]_i_4 
       (.I0(data1[7]),
        .I1(\o_resultado_reg[2] [1]),
        .I2(\o_resultado_reg[2] [2]),
        .I3(\o_resultado_reg[2] [0]),
        .I4(\o_resultado_reg[7] [7]),
        .I5(Q[7]),
        .O(\o_resultado[7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h10006000)) 
    \o_resultado[7]_i_5 
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[7]),
        .I2(\o_resultado_reg[2] [2]),
        .I3(\o_resultado_reg[2] [1]),
        .I4(\o_resultado_reg[2] [0]),
        .O(\o_resultado[7]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \o_resultado[7]_i_6 
       (.I0(\o_resultado_reg[2] [4]),
        .I1(\o_resultado_reg[2] [3]),
        .I2(\o_resultado_reg[2] [5]),
        .O(\o_resultado[7]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \o_resultado[7]_i_7 
       (.I0(Q[1]),
        .I1(Q[2]),
        .O(\o_resultado[7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \o_resultado[7]_i_8 
       (.I0(Q[0]),
        .I1(Q[6]),
        .I2(Q[7]),
        .I3(Q[5]),
        .I4(Q[4]),
        .I5(Q[3]),
        .O(\o_resultado[7]_i_8_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 resultado0_carry
       (.CI(1'b0),
        .CO({resultado0_carry_n_0,resultado0_carry_n_1,resultado0_carry_n_2,resultado0_carry_n_3}),
        .CYINIT(1'b0),
        .DI(\o_resultado_reg[7] [3:0]),
        .O(data0[3:0]),
        .S({resultado0_carry_i_1_n_0,resultado0_carry_i_2_n_0,resultado0_carry_i_3_n_0,resultado0_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 resultado0_carry__0
       (.CI(resultado0_carry_n_0),
        .CO({NLW_resultado0_carry__0_CO_UNCONNECTED[3],resultado0_carry__0_n_1,resultado0_carry__0_n_2,resultado0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,\o_resultado_reg[7] [6:4]}),
        .O(data0[7:4]),
        .S({resultado0_carry__0_i_1_n_0,resultado0_carry__0_i_2_n_0,resultado0_carry__0_i_3_n_0,resultado0_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry__0_i_1
       (.I0(\o_resultado_reg[7] [7]),
        .I1(Q[7]),
        .O(resultado0_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry__0_i_2
       (.I0(\o_resultado_reg[7] [6]),
        .I1(Q[6]),
        .O(resultado0_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry__0_i_3
       (.I0(\o_resultado_reg[7] [5]),
        .I1(Q[5]),
        .O(resultado0_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry__0_i_4
       (.I0(\o_resultado_reg[7] [4]),
        .I1(Q[4]),
        .O(resultado0_carry__0_i_4_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry_i_1
       (.I0(\o_resultado_reg[7] [3]),
        .I1(Q[3]),
        .O(resultado0_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry_i_2
       (.I0(\o_resultado_reg[7] [2]),
        .I1(Q[2]),
        .O(resultado0_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry_i_3
       (.I0(\o_resultado_reg[7] [1]),
        .I1(Q[1]),
        .O(resultado0_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    resultado0_carry_i_4
       (.I0(\o_resultado_reg[7] [0]),
        .I1(Q[0]),
        .O(resultado0_carry_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \resultado0_inferred__0/i__carry 
       (.CI(1'b0),
        .CO({\resultado0_inferred__0/i__carry_n_0 ,\resultado0_inferred__0/i__carry_n_1 ,\resultado0_inferred__0/i__carry_n_2 ,\resultado0_inferred__0/i__carry_n_3 }),
        .CYINIT(1'b1),
        .DI(\o_resultado_reg[7] [3:0]),
        .O(data1[3:0]),
        .S({i__carry_i_1_n_0,i__carry_i_2_n_0,i__carry_i_3_n_0,i__carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \resultado0_inferred__0/i__carry__0 
       (.CI(\resultado0_inferred__0/i__carry_n_0 ),
        .CO({\NLW_resultado0_inferred__0/i__carry__0_CO_UNCONNECTED [3],\resultado0_inferred__0/i__carry__0_n_1 ,\resultado0_inferred__0/i__carry__0_n_2 ,\resultado0_inferred__0/i__carry__0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,\o_resultado_reg[7] [6:4]}),
        .O(data1[7:4]),
        .S({i__carry__0_i_1_n_0,i__carry__0_i_2_n_0,i__carry__0_i_3_n_0,i__carry__0_i_4_n_0}));
endmodule

(* NB_DATA = "8" *) (* NB_OP_CODE = "6" *) 
(* NotValidForBitStream *)
(* \DesignAttr:TELEMETRY_DATA  = "{\n  \"Design Characteristics Data\": {\n    \"Simulation\": {\n      \"Target Simulator\": \"XSim\",\n      \"Run Time\": {\n        \"behavioral \": \"5.437000\"\n      }\n    }\n  },\n  \"Design Flow Data\": {\n    \"Design Data\": {\n      \"Design Mode\": \"Project flow\",\n      \"Top Methodology\": \"SystemVerilog\"\n    },\n    \"Synthesis\": {\n      \"Run Time\": \"25.378000 seconds\"\n    }\n  }\n}" *) 
module alu_top
   (i_clk,
    i_data,
    i_btn_A,
    i_btn_B,
    i_btn_c,
    o_resultado);
  input i_clk;
  input [7:0]i_data;
  input i_btn_A;
  input i_btn_B;
  input i_btn_c;
  output [7:0]o_resultado;

  wire a_cargado;
  wire b_cargado_i_1_n_0;
  wire b_cargado_reg_n_0;
  wire c_cargado_i_1_n_0;
  wire c_cargado_reg_n_0;
  wire \codigo_op[5]_i_1_n_0 ;
  wire \codigo_op_reg_n_0_[0] ;
  wire \codigo_op_reg_n_0_[1] ;
  wire \codigo_op_reg_n_0_[2] ;
  wire \codigo_op_reg_n_0_[3] ;
  wire \codigo_op_reg_n_0_[4] ;
  wire \codigo_op_reg_n_0_[5] ;
  wire [7:0]dato_A;
  wire \dato_B[7]_i_1_n_0 ;
  wire \dato_B_reg_n_0_[0] ;
  wire \dato_B_reg_n_0_[1] ;
  wire \dato_B_reg_n_0_[2] ;
  wire \dato_B_reg_n_0_[3] ;
  wire \dato_B_reg_n_0_[4] ;
  wire \dato_B_reg_n_0_[5] ;
  wire \dato_B_reg_n_0_[6] ;
  wire \dato_B_reg_n_0_[7] ;
  wire i_btn_A;
  wire i_btn_A_IBUF;
  wire i_btn_B;
  wire i_btn_B_IBUF;
  wire i_btn_c;
  wire i_btn_c_IBUF;
  wire i_clk;
  wire i_clk_IBUF;
  wire i_clk_IBUF_BUFG;
  wire [7:0]i_data;
  wire [7:0]i_data_IBUF;
  wire [7:0]o_resultado;
  wire [7:0]o_resultado_OBUF;
  wire [7:0]resultado;
  wire todos_cargados;

  LUT3 #(
    .INIT(8'h80)) 
    a_cargado_i_1
       (.I0(a_cargado),
        .I1(b_cargado_reg_n_0),
        .I2(c_cargado_reg_n_0),
        .O(todos_cargados));
  FDRE #(
    .INIT(1'b0)) 
    a_cargado_reg
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_btn_A_IBUF),
        .Q(a_cargado),
        .R(todos_cargados));
  LUT5 #(
    .INIT(32'h0F22FF22)) 
    b_cargado_i_1
       (.I0(i_btn_B_IBUF),
        .I1(i_btn_A_IBUF),
        .I2(c_cargado_reg_n_0),
        .I3(b_cargado_reg_n_0),
        .I4(a_cargado),
        .O(b_cargado_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    b_cargado_reg
       (.C(i_clk_IBUF_BUFG),
        .CE(1'b1),
        .D(b_cargado_i_1_n_0),
        .Q(b_cargado_reg_n_0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0004FF04FF04FF04)) 
    c_cargado_i_1
       (.I0(i_btn_B_IBUF),
        .I1(i_btn_c_IBUF),
        .I2(i_btn_A_IBUF),
        .I3(c_cargado_reg_n_0),
        .I4(b_cargado_reg_n_0),
        .I5(a_cargado),
        .O(c_cargado_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    c_cargado_reg
       (.C(i_clk_IBUF_BUFG),
        .CE(1'b1),
        .D(c_cargado_i_1_n_0),
        .Q(c_cargado_reg_n_0),
        .R(1'b0));
  LUT3 #(
    .INIT(8'h04)) 
    \codigo_op[5]_i_1 
       (.I0(i_btn_B_IBUF),
        .I1(i_btn_c_IBUF),
        .I2(i_btn_A_IBUF),
        .O(\codigo_op[5]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[0] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[0]),
        .Q(\codigo_op_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[1] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[1]),
        .Q(\codigo_op_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[2] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[2]),
        .Q(\codigo_op_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[3] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[3]),
        .Q(\codigo_op_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[4] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[4]),
        .Q(\codigo_op_reg_n_0_[4] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \codigo_op_reg[5] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\codigo_op[5]_i_1_n_0 ),
        .D(i_data_IBUF[5]),
        .Q(\codigo_op_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[0] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[0]),
        .Q(dato_A[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[1] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[1]),
        .Q(dato_A[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[2] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[2]),
        .Q(dato_A[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[3] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[3]),
        .Q(dato_A[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[4] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[4]),
        .Q(dato_A[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[5] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[5]),
        .Q(dato_A[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[6] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[6]),
        .Q(dato_A[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_A_reg[7] 
       (.C(i_clk_IBUF_BUFG),
        .CE(i_btn_A_IBUF),
        .D(i_data_IBUF[7]),
        .Q(dato_A[7]),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h2)) 
    \dato_B[7]_i_1 
       (.I0(i_btn_B_IBUF),
        .I1(i_btn_A_IBUF),
        .O(\dato_B[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[0] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[0]),
        .Q(\dato_B_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[1] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[1]),
        .Q(\dato_B_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[2] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[2]),
        .Q(\dato_B_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[3] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[3]),
        .Q(\dato_B_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[4] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[4]),
        .Q(\dato_B_reg_n_0_[4] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[5] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[5]),
        .Q(\dato_B_reg_n_0_[5] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[6] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[6]),
        .Q(\dato_B_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \dato_B_reg[7] 
       (.C(i_clk_IBUF_BUFG),
        .CE(\dato_B[7]_i_1_n_0 ),
        .D(i_data_IBUF[7]),
        .Q(\dato_B_reg_n_0_[7] ),
        .R(1'b0));
  IBUF i_btn_A_IBUF_inst
       (.I(i_btn_A),
        .O(i_btn_A_IBUF));
  IBUF i_btn_B_IBUF_inst
       (.I(i_btn_B),
        .O(i_btn_B_IBUF));
  IBUF i_btn_c_IBUF_inst
       (.I(i_btn_c),
        .O(i_btn_c_IBUF));
  BUFG i_clk_IBUF_BUFG_inst
       (.I(i_clk_IBUF),
        .O(i_clk_IBUF_BUFG));
  IBUF i_clk_IBUF_inst
       (.I(i_clk),
        .O(i_clk_IBUF));
  IBUF \i_data_IBUF[0]_inst 
       (.I(i_data[0]),
        .O(i_data_IBUF[0]));
  IBUF \i_data_IBUF[1]_inst 
       (.I(i_data[1]),
        .O(i_data_IBUF[1]));
  IBUF \i_data_IBUF[2]_inst 
       (.I(i_data[2]),
        .O(i_data_IBUF[2]));
  IBUF \i_data_IBUF[3]_inst 
       (.I(i_data[3]),
        .O(i_data_IBUF[3]));
  IBUF \i_data_IBUF[4]_inst 
       (.I(i_data[4]),
        .O(i_data_IBUF[4]));
  IBUF \i_data_IBUF[5]_inst 
       (.I(i_data[5]),
        .O(i_data_IBUF[5]));
  IBUF \i_data_IBUF[6]_inst 
       (.I(i_data[6]),
        .O(i_data_IBUF[6]));
  IBUF \i_data_IBUF[7]_inst 
       (.I(i_data[7]),
        .O(i_data_IBUF[7]));
  OBUF \o_resultado_OBUF[0]_inst 
       (.I(o_resultado_OBUF[0]),
        .O(o_resultado[0]));
  OBUF \o_resultado_OBUF[1]_inst 
       (.I(o_resultado_OBUF[1]),
        .O(o_resultado[1]));
  OBUF \o_resultado_OBUF[2]_inst 
       (.I(o_resultado_OBUF[2]),
        .O(o_resultado[2]));
  OBUF \o_resultado_OBUF[3]_inst 
       (.I(o_resultado_OBUF[3]),
        .O(o_resultado[3]));
  OBUF \o_resultado_OBUF[4]_inst 
       (.I(o_resultado_OBUF[4]),
        .O(o_resultado[4]));
  OBUF \o_resultado_OBUF[5]_inst 
       (.I(o_resultado_OBUF[5]),
        .O(o_resultado[5]));
  OBUF \o_resultado_OBUF[6]_inst 
       (.I(o_resultado_OBUF[6]),
        .O(o_resultado[6]));
  OBUF \o_resultado_OBUF[7]_inst 
       (.I(o_resultado_OBUF[7]),
        .O(o_resultado[7]));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[0] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[0]),
        .Q(o_resultado_OBUF[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[1] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[1]),
        .Q(o_resultado_OBUF[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[2] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[2]),
        .Q(o_resultado_OBUF[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[3] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[3]),
        .Q(o_resultado_OBUF[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[4] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[4]),
        .Q(o_resultado_OBUF[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[5] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[5]),
        .Q(o_resultado_OBUF[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[6] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[6]),
        .Q(o_resultado_OBUF[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \o_resultado_reg[7] 
       (.C(i_clk_IBUF_BUFG),
        .CE(todos_cargados),
        .D(resultado[7]),
        .Q(o_resultado_OBUF[7]),
        .R(1'b0));
  alu_core u_alu_core
       (.D(resultado),
        .Q({\dato_B_reg_n_0_[7] ,\dato_B_reg_n_0_[6] ,\dato_B_reg_n_0_[5] ,\dato_B_reg_n_0_[4] ,\dato_B_reg_n_0_[3] ,\dato_B_reg_n_0_[2] ,\dato_B_reg_n_0_[1] ,\dato_B_reg_n_0_[0] }),
        .\o_resultado_reg[2] ({\codigo_op_reg_n_0_[5] ,\codigo_op_reg_n_0_[4] ,\codigo_op_reg_n_0_[3] ,\codigo_op_reg_n_0_[2] ,\codigo_op_reg_n_0_[1] ,\codigo_op_reg_n_0_[0] }),
        .\o_resultado_reg[7] (dato_A));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
