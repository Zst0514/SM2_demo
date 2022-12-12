`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/23 20:02:40
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define width 256

(* max_fanout=150 *)
module test(
        input clk,
        input rst_n,
        input[`width-1:0] Mult_a,
        input[`width-1:0] Mult_b,
        output[`width*2-1:0] Mult_result,
        output[`width*2-1:0] Mult_ip_result,
        output[`width  -1:0] Mod_result,
        output[`width*2-1:0] Add_result
    );
    
(* max_fanout = "150" *)reg[`width-1:0]  a;
(* max_fanout = "150" *)reg[`width-1:0]  b;
(* max_fanout = "150" *)reg[`width*2-1:0]  Mult_result_r;
(* max_fanout = "150" *)reg[`width*2-1:0]  Add_result_r;
(* max_fanout = "150" *)reg[`width  -1:0]  Mod_result_r;
(* max_fanout = "150" *)wire[`width  -1:0]  Mod_ip_result;
(* max_fanout = "150" *)reg[`width*2-1:0]  Mult_ip_result_r;

//mult_gen_0 mult_128 (
//  .CLK(CLK),  // input wire CLK
//  .A(a),      // input wire [63 : 0] A
//  .B(b),      // input wire [63 : 0] B
//  .P(Mult_ip_result)      // output wire [127 : 0] P
//);

//always@(posedge clk)begin
//    a <= Mult_a;
//    b <= Mult_b;
//    Mult_result_r <= a * b;
//    Add_result_r <= a + b;
//end

//assign  Mult_result =  Mult_result_r;
//assign  Add_result  = Add_result_r;



SM2_FastReduction_top  fr(.a({a,b}),.r(Mod_ip_result));

always@(posedge clk)begin
    a <= Mult_a;
    b <= Mult_b;
    Mod_result_r <= Mod_ip_result;
end
//assign  Mult_result =  Mult_result_r;
assign  Mod_result  = Mod_result_r;


endmodule


