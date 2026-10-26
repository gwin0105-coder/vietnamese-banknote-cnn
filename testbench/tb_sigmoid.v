`timescale 1ns/1ps

module sigmoid_tb;

    reg signed [15:0] dense_in;
    wire [15:0] sigmoid_out;

    sigmoid_approx dut (
        .dense_in(dense_in),
        .sigmoid_out(sigmoid_out)
    );

    initial begin

        dense_in = -145;

        #10;

        $display("-------------------------");
        $display("Dense Q8.8: %0d", dense_in);
        $display("Sigmoid Q8.8: %0d", sigmoid_out);
        $display("Sigmoid approximate: %f",
                 sigmoid_out / 256.0);

        $finish;

    end

endmodule