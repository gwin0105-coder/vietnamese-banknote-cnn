
`timescale 1ns/1ps

module relu_tb;

    reg  signed [15:0] in;
    wire signed [15:0] out;

    relu uut (
        .in(in),
        .out(out)
    );

    initial begin

        // Test 1: negative
        in = -25;
        #10;

        $display("Input = %d, Output = %d", in, out);

        // Test 2: positive
        in = 80;
        #10;

        $display("Input = %d, Output = %d", in, out);

        $finish;

    end

endmodule

