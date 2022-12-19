//Project Name: mod_inv
//Author  Name: Yicheng Huang
//Time        : 2022.12.15
//introduce   : inv_res = in ^ (-1) (mod p)
//Algorithm   : extend Eculid Algorithm(拓展欧几里得算法)


module mod_inv(
    input clk,
    input rst_n,
    input start_signal,
    input [256-1:0] p,
    input [256-1:0] in,
    output[256-1:0] inv_res,
    output          finish
); 

parameter    state_idle = 4'b0001;
parameter    state_done = 4'b1000;
parameter    state_busy_pre = 4'b0010;
parameter    state_busy_cal = 4'b0100;

reg[255:0]   p_r      ;   //保存一次运算的模p，实际上p应该不会变
reg[3:0]     now_state;
reg[3:0]     next_state;
wire         pre_done;    //预计算结束标志 u v 均为奇数
wire         cal_done;    //大循环结束标志 u v 不同时等于1


reg[256-1:0] u,v;
reg[256-1:0] x1,x2;
wire[256:0 ] signed_u,signed_v;
wire[256:0 ] signed_u_sub_v;
wire[256:0 ] signed_v_sub_u;
wire[255:0 ] x1_mod_sub_x2 ;
wire[255:0 ] x2_mod_sub_x1 ;
wire[256:0 ] x1_add_p_r ;
wire[256:0 ] x2_add_p_r ;
wire[256:0 ] x1_add_p_r_div2 ;
wire[256:0 ] x2_add_p_r_div2 ;
wire[256:0 ] x1_add_p_r_shift ;
wire[256:0 ] x2_add_p_r_shift ;

assign x1_add_p_r = x1 + p_r;
assign x2_add_p_r = x2 + p_r;
assign x1_add_p_r_div2 = x1_add_p_r[256:1];
assign x2_add_p_r_div2 = x2_add_p_r[256:1];
assign x1_add_p_r_shift = x1_add_p_r >> 1;
assign x2_add_p_r_shift = x2_add_p_r >> 1;
assign signed_u = {1'b0,u};
assign signed_v = {1'b0,v};
assign signed_u_sub_v = signed_u - signed_v ;
assign signed_v_sub_u = signed_v - signed_u ;


mod_sub x1_sub_x2(.a(x1),.b(x2),.p(p),.mod_sub_res(x1_mod_sub_x2));
mod_sub x2_sub_x1(.a(x2),.b(x1),.p(p),.mod_sub_res(x2_mod_sub_x1));

assign pre_done = (u[0] == 1'b1) & (v[0] == 1'b1) ; // uv均为奇数时    进入下一阶段
assign cal_done = (u == 256'b1)  | (v == 256'b1)  ; // uv有一个等于1时 表示计算完成  椭圆曲线密码学导论的建议
assign inv_res  = (now_state == state_done) ?((u == 256'b1) ? x1 : x2):256'h0;
assign finish   = (now_state == state_done) ;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        now_state <= state_idle;
    end
    else begin
        now_state <= next_state;
    end
end

always@(*)begin
    case(now_state)
    state_idle:begin
        if(start_signal == 1'b1)begin
            next_state = state_busy_pre;
        end
        else begin
            next_state = state_idle;
        end
    end
    state_busy_pre:begin
        if(pre_done == 1'b1)begin
            next_state = state_busy_cal;
        end
        else begin
            next_state = state_busy_pre;
        end
    end
    state_busy_cal:begin
        if(cal_done == 1'b1)begin
            next_state = state_done;
        end
        else begin
            next_state = state_busy_pre;
        end    
    end
    state_done:begin
        next_state = state_idle;
    end
    default: begin
        next_state = state_idle;
    end
    endcase
end

always@(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        u <= 256'h0;
        v <= 256'h0;
        x1<= 256'h0;
        x2<= 256'h0;
        p_r<=256'h0;
    end
    else begin
        case(now_state)
        state_idle:begin
            if(start_signal == 1'b1)begin
                u <= in;
                v <= p ;
                x1<= 256'h1;
                x2<= 256'h0;
                p_r<=p;
            end
            else begin
                u <= 256'h0;
                v <= 256'h0;
                x1<= 256'h0;
                x2<= 256'h0;
                p_r<=256'h0;
            end
        end
        state_busy_pre:begin
            if(u[0] == 1'b0)begin  //如果u为偶数 u=u/2,否则 u 不变
               u <= u >> 1;
               if(x1[0] == 1'b0) begin
                  x1 <= x1 >> 1 ;  //如果x1为偶数 x1=x1/2,否则 x1=(x1+p)/2 不变
               end
               else begin
                  //x1 <= (x1 + p_r) >> 1 ; //(x2+p_r) will cause overflow
                  x1 <= x1_add_p_r_div2;    //or using :x1 <= x1_add_p_r_shift;
               end
            end
            else begin
               u <= u ;
            end
            //u <= (u[0]==1'b0) ? {u[255],u[255:1]}:u;

            if(v[0] == 1'b0)begin  //如果v为偶数 v=v/2,否则 v 不变
               v <= v >> 1 ;
               if(x2[0] == 1'b0) begin
                  x2 <= x2 >> 1 ;  //如果x2为偶数 x2=x2/2,否则 x2=(x2+p)/2 不变
               end
               else begin
                  //x2 <= (x2 + p_r) >> 1 ; //(x2+p_r) will cause overflow
                  x2 <= x2_add_p_r_div2 ;   //or using :x2 <= x2_add_p_r_shift ;
               end
            end
            else begin
               v <= v ;
            end
        end
        state_busy_cal:begin
            // 此处应该着重考虑下  ，因为 u-v 是大数加法，，然后 x1-x2 考虑做成 模加减
            if(signed_u_sub_v[256] == 1'b0)begin
                u  <= signed_u_sub_v[255:0];
                x1 <= x1_mod_sub_x2 ;
                v <= v;
                x2<= x2;
            end
            else begin
                v  <= signed_v_sub_u[255:0];
                x2 <= x2_mod_sub_x1 ;
                u <= u;
                x1<= x1;
            end
        end
        default: begin
            u <= u;
            v <= v;
            x1<= x1;
            x2<= x2;
            p_r<=p_r;
        end
        endcase
    end

end

endmodule
