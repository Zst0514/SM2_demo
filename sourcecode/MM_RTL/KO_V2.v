//Project Name: KO_Mult_V2
//Author  Name: Tianao Dai
//Time        : 2022.12.9
//introduce   : mul_res = a*b
//

module KO_V2(
    input clk,
    input rst_n,
    input [256-1:0] a,
    input [256-1:0] b,
    output[512-1:0] mul_res
);



wire[127:0]  a0,a1,b0,b1;
assign      {a1,a0,b1,b0} = {a,b};

//------------------------------stage 1
reg[255:0] t1,t2,t3,t4;
always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        t1 <= 0;
        t2 <= 0;
        t3 <= 0;
        t4 <= 0;
    end
    else begin
        t1 <= a0 * b0;
        t2 <= a1 * b1;
        t3 <= a1 * b0;
        t4 <= a0 * b1;
    end 
end


//-------------------------------stage2
wire[511:0]T1;
wire[256:0]T2;
reg[511:0]mul_res_t;
assign T1 = {t1,t2};
assign T2 = t3 + t4;
always @(posedge clk,negedge rst_n)begin
    if(!rst_n)
        mul_res_t <= 0;
    else begin
        mul_res_t[511:128] <= T1[511:128] + T2;
        mul_res_t[127:0] <= T1[127:0];
    end
end

assign mul_res = mul_res_t;
endmodule







