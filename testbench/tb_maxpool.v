`timescale 1ns/1ps

module maxpool_tb;

    reg signed [15:0] in0;
    reg signed [15:0] in1;
    reg signed [15:0] in2;
    reg signed [15:0] in3;

    wire signed [15:0] out;

    reg signed [15:0] conv2_mem [0:6271];
    reg signed [15:0] ref_mem [0:1567];

    integer r, c, ch;
    integer idx;
    integer src0, src1, src2, src3;

    integer matches;
    integer mismatches;

    maxpool2x2 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );

    initial begin

        $readmemh("conv2_python_all.mem", conv2_mem);
        $readmemh("maxpool_python_all.mem", ref_mem);

        in0 = 0;
        in1 = 0;
        in2 = 0;
        in3 = 0;

        matches = 0;
        mismatches = 0;

        for (r = 0; r < 14; r = r + 1) begin
            for (c = 0; c < 14; c = c + 1) begin
                for (ch = 0; ch < 8; ch = ch + 1) begin

                    src0 = ((r*2)*28 + (c*2))*8 + ch;
                    src1 = ((r*2)*28 + (c*2+1))*8 + ch;
                    src2 = ((r*2+1)*28 + (c*2))*8 + ch;
                    src3 = ((r*2+1)*28 + (c*2+1))*8 + ch;

                    in0 = conv2_mem[src0];
                    in1 = conv2_mem[src1];
                    in2 = conv2_mem[src2];
                    in3 = conv2_mem[src3];

                    idx = (r*14 + c)*8 + ch;

                    #1;

                    if (out !== ref_mem[idx]) begin

                        mismatches = mismatches + 1;

                        if (mismatches <= 10) begin
                            $display(
                                "Mismatch r=%0d c=%0d ch=%0d Verilog=%0d Python=%0d",
                                r, c, ch, out, ref_mem[idx]
                            );
                        end

                    end
                    else begin
                        matches = matches + 1;
                    end

                end
            end
        end

        $display("-----------------------------------");

        $display("Total values checked: %0d",
                 matches + mismatches);

        $display("Matches: %0d", matches);

        $display("Mismatches: %0d", mismatches);

        if (mismatches == 0)
            $display("PASS: All MaxPool outputs match Python.");
        else
            $display("FAIL: MaxPool mismatch detected.");

        $finish;

    end

endmodule