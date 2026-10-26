module sigmoid_approx (
    input wire signed [15:0] dense_in,
    output reg [15:0] sigmoid_out
);

    always @(*) begin

        if (dense_in <= -2048)
            sigmoid_out = 16'd0;

        else if (dense_in >= 2048)
            sigmoid_out = 16'd256;

        else if (dense_in < -1024)
            sigmoid_out = 16'd5;

        else if (dense_in < -512)
            sigmoid_out = 16'd31;

        else if (dense_in < -256)
            sigmoid_out = 16'd69;

        else if (dense_in < 0)
            sigmoid_out = 16'd93;

        else if (dense_in == 0)
            sigmoid_out = 16'd128;

        else if (dense_in < 256)
            sigmoid_out = 16'd163;

        else if (dense_in < 512)
            sigmoid_out = 16'd187;

        else if (dense_in < 1024)
            sigmoid_out = 16'd225;

        else
            sigmoid_out = 16'd251;

    end

endmodule