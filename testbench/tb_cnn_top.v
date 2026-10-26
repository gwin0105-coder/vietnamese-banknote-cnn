`timescale 1ns/1ps

module tb_cnn_top;

    wire signed [15:0] dense_result;
    wire [15:0] sigmoid_result;
    wire prediction;

    reg signed [15:0] dense_reference [0:0];
    integer errors;

    cnn_top dut (
        .dense_result(dense_result),
        .sigmoid_result(sigmoid_result),
        .prediction(prediction)
    );

    initial begin
        errors = 0;

        $readmemh("dense_python_ref.mem", dense_reference);

        $display("======================================");
        $display(" CNN TOP-LEVEL VERIFICATION");
        $display("======================================");

        #100;

        $display("Python Dense reference : %0d", dense_reference[0]);
        $display("Verilog Dense output   : %0d", dense_result);
        $display("Sigmoid Q8.8            : %0d", sigmoid_result);
        $display("Prediction              : %0d", prediction);

        if ((^dense_result === 1'bx) ||
            (^sigmoid_result === 1'bx) ||
            (prediction === 1'bx)) begin
            $display("FAIL: Unknown output detected.");
            errors = errors + 1;
        end
        else if (dense_result !== dense_reference[0]) begin
            $display("FAIL: Dense output does not match Python.");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Dense matches Python.");
        end

        if (sigmoid_result !== 16'd93) begin
            $display("FAIL: Unexpected sigmoid result.");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Sigmoid result matches expected value.");
        end

        if (prediction !== 1'b0) begin
            $display("FAIL: Unexpected prediction.");
            errors = errors + 1;
        end
        else begin
            $display("PASS: Predicted class is 20000 VND.");
        end

        $display("--------------------------------------");

        if (errors == 0)
            $display("ALL TESTS PASSED.");
        else
            $display("TEST FAILED: %0d error(s).", errors);

        $display("======================================");
        $finish;
    end

endmodule