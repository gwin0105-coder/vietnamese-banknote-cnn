`timescale 1ns/1ps

module conv2d_tb;

    reg signed [15:0] p0, p1, p2;
    reg signed [15:0] p3, p4, p5;
    reg signed [15:0] p6, p7, p8;
    reg [2:0] filter_id;

    wire signed [15:0] out;

    reg signed [15:0] image_mem [0:1023];
    reg signed [15:0] ref_mem [0:7199];

    integer r, c, f;
    integer idx;
    integer mismatches;
    integer matches;

    conv2d_mem dut (
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8),
        .filter_id(filter_id),
        .out(out)
    );

    initial begin
        $readmemh("image32_q.mem", image_mem);
        $readmemh("conv1_python_all.mem", ref_mem);

        mismatches = 0;
        matches = 0;

        for (r = 0; r < 30; r = r + 1) begin
            for (c = 0; c < 30; c = c + 1) begin

                p0 = image_mem[r*32+c];
                p1 = image_mem[r*32+c+1];
                p2 = image_mem[r*32+c+2];

                p3 = image_mem[(r+1)*32+c];
                p4 = image_mem[(r+1)*32+c+1];
                p5 = image_mem[(r+1)*32+c+2];

                p6 = image_mem[(r+2)*32+c];
                p7 = image_mem[(r+2)*32+c+1];
                p8 = image_mem[(r+2)*32+c+2];

                for (f = 0; f < 8; f = f + 1) begin
                    filter_id = f;
                    idx = (r*30+c)*8+f;

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
        $display("Total values checked: %0d", matches + mismatches);
        $display("Matches: %0d", matches);
        $display("Mismatches: %0d", mismatches);

        if (mismatches == 0)
            $display("PASS: All 8 Conv1 filters match Python.");
        else
            $display("FAIL: Conv1 outputs do not all match.");

        $finish;
    end

endmodule