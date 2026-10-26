module maxpool2x2 (
    input wire signed [15:0] in0,
    input wire signed [15:0] in1,
    input wire signed [15:0] in2,
    input wire signed [15:0] in3,

    output reg signed [15:0] out
);

    reg signed [15:0] max_value;

    always @(*) begin

        // ReLU
        max_value = 16'sd0;

        // MaxPooling 2x2
        if (in0 > max_value)
            max_value = in0;

        if (in1 > max_value)
            max_value = in1;

        if (in2 > max_value)
            max_value = in2;

        if (in3 > max_value)
            max_value = in3;

        out = max_value;

    end

endmodule