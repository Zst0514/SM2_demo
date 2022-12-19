`timescale 1ns/1ns


module tb_mod_inv_top();

parameter sm2_p  = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;
parameter NIST_p = 256'hffffffff00000001000000000000000000000000ffffffffffffffffffffffff;

reg[511:0 ]  in;
reg          start_signal,clk,rst_n;
wire[255:0] out;
wire        finish;
reg[255:0 ]  in_a,in_b,mod_p,std_res,inv_test_res;
integer i ;
reg[15:0]  round = 16'd10;

mod_inv  MI(.clk(clk),.rst_n(rst_n),.start_signal(start_signal),.in(in_a), .p(mod_p),.inv_res(out),.finish(finish));

parameter clk_period = 10;
always #(clk_period/2) clk = ~clk;  

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    start_signal = 1'b0;
    inv_test_res = 256'h0;
    #10
    rst_n = 1'b0;
    #20
    rst_n = 1'b1;
    start_signal = 1'b1;
    mod_p = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;
    in_a  = 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
    $display(" Initial Finish test begin !");
    @(posedge clk)
    start_signal = 1'b0;
    wait(finish == 1'b1);
    #5
    $display(" Initial Finish test end !");
    $display("in = %x,mod_p =%x,out =%x !", in_a,mod_p,out);
    inv_test_res = MODINV_F(in_a,out,mod_p);
    if(inv_test_res == 256'b1)begin
        $display("Mod Inv Test(small number)  Pass!");
    end
    else begin
        $display("Mod Inv Test(small number) Fail!");
    end
    #200
    $display("------------ Mod Inv Test(NIST) Start------------------");
    mod_p = NIST_p;
    in_a  = 256'h69fe7d23f8dd5a7c958acb41a62f15692668b35d2d4ed54c0a8464e387439478;
    std_res=256'he05215cbc412474d522e1ef9d676888593b586030bce722aa456da5e204fd057;
    #5
    start_signal = 1'b0;
    @(posedge clk)
    start_signal = 1'b1;
    @(posedge clk)
    #5
    start_signal = 1'b0;
    wait(finish == 1'b1);
    #2
    $display("Mod Inv out = 0x%x ",out);
    $display("Std Inv out = 0x%x ",std_res);
    inv_test_res = MODINV_F(in_a,out,NIST_p);
    if(inv_test_res == 256'b1)begin
        $display("Mod Inv Test(NIST) SX1510 dataset Pass!");
    end
    else begin
        $display("Mod Inv Test(NIST) Fail! inv_test_res = 0x%0x",inv_test_res);
    end
    #5
    $display("------------ Mod Add Test(NIST) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        in_a=Rand_256_mod_p(NIST_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        #5
        start_signal = 1'b0;
        @(posedge clk)
        start_signal = 1'b1;
        @(posedge clk)
        #5
        start_signal = 1'b0;
        wait(finish == 1'b1);
        #2
        inv_test_res = MODINV_F(in_a,out,NIST_p);
        if(inv_test_res == 256'b1)begin
           //$display("Round:%d Mod Add Test(NIST) Pass!",i);
        $display("Round:%d Mod Inv Test(NIST) Pass! in_a = 0x%x,out = 0x%x",i,in_a,out);
        end
        else begin
            $display("Round:%d Mod Inv Test(NIST) Fail! in_a = 0x%x,out = 0x%x",i,in_a,out);
           // $display("Mod Add out = 0x%x ,Std Res out = 0x%x",out,std_res);
        end
    end
    #5
    $display("------------ Mod Add Test(NIST) End------------------");
    $display("-***************************************************-");
    #100
    $display("------------ Mod Add Test ( SM2 ) Start------------------");
    mod_p = sm2_p;
    start_signal = 1'b0;
    in_a  = 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
    @(posedge clk)
    start_signal = 1'b1;
    @(posedge clk)
    #5
    start_signal = 1'b0;
    wait(finish == 1'b1);
    #2
    $display("Mod Inv out = 0x%x ",out);
    inv_test_res = MODINV_F(in_a,out,sm2_p);
    if(inv_test_res == 256'b1)begin
        $display("Mod Inv Test(SM2) Pass! SX1510 dataset ");
    end
    else begin
        $display("Mod Inv Test(SM2) Fail! SX1510 dataset ");
    end
    #5
    $display("------------ Mod Inv Test(SM2) Rand------------------");
    for(i=1;i<= round ;i = i + 1)begin
        start_signal = 1'b0;
        in_a=Rand_256_mod_p(sm2_p); //通过位拼接操作{}产生0—NIST_p范围的随机数
        @(posedge clk)
        start_signal = 1'b1;
        @(posedge clk)
        #5
        start_signal = 1'b0;
        wait(finish == 1'b1);
        #5
        inv_test_res = MODINV_F(in_a,out,sm2_p);
        if(inv_test_res == 256'b1)begin
            //$display("Round:%d Mod Inv Test(sm2_p) Pass!",i);
            $display("Round:%d Mod Inv Test(NIST) Pass! in_a = 0x%x,out = 0x%x",i,in_a,out);
        end
        else begin
            $display("Round:%d Mod Inv Test(sm2_p) Fail! in_a = 0x%x,out = 0x%x",i,in_a,out);
        end
    end
    $display("------------ Mod Inv Test(SM2) End------------------");
    $display("------------ Mod Inv Test All test case done!------------------");
end


function [255:0]MODINV_F; 
//定义输入变量 
input[255:0] A, B,P; 
//定义函数体 
reg[511:0]   C;
begin 
    C = A * B;
    MODINV_F = C % P;
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

