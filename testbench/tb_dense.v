`timescale 1ns/1ps

module dense_tb;

    reg [25087:0] flatten_input;
    wire signed [15:0] out;

    reg signed [15:0] flatten_mem [0:1567];
    reg signed [15:0] ref_mem [0:0];

    integer i;
    integer mismatches;

    dense_mem dut (
        .flatten_input(flatten_input),
        .out(out)
    );

    initial begin

        $readmemh("maxpool_python_all.mem", flatten_mem);
        $readmemh("dense_python_ref.mem", ref_mem);

        flatten_input = 0;
        mismatches = 0;

        for (i = 0; i < 1568; i = i + 1) begin
            flatten_input[i*16 +: 16] = flatten_mem[i];
        end

        #10;

        $display("-----------------------------------");
        $display("Python Dense: %0d", ref_mem[0]);
        $display("Verilog Dense: %0d", out);

        if (out === ref_mem[0]) begin
            $display("Matches: 1");
            $display("Mismatches: 0");
            $display("PASS: Dense matches Python.");
        end
        else begin
            mismatches = 1;
            $display("Matches: 0");
            $display("Mismatches: 1");
            $display("FAIL: Dense mismatch.");
        end

        $finish;

    end

endmodule