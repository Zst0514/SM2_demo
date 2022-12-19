//Project Name: csa cell
//Author  Name: Yicheng Huang
//Time        : 2022�?12�?6�?



module csa_cell 
#(parameter width = 256 )
(
    input  [width-1:0]a,
    input  [width-1:0]b,
    input  [width-1:0]cin,
    output [width  :0]cout,
    output [width-1:0]s
);

//*********************** use LUT to build CSA Adder
//wire [width-1:0]cout_temp;
//assign s = ( a ^ b ) ^ cin ;
//assign cout_temp = ( a & b ) | ( cin & b ) | ( a & cin );
//assign cout = {cout_temp,1'b0};

//*********************** use Full Adder to build CSA Adder
genvar	i;								//����genvar��������������
generate for(i=0;i<width;i=i+1)		//����ģ��
	begin : csa_gen						//begi_end������
		assign {cout[i+1],s[i]} = a[i] + b[i] + cin[i];
	end
endgenerate
assign cout[0] = 1'b0;



endmodule


