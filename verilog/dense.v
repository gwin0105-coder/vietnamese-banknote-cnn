module dense_mem (
    input wire [25087:0] flatten_input,
    output reg signed [15:0] out
);

    reg signed [15:0] w [0:1567];
    reg signed [15:0] b [0:0];

    integer i;

    reg signed [63:0] acc;
    reg signed [31:0] product;
    reg signed [63:0] result64;

    initial begin
        $readmemh("dense_w.mem", w);
        $readmemh("dense_b.mem", b);
    end

    always @(*) begin
        acc = 0;
        product = 0;
        result64 = 0;

        for (i = 0; i < 1568; i = i + 1) begin
            product =
                $signed(flatten_input[i*16 +: 16])
                * $signed(w[i]);

            acc = acc + product;
        end

        result64 = (acc >>> 8) + b[0];

        out = result64[15:0];
    end

endmodule