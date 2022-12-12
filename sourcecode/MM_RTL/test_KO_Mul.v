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


module test_KO_Mul(
        input clk,
        input rst_n,
        input[`width-1:0] Mult_a,
        input[`width-1:0] Mult_b,
        output[`width*2-1:0] Mult_result
    );
    
reg[`width-1:0]  a;
reg[`width-1:0]  b;

//mult_gen_0 mult_128 (
//  .CLK(CLK),  // input wire CLK
//  .A(a),      // input wire [63 : 0] A
//  .B(b),      // input wire [63 : 0] B
//  .P(Mult_ip_result)      // output wire [127 : 0] P
//);

KO_V2   U_KO(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .mul_res(Mult_result)
);

always@(posedge clk)begin
    a <= Mult_a;
    b <= Mult_b;
end


endmodule


