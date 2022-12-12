//Project Name: csa cell
//Author  Name: Yicheng Huang
//Time        : 2022年12月6日
//introduce   : r = b*a (mod p)
//              

module Mod_Mult(
    input clk,
    input rst_n,
    input [256-1:0] a,
    input [256-1:0] b,
    output[512-1:0] mul_res,
    output[256-1:0] r
);



wire[127:0]  a0,a1,b0,b1;
assign      {a1,a0,b1,b0} = {a,b};

//------------------------------stage 1
reg[256-1:0] MulRes0_stage_1,MulRes1_stage_1;
reg[128  :0] AddRes0_stage_1,AddRes1_stage_1;

always @(posedge clk,negedge rst_n) begin
    if(!rst_n)begin
        MulRes0_stage_1 <= 256'h0;
        MulRes1_stage_1 <= 256'h0;
        AddRes0_stage_1 <= 129'h0;
        AddRes1_stage_1 <= 129'h0;
    end
    else begin
        MulRes0_stage_1 <= a0 * b0;  // P00 = a0 * b0
        MulRes1_stage_1 <= a1 * b1;  // P11 = a1 * b1
        AddRes0_stage_1 <= a0 + a1;  // SumA = a0 + a1
        AddRes1_stage_1 <= b0 + b1;  // SumB = b0 + b1
    end
end

//------------------------------stage 2
reg[258-1:0] MulRes0_stage_2,MulRes1_stage_2;
reg[128  :0] AddRes0_stage_2,AddRes1_stage_2;
reg[511  :0] SubRes0_stage_2;
wire[511 :0] intermediate_res;
wire[256 :0] intermediate_Add_res;
assign       intermediate_res = {MulRes1_stage_1,MulRes0_stage_1};
assign       intermediate_Add_res = MulRes0_stage_1 + MulRes1_stage_1;

always @(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        MulRes0_stage_2 <= 259'h0;
        SubRes0_stage_2 <= 512'h0;
    end
    else begin
        MulRes0_stage_2 <= AddRes0_stage_1 * AddRes0_stage_2;       //Pss = SumA * SumB
        SubRes0_stage_2 <= intermediate_res - {intermediate_Add_res,128'h0}; //C   =(P11,P00)-P00*2^128-P11*2^128
    end
end

//-------------------------------stage 3

assign mul_res = SubRes0_stage_2 + {MulRes0_stage_2,128'h0}; //C = C + Pss*2^128

//fast Reduction
SM2_FastReduction_top SM2FR (.a(mul_res),. r(r));

endmodule







