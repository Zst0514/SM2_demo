//Project Name : mod_sub
//Author  Name : Yicheng Huang
//Time         : 2022.12.15
//introduce    : mod_add_res = a - b (mod p)
//Algorithm    : mod Add
//Note(Warning): this module can not slove the problem
//               that both a >= p and b >= p.
//               assume that both a<p ,b<p

module mod_sub(
       input [255:0] a,
       input [255:0] b,
       input [255:0] p,
       output[255:0] mod_sub_res
);

wire[256:0]  c;  
wire[256:0]  c_add_p;

assign c = a - b;
assign c_add_p = c + p;
assign mod_sub_res = ( (c[256]==1'b1) ) ? c_add_p : c ; // c < 0, out = c + p

endmodule