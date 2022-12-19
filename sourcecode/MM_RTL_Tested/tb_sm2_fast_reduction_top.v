`timescale 1ns/1ns


module tb_sm2_fast_reduction_top();

parameter sm2_p  = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;

reg[511:0 ]  in,mul_res;
wire[255:0]  out;
reg[255:0 ]  in_a,in_b,mod_p,std_res;
integer i,k ;
reg[15:0]  round = 16'd100;

SM2_FastReduction_top  sm2_fr(.a(in),.r(out));

initial begin
    $display("-***************************************************-");
    #100
    $display("------------ SM2 Fast Reduction Test Start------------------");
    mod_p = sm2_p;
    k     = 0    ;
    in_a  = 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
    in_b  = 256'hb1bf7ec4080f3c8735f1294ac0db19686bee2e96ab8c71fb7a253666cb66e009;
    std_res = 256'h35fe79196aab8d8af83f199bfe3b0b694a02b1cc5704893293838bd3258a7593;
    in    = in_a * in_b ;
    #5
    $display("SM2 Fast Reduction out = 0x%x ",out);
    $display("Std Res out = 0x%x ",std_res);
    if(out == std_res)begin
        $display("SM2 Fast Reduction Test Pass! SX1510 dataset ");
    end
    else begin
        $display("SM2 Fast Reduction Test Fail! SX1510 dataset ");
        k = k + 1;
    end
    #5
    $display("------------ SM2 Fast Reduction Test Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        in_a=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_b=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in = in_a * in_b ;
        mul_res = in ;
        std_res = MODULE_F(sm2_p,mul_res);
        #5
        if(out == std_res)begin
          //$display("Round:%d SM2 Fast Reduction Test Pass!",i);
            $display("Round:%d SM2 Fast Reduction Test Pass! MUL_RES = 0x%x",i,mul_res);
            $display("                                     > OUT = 0x%x,STD = 0x%x",out,std_res);
        end
        else begin
            //$display("Round:%d SM2 Fast Reduction Test Fail! MUL_RES = 0x%x,OUT = 0x%x,STD = 0x%x",i,mul_res,out,std_res);
            $display("Round:%d SM2 Fast Reduction Test Fail! MUL_RES = 0x%x",i,mul_res);
            $display("                                     > OUT = 0x%x,STD = 0x%x",out,std_res);
            //$display("Round:%d SM2 Fast Reduction Test Fail! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
            //$display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
            k = k + 1;
        end
    end
    $display("------------ SM2 Fast Reduction Test End------------------");
    $display("------------ -PASS %d Case,Fail %d Case-------------------",round+1-k,k);
end


function [255:0]MODULE_F; 
//定义输入变量 
input[255:0] P; 
input[511:0] IN;
//定义函数体 
begin 
    MODULE_F = IN % P;
end 
endfunction

function [255:0] Rand_256_mod_p;
input[255:0] P;
reg[255:0]   temp;
begin
    temp = {$random} + ({$random}<<32)+({$random}<<64)+({$random}<<96)+({$random}<<128)+({$random}<<160)+({$random}<<192)+({$random}<<224);
    if(temp >= P)begin
        Rand_256_mod_p = temp - P;
    end
    else begin
        Rand_256_mod_p = temp;
    end
end
endfunction

endmodule

