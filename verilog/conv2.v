
module conv2_mem (
    input wire [1151:0] input_patch,
    input wire [2:0] filter_id,
    output reg signed [15:0] out
);

    reg signed [15:0] w [0:575];
    reg signed [15:0] b [0:7];

    integer ki, kj, ch;
    integer slot, widx;

    reg signed [31:0] acc;
    reg signed [31:0] product;
    reg signed [31:0] result32;

    initial begin
        $readmemh("conv2_w.mem", w);
        $readmemh("conv2_b.mem", b);
    end

    always @(*) begin
        acc = 0;
        product = 0;
        slot = 0;
        widx = 0;

        for (ki = 0; ki < 3; ki = ki + 1) begin
            for (kj = 0; kj < 3; kj = kj + 1) begin
                for (ch = 0; ch < 8; ch = ch + 1) begin
                    slot = (ki * 3 + kj) * 8 + ch;
                    widx = slot * 8 + filter_id;

                    product =
                        $signed(input_patch[slot*16 +: 16])
                        * $signed(w[widx]);

                    acc = acc + product;
                end
            end
        end

        // Q16.16 -> Q8.8, sau do cong bias Q8.8
        result32 = (acc >>> 8) + b[filter_id];
        out = result32[15:0];
    end

endmodule
