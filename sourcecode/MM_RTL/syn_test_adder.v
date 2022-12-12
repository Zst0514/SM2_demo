`define width 4
`define mode 1
module syn_test_adder(
    input clk,
    input [`width-1:0]a,
    input [`width-1:0]b,
    input cin,
    output [`width-1:0]s,
    output cout
);


reg [`width-1:0]a_t;
reg [`width-1:0]b_t;
reg cin_t;

wire [`width-1:0]s_t;
wire cout_t;
reg [`width-1:0]s_r;
reg cout_r;

always @(posedge clk) begin
    a_t <= a;
    b_t <= b;
    cin_t <= cin;
end

always @(posedge clk)begin
    s_r <= s_t;
    cout_r <= cout_t;
end

assign s = s_r;
assign cout = cout_r;
generate
    if(`mode)
        CLA_cell #(`width)u1(
            .a(a_t),
            .b(b_t),
            .cin(cin_t),
            .cout(cout_t),
            .s(s_t)
        );
    else
        Adder_normal #(`width)u2(
            .a(a_t),
            .b(b_t),
            .cin(cin_t),
            .cout(cout_t),
            .s(s_t)
        );
endgenerate


endmodule