
module CLA_cell#(
    parameter width = 4   
)(
    a,
    b,
    cin,
    cout,
    s
);

input [width-1:0]a,b,cin;
output [width-1:0]s;
output cout;

wire [width:0]c;
wire [width-1:0]Pi;
wire [width-1:0]Gi;

assign Pi = a ^ b;
assign Gi = a & b;
assign c[0] = cin;

genvar i;
generate
    for(i=0;i<width;i=i+1)begin:carry_gen
        assign c[i+1] = Gi[i] || Pi[i]&&c[i];
    end
endgenerate

assign s = Pi ^ c[width-1:0];
assign cout = c[width];

endmodule