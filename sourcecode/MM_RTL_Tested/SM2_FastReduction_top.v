//Project Name: csa cell
//Author  Name: Yicheng Huang
//Time        : 2022年12月6日
//introduce   : r*a = 1 (mod p)
//              p is p256 =fffffffe ffffffff ffffffff ffffffff ffffffff 00000000 ffffffff ffffffff

module SM2_FastReduction_top
(
    input  [512-1:0] a,
//    input  [256-1:0] p,
    output [256-1:0] r
);
localparam SM2_p = 256'hfffffffe_ffffffff_ffffffff_ffffffff_ffffffff_00000000_ffffffff_ffffffff;
localparam SM2_p_Minus= {1'b1,256'h00000001_00000000_00000000_00000000_00000000_ffffffff_00000000_00000001};

wire[32-1:0] c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15;
wire[256-1:0] s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14;

assign {c15,c14,c13,c12,c11,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0} = a;
assign s1 = {c7,c6,c5,c4,c3,c2,c1,c0};
assign s2 = {c15,c14,c13,c12,c11,32'h0,c9,c8};
assign s3 = {c14,32'h0,c15,c14,c13,32'h0,c14,c13};
assign s4 = {c13,32'h0,32'h0,32'h0,32'h0,32'h0,c15,c14};
assign s5 = {c12,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0,c15};
assign s6 = {c11,c11,c10,c15,c14,32'h0,c13,c12};
assign s7 = {c10,c15,c14,c13,c12,32'h0,c11,c10};
assign s8 = {c9,32'h0,32'h0,c9,c8,32'h0,c10,c9};
assign s9 = {c8,32'h0,32'h0,32'h0,c15,32'h0,c12,c11};
assign s10= {c15,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0};
assign s11= {32'h0,32'h0,32'h0,32'h0,32'h0,c14,32'h0,32'h0};
assign s12= {32'h0,32'h0,32'h0,32'h0,32'h0,c13,32'h0,32'h0};
assign s13= {32'h0,32'h0,32'h0,32'h0,32'h0,c9 ,32'h0,32'h0};
assign s14= {32'h0,32'h0,32'h0,32'h0,32'h0,c8 ,32'h0,32'h0};

//------------------------------------ Level 1
//完成加法操作 s1 + s2 + 2s3 + 2s4 + 2s5 + s6 + s7 + s8 + s9 + 2s10 
wire[256-1:0] level_1_sum,level_2_sum,level_3_sum,level_4_sum,level_5_sum,level_6_sum,level_7_sum,
              level_8_sum,level_9_sum,level_10_sum,level_11_sum,level_12_sum;

wire[256  :0] level_1_cout,level_2_cout,level_3_cout,level_4_cout,level_5_cout,level_6_cout,level_7_cout,
              level_8_cout,level_9_cout,level_10_cout,level_11_cout,level_12_cout;

wire[4:0]     ov_1_cout,ov_2_cout,ov_3_cout,ov_4_cout,ov_5_cout,ov_6_cout,ov_7_cout,ov_8_cout,ov_9_cout,ov_10_cout;
wire[3:0]     ov_1_sum,ov_2_sum,ov_3_sum,ov_4_sum,ov_5_sum,ov_6_sum,ov_7_sum,ov_8_sum,ov_9_sum,ov_10_sum;
wire[3:0]     level_1_overflow_result;

csa_cell #(.width(256)) level_1  (.a(s1),.b(s2),.cin(s3),.cout(level_1_cout),.s(level_1_sum)); //L1 = s1 + s2 + s3
csa_cell #(.width(256)) level_2  (.a(level_1_cout[255:0]),.b(level_1_sum),.cin(s3),.cout(level_2_cout),.s(level_2_sum));      //L2  = L1 + s3
csa_cell #(.width(256)) level_3  (.a(level_2_cout[255:0]),.b(level_2_sum),.cin(s4),.cout(level_3_cout),.s(level_3_sum));      //L3  = L2 + s4
csa_cell #(.width(256)) level_4  (.a(level_3_cout[255:0]),.b(level_3_sum),.cin(s4),.cout(level_4_cout),.s(level_4_sum));      //L4  = L3 + s4
csa_cell #(.width(256)) level_5  (.a(level_4_cout[255:0]),.b(level_4_sum),.cin(s5),.cout(level_5_cout),.s(level_5_sum));      //L5  = L4 + s5
csa_cell #(.width(256)) level_6  (.a(level_5_cout[255:0]),.b(level_5_sum),.cin(s5),.cout(level_6_cout),.s(level_6_sum));      //L6  = L4 + s5
csa_cell #(.width(256)) level_7  (.a(level_6_cout[255:0]),.b(level_6_sum),.cin(s6),.cout(level_7_cout),.s(level_7_sum));      //L7  = L6 + s6
csa_cell #(.width(256)) level_8  (.a(level_7_cout[255:0]),.b(level_7_sum),.cin(s7),.cout(level_8_cout),.s(level_8_sum));      //L8  = L7 + s7
csa_cell #(.width(256)) level_9  (.a(level_8_cout[255:0]),.b(level_8_sum),.cin(s8),.cout(level_9_cout),.s(level_9_sum));      //L9  = L8 + s8
csa_cell #(.width(256)) level_10 (.a(level_9_cout[255:0]),.b(level_9_sum),.cin(s9),.cout(level_10_cout),.s(level_10_sum));    //L10 = L9 + s9
csa_cell #(.width(256)) level_11 (.a(level_10_cout[255:0]),.b(level_10_sum),.cin(s10),.cout(level_11_cout),.s(level_11_sum)); //L11 = L10+ s10
csa_cell #(.width(256)) level_12 (.a(level_11_cout[255:0]),.b(level_11_sum),.cin(s10),.cout(level_12_cout),.s(level_12_sum)); //L12 = L11+ s10

//完成溢出累加
csa_cell #(.width(4)) overflow_1  (.a({3'b0,level_1_cout[256]}), .b({3'b0,level_2_cout[256]}),.cin({3'b0,level_3_cout[256]}),.cout(ov_1_cout),.s(ov_1_sum)); //OV1 = L1 + L2 + L3
csa_cell #(.width(4)) overflow_2  (.a({3'b0,level_4_cout[256]}), .b(ov_1_cout[3:0]),.cin(ov_1_sum),.cout(ov_2_cout),.s(ov_2_sum));   //OV2  = OV1 + L4
csa_cell #(.width(4)) overflow_3  (.a({3'b0,level_5_cout[256]}), .b(ov_2_cout[3:0]),.cin(ov_2_sum),.cout(ov_3_cout),.s(ov_3_sum));   //OV3  = OV2 + L5
csa_cell #(.width(4)) overflow_4  (.a({3'b0,level_6_cout[256]}), .b(ov_3_cout[3:0]),.cin(ov_3_sum),.cout(ov_4_cout),.s(ov_4_sum));   //OV4  = OV3 + L6
csa_cell #(.width(4)) overflow_5  (.a({3'b0,level_7_cout[256]}), .b(ov_4_cout[3:0]),.cin(ov_4_sum),.cout(ov_5_cout),.s(ov_5_sum));   //OV5  = OV4 + L7
csa_cell #(.width(4)) overflow_6  (.a({3'b0,level_8_cout[256]}), .b(ov_5_cout[3:0]),.cin(ov_5_sum),.cout(ov_6_cout),.s(ov_6_sum));   //OV6  = OV4 + L8
csa_cell #(.width(4)) overflow_7  (.a({3'b0,level_9_cout[256]}), .b(ov_6_cout[3:0]),.cin(ov_6_sum),.cout(ov_7_cout),.s(ov_7_sum));   //OV7  = OV6 + L9
csa_cell #(.width(4)) overflow_8  (.a({3'b0,level_10_cout[256]}),.b(ov_7_cout[3:0]),.cin(ov_7_sum),.cout(ov_8_cout),.s(ov_8_sum));   //OV8  = OV7 + L10
csa_cell #(.width(4)) overflow_9  (.a({3'b0,level_11_cout[256]}),.b(ov_8_cout[3:0]),.cin(ov_8_sum),.cout(ov_9_cout),.s(ov_9_sum));   //OV9  = OV8 + L11
csa_cell #(.width(4)) overflow_10 (.a({3'b0,level_12_cout[256]}),.b(ov_9_cout[3:0]),.cin(ov_9_sum),.cout(ov_10_cout),.s(ov_10_sum)); //OV10 = OV9 + L10

assign level_1_overflow_result = ov_10_cout + ov_10_sum ;
// csa_cell #(.width(1)) overflow_11 (.a(level_10_cout[256]),.b(level_10_sum),.cin(s10),.cout(level_11_cout),.s(level_11_sum)); //L11 = L10+ s10
// csa_cell #(.width(1)) overflow_12 (.a(level_11_cout[256]),.b(level_11_sum),.cin(s10),.cout(level_12_cout),.s(level_12_sum)); //L12 = L11+ s10
//------------------------------------ Level 2
//完成减法操作 -s11 - s12 - s13 - s14
// wire[256:0] level_2_result;
// csa_cell #(.width(257)) level_13  (.a({1'b0,level_12_cout[255:1],1'b1}),.b({1'b0,level_12_sum}),.cin({1'b1,~s11}),.cout(level_13_cout),.s(level_13_sum));//L13 = L12 - s11
// csa_cell #(.width(257)) level_14  (.a({level_13_cout[256:1],1'b1}),.b(level_13_sum),.cin({1'b1,~s12}),.cout(level_14_cout),.s(level_14_sum));//L14 = L13 - s12
// csa_cell #(.width(257)) level_15  (.a({level_14_cout[256:1],1'b1}),.b(level_14_sum),.cin({1'b1,~s13}),.cout(level_15_cout),.s(level_15_sum));//L15 = L14 - s13
// csa_cell #(.width(257)) level_16  (.a({level_15_cout[256:1],1'b1}),.b(level_15_sum),.cin({1'b1,~s14}),.cout(level_16_cout),.s(level_16_sum));//L16 = L15 - s14
// assign   level_2_result = level_16_cout + level_16_sum ;

//------------------------------------old
// 258 bit 位宽 避免cout+sum = 257bit,造成符号位溢出
wire[257:0]   level_2_result;
wire[257  :0] level_13_sum,level_14_sum,level_15_sum,level_16_sum,level_17_sum;
wire[258  :0] level_13_cout,level_14_cout,level_15_cout,level_16_cout;
wire          level_2_result_sign = level_2_result[257]    ;
wire          level_2_result_overflow = level_2_result[256];

// level_12_cout[256] 这个bit在 overflow中已经被考虑了 所以level_13中直接 {[255：1],1'b1}
csa_cell #(.width(258)) level_13  (.a({2'b0,level_12_cout[255:1],1'b1}),.b({2'b0,level_12_sum}),.cin({2'b1,~s11}),.cout(level_13_cout),.s(level_13_sum));//L13 = L12 - s11
csa_cell #(.width(258)) level_14  (.a({level_13_cout[257:1],1'b1}),.b(level_13_sum),.cin({2'b1,~s12}),.cout(level_14_cout),.s(level_14_sum));//L14 = L13 - s12
csa_cell #(.width(258)) level_15  (.a({level_14_cout[257:1],1'b1}),.b(level_14_sum),.cin({2'b1,~s13}),.cout(level_15_cout),.s(level_15_sum));//L15 = L14 - s13
csa_cell #(.width(258)) level_16  (.a({level_15_cout[257:1],1'b1}),.b(level_15_sum),.cin({2'b1,~s14}),.cout(level_16_cout),.s(level_16_sum));//L16 = L15 - s14
assign   level_2_result = level_16_cout[257:0] + level_16_sum ;
wire[259:0]   level_2_result_256 = level_16_cout + level_16_sum ;
// 考虑负溢出？？ cout 逮一下 -----------------------new
wire[257:0]   stage_13_result = level_13_cout[257:0] + level_13_sum;
wire[257:0]   stage_14_result = level_14_cout[257:0] + level_14_sum;
wire[257:0]   stage_15_result = level_15_cout[257:0] + level_15_sum;
wire[257:0]   stage_16_result = level_16_cout[257:0] + level_16_sum;

//------------------------------------ Level 3
//wire[31:0]  overflow_num = {28'd0,level_1_overflow_result};
wire        level_2_result_signWillfix = (level_2_result_sign == 1'b0) & (level_2_result_overflow == 1'b1) ; //正溢出
wire[31:0]  overflow_num = (level_2_result_signWillfix == 1'b1) ? {28'd0,(level_1_overflow_result+1'b1)} : {28'd0,level_1_overflow_result} ; // old
wire[255:0] overflow_add =  {overflow_num,32'h0,32'h0,32'h0,overflow_num,32'h0,32'h0,overflow_num+1'b1};   // +1 because -overflow_sub = ~overflow_sub + 1
wire[255:0] overflow_sub = ~{32'h0,32'h0,32'h0,32'h0,32'h0,overflow_num,32'h0,32'h0};
wire[256:0] level_pre_sum ;
wire[257:0] level_pre_cout;
wire[256:0] level_preAdd_sum,level_preSub_sum;
wire[257:0] level_preAdd_cout,level_preSub_cout;
wire[256:0] final_result,finalAdd_result,finalSub_result;
 
csa_cell #(.width(257)) level_pre    (.a({level_2_result_sign,level_2_result[255:0]}),.b({1'b1,overflow_sub}),.cin({1'b0,overflow_add}),.cout(level_pre_cout),.s(level_pre_sum)); //L1 = s1 + s2 + s3
csa_cell #(.width(257)) level_preAdd (.a(level_pre_cout[256:0]),.b(level_pre_sum),.cin({1'b0,SM2_p}),.cout(level_preAdd_cout),.s(level_preAdd_sum)); //L1 = s1 + s2 + s3
csa_cell #(.width(257)) level_preSub (.a(level_pre_cout[256:0]),.b(level_pre_sum),.cin(SM2_p_Minus),.cout(level_preSub_cout),.s(level_preSub_sum)); //L1 = s1 + s2 + s3
assign      final_result    = {level_pre_cout}    + level_pre_sum;
assign      finalAdd_result = {level_preAdd_cout[256:0] }+ level_preAdd_sum;
assign      finalSub_result = {level_preSub_cout[256:0] }+ level_preSub_sum; 

assign      r = ( finalAdd_result[256] == 1'b0 && final_result[256] == 1'b1)? finalAdd_result[255:0]  
              : ( finalSub_result[256] == 1'b0 && final_result[256] == 1'b0)? finalSub_result[255:0] 
              : final_result[255:0]
              ;

endmodule


