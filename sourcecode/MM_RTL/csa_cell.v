//Project Name: csa cell
//Author  Name: Yicheng Huang
//Time        : 2022年12月6日



module csa_cell 
#(parameter width = 256 )
(
    input  [width-1:0]a,
    input  [width-1:0]b,
    input  [width-1:0]cin,
    output [width  :0]cout,
    output [width-1:0]s
);

wire [width-1:0]cout_temp;
assign s = ( a ^ b ) ^ cin ;
assign cout_temp = ( a & b ) | ( cin & b ) | ( a & cin );
assign cout = {cout_temp,1'b0};

endmodule


