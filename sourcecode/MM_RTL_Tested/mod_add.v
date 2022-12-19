//Project Name : mod_add
//Author  Name : Yicheng Huang
//Time         : 2022.12.15
//introduce    : mod_add_res = a + b (mod p)
//Algorithm    : mod Add
//Note(Warning): this module can not slove the problem
//               that both a >= p and b >= p.

module mod_add(
       input [255:0] a,
       input [255:0] b,
       input [255:0] p,
       output[255:0] mod_add_res
);

wire[256:0]  c;  
wire[256:0]  c_sub_p;

assign c = a + b;
assign c_sub_p = c - p;
assign mod_add_res = ( (c_sub_p[256]==1'b0) ) ? c_sub_p[255:0] : c[255:0] ; // c-p >= 0, out = c- p

endmodule



