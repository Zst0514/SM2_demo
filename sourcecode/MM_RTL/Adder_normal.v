
module Adder_normal(
    a,
    b,
    cin,
    s,
    cout
);
parameter width = 16;

input [width-1:0]a;
input [width-1:0]b;
input cin;

output [width-1:0]s;
output cout;

wire [width : 0]s_t;

assign s_t = a + b;
assign s = s_t[width-1 : 0];
assign cout = s[width];

endmodule