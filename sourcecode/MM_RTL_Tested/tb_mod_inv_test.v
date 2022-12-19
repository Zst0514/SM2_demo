//Project Name: tb_mod_inv_top
//Author  Name: Yicheng Huang
//Time        : 2022.12.15
//introduce   : inv_res = in ^ (-1) (mod p)
//Algorithm   : extend Eculid Algorithm(拓展欧几里得算法)
//              to simulation the circuit(could be syntheised)


module tb_mod_inv_top(
);


reg[255:0] p = 256'hfffffffeffffffffffffffffffffffffffffffff00000000ffffffffffffffff;
reg[255:0] in= 256'hc239507105c683242a81052ff641ed69009a084ad5cc937db21646cd34a0ced5;
reg[255:0] u,v;
reg [256:0] x1,x2;
integer i ;
integer k ;
initial begin
    i = 0;
    $display(" a = %x,p =%x",in,p);
    u = in;
    v = p;
    x1 = 512'h1;
    x2 = 512'h0;
    while( u != 256'h0)begin
        k = 0;
        while( u[0] == 1'b0)begin
            u = u >> 1;
            if(x1[0] == 1'b0)begin
            x1 = x1 >>1 ;
            end
            else begin
                x1 = (x1+p) >>1 ;
            end
            if(i < 5) begin
            $display("   >>>>case %d :After div 2 -> u = %x,x1 =%x",k,u,x1);
            $display("   >>>>case %d :After div 2 -> v = %x,x2 =%x",k,v,x2);
            k = k + 1;
            end
        end
        k = 0;

        while( v[0] == 1'b0)begin
            v = v >> 1;
            if(x2[0] == 1'b0)begin
            x2 = x2 >>1 ;
            end
            else begin
                x2 = (x2+p) >>1 ;
            end
        end
        if(i < 5) begin
        $display("---------Round %d-------------",i);
        $display(" u = %x,x1 =%x",u,x1);
        $display(" v = %x,x2 =%x",v,x2);
        end
        i = i + 1;
        if(u >= v)begin
            u = u -v;
            if(x1 >= x2)begin
                x1 = x1-x2;
            end
            else begin
                x1 = x1-x2+p;
            end
        end
        else begin
            v = v-u;
            if(x2 >= x1)begin
                x2 = x2-x1;
            end
            else begin
                x2 = x2-x1+p;
            end
        end
        if(i < 5) begin
        $display("   After Sub -> u = %x,x1 =%x",u,x1);
        $display("   After Sub -> v = %x,x2 =%x",v,x2);
        end
    end
        $display(" u = %5d,x1 =%x",u,x1%p);
        $display(" v = %5d,x2 =%x",v,x2%p);
end









endmodule