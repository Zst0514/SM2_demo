`timescale 1ns/1ns


module tb_mod_sub_top();

parameter sm2_p  = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;
parameter NIST_p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;

reg[511:0 ]  in;
wire[255:0] out;
reg[255:0 ]  in_a,in_b,mod_p,std_res;
integer i ;
reg[15:0]  round = 16'd20;

mod_sub  MSub( .a(in_a), .b(in_b), .p(mod_p),.mod_sub_res(out));

initial begin
    #10
    $display("------------ Mod Sub Test(NIST) Start------------------");
    mod_p = NIST_p;
    in_a  = 256'h73ba39a534ef8fcb0c982589952e0071c3c87cafdf0eb28e2b3a73ac6e941a16;
    in_b  = 256'ha756ec029d72eda1eecac889de78c41637af78456637461f0e8895d8bb5d5e9b;
    std_res = 256'hcc634da1977ca22a1dcd5cffb6b53c5b8c19046b78d76c6f1cb1ddd3b336bb7a;
    #5
    $display("Mod Sub out = 0x%x ",out);
    $display("Std Res out = 0x%x ",std_res);
    if(out == std_res)begin
        $display("Mod Sub Test(NIST) SX1510 dataset Pass!");
    end
    else begin
        $display("Mod Sub Test(NIST) Fail!");
    end
    #5
    $display("------------ Mod Sub Test(NIST) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        // in_a={$random} % NIST_p; //通过位拼接操作{}产生0—NIST_p范围的随机数
        // in_b={$random} % NIST_p; //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_a=Rand_256_mod_p(NIST_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_b=Rand_256_mod_p(NIST_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        std_res = MODSUB_F(in_a,in_b,NIST_p);
        #5
        if(out == std_res)begin
           //$display("Round:%d Mod Sub Test(NIST) Pass!",i);
           $display("Round:%d Mod Sub Test(NIST) Pass! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
           $display("                                  Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        else begin
            $display("Round:%d Mod Sub Test(NIST) Fail! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
            $display("Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        //$display("Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
    end
    #5
    $display("------------ Mod Sub Test(NIST) End------------------");
    $display("-***************************************************-");
    #100
    $display("------------ Mod Sub Test ( SM2 ) Start------------------");
    mod_p = sm2_p;
    in_a  = 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
    in_b  = 256'hb1bf7ec4080f3c8735f1294ac0db19686bee2e96ab8c71fb7a253666cb66e009;
    std_res = 256'h1079d1acfdb7469cf48fdbe53566d40094abd9b42a40218237f110666939eecc;
    #5
    $display("Mod Sub out = 0x%x ",out);
    $display("Std Res out = 0x%x ",std_res);
    if(out == std_res)begin
        $display("Mod Sub Test(SM2) Pass! SX1510 dataset ");
    end
    else begin
        $display("Mod Sub Test(SM2) Fail! SX1510 dataset ");
    end
    #5
    $display("------------ Mod Sub Test(SM2) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        in_a=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_b=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        std_res = MODSUB_F(in_a,in_b,sm2_p);
        #5
        if(out == std_res)begin
            //$display("Round:%d Mod Sub Test(sm2_p) Pass!",i);
            //$display("Round:%d Mod Sub Test(NIST) Pass! in_a = 0x%x,in_b = 0x%x,Mod Sub out = 0x%x,Std Res out = 0x%x",i,in_a,in_b,out,std_res);
              $display("Round:%d Mod Sub Test(NIST) Pass! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
              $display("                                  Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        else begin
            $display("Round:%d Mod Sub Test(sm2_p) Fail! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
            $display("Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        //$display("Mod Sub out = 0x%x ,Std Res out = 0x%x",out,std_res);
    end
    $display("------------ Mod Sub Test(SM2) End------------------");
end


function [255:0]MODSUB_F; 
//定义输入变量 
input[255:0] A, B,P; 
//定义函数体 
reg[260:0]   C;
reg signed[256:0]  signed_A,signed_B,signed_P;

begin 
//     signed_A = {1'b0,A};
//     signed_B = {1'b0,B};
//     signed_P = {1'b0,P};
//     C = signed_A - signed_B;
//    if(C[256] == 1'b1)begin
//     MODSUB_F = C + signed_P;
//    end
//    else begin
//     MODSUB_F = C[255:0] ;
//    end
      C = A - B + P;
      MODSUB_F = C % P;
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

