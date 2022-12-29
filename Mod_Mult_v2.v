`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/28 20:37:03
// Design Name: 
// Module Name: Mod_Mult_v2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define cal_width 256
`define io_width 32
module Mod_Mult_v2(
    input clk,
    input rst_n,
    input in_valid,
    output in_ready,
    input [`io_width -1:0]num1,
    input [`io_width -1:0]num2,
    output out_valid,
    input out_ready,
    output [`io_width -1:0]res
    );
    
    reg [`cal_width-1:0]a;
    reg [`cal_width-1:0]b;
    wire [`cal_width*2-1:0]res_512; 
    
    reg in_ready;
    // -------- input串并转换 -------- 8 cycle (+ 1cycle)
    reg [$clog2(`cal_width/`io_width):0]cnt1;
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            a <= 0;
            b <= 0;
            cnt1 <= 0;
            in_ready <= 1;
        end
        else begin
            if(in_valid && cnt1 < `cal_width/`io_width)begin
                cnt1 <= cnt1 + 1'd1;
                a <= {a[`cal_width - `io_width - 1 : 0],num1}; // 先输入高位
                b <= {b[`cal_width - `io_width - 1 : 0],num1};
                in_ready <= 0;
            end
            else if(cnt1 == `cal_width/`io_width)begin
                cnt1 <= cnt1 + 1'd1;
                a <= a;
                b <= b;
                in_ready <= 0;
            end
            else begin
                cnt1 <= cnt1 + 1'd1;
                a <= 0;
                b <= 0;
                in_ready <= 1;
            end
        end
    end
    
    // -------- 乘法模块 -------- 2 cycle
    KO_V2 u_Multer(
        clk,
        rst_n,
        a,
        b,
        res_512
    );

    // -------- 快速约简 --------  combination
    wire [`cal_width -1:0]res_256;
    SM2_FastReduction_top u_FR(
        clk,
        rst_n,
        res_512,
        res_256
    );

    // -------- 采样延时一周期约简结果 -------- 1 cycle
    reg [`cal_width -1:0]res_256_t;
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            res_256_t <= 0;
        end
        else
            res_256_t <= res_256;
    end
    // -------- output并串转换 -------- 8 cycle
    reg out_valid;
    reg [`io_width -1:0]res_t;
    reg [$clog2(`cal_width/`io_width):0]cnt2;
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            res_t <= 0;
            cnt2 <= 0;
            out_valid <= 0;
        end
        else begin
            if(out_ready && cnt2 < `cal_width/`io_width)begin
                cnt2 <= cnt2 + 1'd1;
                res_t <= res_256_t[`cal_width - cnt2 * `io_width - 1 -: `io_width]; // 先输出高位
                out_valid <= 1'b1;
            end
            else begin
                cnt2 <= 0;
                res_t <= 0;
                out_valid <= 0;
            end
        end
    end

    // -------- 结果输出 --------
    assign res = res_t;

endmodule








