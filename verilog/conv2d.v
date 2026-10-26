module conv2d_mem (
    input wire signed [15:0] p0, p1, p2,
    input wire signed [15:0] p3, p4, p5,
    input wire signed [15:0] p6, p7, p8,
    input wire [2:0] filter_id,
    output wire signed [15:0] out
);

    reg signed [15:0] w [0:71];
    reg signed [15:0] b [0:7];

    initial begin
        $readmemh("conv1_w.mem", w);
        $readmemh("conv1_b.mem", b);
    end

    wire signed [31:0] m0 = p0 * w[filter_id];
    wire signed [31:0] m1 = p1 * w[8  + filter_id];
    wire signed [31:0] m2 = p2 * w[16 + filter_id];
    wire signed [31:0] m3 = p3 * w[24 + filter_id];
    wire signed [31:0] m4 = p4 * w[32 + filter_id];
    wire signed [31:0] m5 = p5 * w[40 + filter_id];
    wire signed [31:0] m6 = p6 * w[48 + filter_id];
    wire signed [31:0] m7 = p7 * w[56 + filter_id];
    wire signed [31:0] m8 = p8 * w[64 + filter_id];

    wire signed [31:0] acc =
        m0 + m1 + m2 + m3 + m4 +
        m5 + m6 + m7 + m8;

    wire signed [31:0] acc_shift = acc >>> 8;
    wire signed [31:0] acc_bias = acc_shift + b[filter_id];

    assign out = acc_bias[15:0];

endmodule