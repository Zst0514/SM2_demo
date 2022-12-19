`timescale 1ns/1ns


module tb_top();

parameter sm2_p  = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;
parameter NIST_p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;

reg[511:0 ]  in;
wire[255:0] out;
reg[255:0 ]  in_a,in_b,mod_p,std_res;
integer i ;
reg[15:0]  round = 16'd10;

mod_add  MA( .a(in_a), .b(in_b), .p(mod_p),.mod_add_res(out));

initial begin
    #10
    $display("------------ Mod Add Test(NIST) Start------------------");
    mod_p = NIST_p;
    in_a  = 256'he73a9b6613df3ce5593c4b02a910d0d973b2b28b16bec31698f89897b878c6cf;
    in_b  = 256'h16222f061fff868ca7eff679aef097c633adbf6182f3151f2c7d4e29274eb288;
    std_res = 256'hfd5cca6c33dec372012c417c5801689fa76071ec99b1d835c575e6c0dfc77957;
    #5
    $display("Mod Add out = 0x%x ",out);
    $display("Std Res out = 0x%x ",std_res);
    if(out == std_res)begin
        $display("Mod Add Test(NIST) SX1510 dataset Pass!");
    end
    else begin
        $display("Mod Add Test(NIST) Fail!");
    end
    #5
    $display("------------ Mod Add Test(NIST) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        // in_a={$random} % NIST_p; //通过位拼接操作{}产生0—NIST_p范围的随机数
        // in_b={$random} % NIST_p; //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_a=Rand_256_mod_p(NIST_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_b=Rand_256_mod_p(NIST_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        std_res = MODADD_F(in_a,in_b,NIST_p);
        #5
        if(out == std_res)begin
            $display("Round:%d Mod Add Test(NIST) Pass!",i);
           // $display("Round:%d Mod Add Test(NIST) Pass! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
        end
        else begin
            $display("Round:%d Mod Add Test(NIST) Fail! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
            $display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        //$display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
    end
    #5
    $display("------------ Mod Add Test(NIST) End------------------");
    $display("-***************************************************-");
    #100
    $display("------------ Mod Add Test ( SM2 ) Start------------------");
    mod_p = sm2_p;
    in_a  = 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
    in_b  = 256'hb1bf7ec4080f3c8735f1294ac0db19686bee2e96ab8c71fb7a253666cb66e009;
    std_res = 256'h73f8cf360dd5bfab60722e7ab71d06d16c8836e2815905782c3b7d340007aedf;
    #5
    $display("Mod Add out = 0x%x ",out);
    $display("Std Res out = 0x%x ",std_res);
    if(out == std_res)begin
        $display("Mod Add Test(SM2) Pass! SX1510 dataset ");
    end
    else begin
        $display("Mod Add Test(SM2) Fail! SX1510 dataset ");
    end
    #5
    $display("------------ Mod Add Test(SM2) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        in_a=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        in_b=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        std_res = MODADD_F(in_a,in_b,sm2_p);
        #5
        if(out == std_res)begin
            $display("Round:%d Mod Add Test(sm2_p) Pass!",i);
           // $display("Round:%d Mod Add Test(NIST) Pass! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
        end
        else begin
            $display("Round:%d Mod Add Test(sm2_p) Fail! in_a = 0x%x,in_b = 0x%x",i,in_a,in_b);
            $display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
        //$display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
    end
    $display("------------ Mod Add Test(SM2) End------------------");
end


function [255:0]MODADD_F; 
//定义输入变量 
input[255:0] A, B,P; 
//定义函数体 
reg[257:0]   C;
begin 
    C = A + B;
   if(C >= P)begin
    MODADD_F = C - {1'b0,P};
   end
   else begin
    MODADD_F = C[255:0] ;
   end
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

