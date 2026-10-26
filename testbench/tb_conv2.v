
`timescale 1ns/1ps

module conv2_tb;

    reg [1151:0] input_patch;
    reg [2:0] filter_id;
    wire signed [15:0] out;

    reg signed [15:0] conv1_mem [0:7199];
    reg signed [15:0] ref_mem [0:6271];

    integer r, c, f;
    integer ki, kj, ch;
    integer slot, src_idx, idx;
    integer mismatches, matches;

    conv2_mem dut (
        .input_patch(input_patch),
        .filter_id(filter_id),
        .out(out)
    );

    initial begin
        $readmemh("conv1_relu_all.mem", conv1_mem);
        $readmemh("conv2_python_all.mem", ref_mem);

        input_patch = 0;
        filter_id = 0;
        mismatches = 0;
        matches = 0;

        for (r = 0; r < 28; r = r + 1) begin
            for (c = 0; c < 28; c = c + 1) begin

                // Tao patch 3x3x8 tu dau ra Conv1 sau ReLU
                for (ki = 0; ki < 3; ki = ki + 1) begin
                    for (kj = 0; kj < 3; kj = kj + 1) begin
                        for (ch = 0; ch < 8; ch = ch + 1) begin
                            slot = (ki * 3 + kj) * 8 + ch;
                            src_idx =
                                ((r + ki) * 30 + (c + kj)) * 8 + ch;

                            input_patch[slot*16 +: 16] =
                                conv1_mem[src_idx];
                        end
                    end
                end

                // Kiem tra ca 8 filter tai vi tri (r,c)
                for (f = 0; f < 8; f = f + 1) begin
                    filter_id = f;
                    idx = (r * 28 + c) * 8 + f;

                    #1;

                    if (out !== ref_mem[idx]) begin
                        mismatches = mismatches + 1;

                        if (mismatches <= 10) begin
                            $display(
                                "Mismatch: row=%0d col=%0d filter=%0d Verilog=%0d Python=%0d",
                                r, c, f, out, ref_mem[idx]
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
            $display("PASS: All Conv2 outputs match Python.");
        else
            $display("FAIL: Conv2 outputs do not all match.");

        $finish;
    end

endmodule
