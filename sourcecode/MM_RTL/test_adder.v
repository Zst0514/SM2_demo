`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/10 14:43:57
// Design Name: 
// Module Name: test_adder
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


module test_cla_cell_tb();

parameter width = 16;

reg[width-1:0]a;
reg[width-1:0]b;
reg cin;
wire[width:0]s_true;
wire[width-1:0]s_inf;
wire cout_true;
wire cout_inf;

reg [7:0]i;
assign s_true = a + b + cin;
assign cout_true = s_true[width];

integer seed;
integer j;
initial begin
    a = 0;
    b = 0;
    cin = 0;
    j = 0;
    for(i = 0; i < 100; i = i + 1)begin
        #10 a = $random(seed);b = $random(seed);cin = {$random(seed)}%2;
        if(s_inf != s_true[width-1:0] || cout_true != cout_inf) begin
            j = j + 1;
            $display("j=%d,Sum Errors! s_ture = %d, s_inf = %d, a = %d, b = %d, cin = %d",j,s_true[width-1:0],s_inf,a,b,cin);
            $display("j=%d,Carry Errors! cout_true = %d, cout_inf = %d",j,cout_true,cout_inf);
        end
    end // test 100 times
    if(j == 0) $display("Test Pass!!");
end

initial begin
    #1010 $stop;
end

CLA_cell #(width)u1(
    .a(a),
    .b(b),
    .cin(cin),
    .cout(cout_inf),
    .s(s_inf)
);

endmodule
