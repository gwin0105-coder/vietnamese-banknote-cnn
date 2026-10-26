`timescale 1ns/1ps

module classifier_tb;

    reg signed [15:0] dense_in;
    wire prediction;

    integer matches;
    integer mismatches;

    classifier dut (
        .dense_in(dense_in),
        .prediction(prediction)
    );

    task check;
        input signed [15:0] value;
        input expected;

        begin
            dense_in = value;
            #1;

            if (prediction === expected) begin
                matches = matches + 1;
            end
            else begin
                mismatches = mismatches + 1;
                $display("FAIL: Dense=%0d", value);
            end
        end
    endtask

    initial begin
        matches = 0;
        mismatches = 0;

        // Gia tri Dense hien tai
        check(-145, 0);

        // Kiem tra them cac truong hop
        check(-256, 0);
        check(-1, 0);
        check(0, 1);
        check(1, 1);
        check(256, 1);

        $display("-------------------------------");
        $display("Total values checked: %0d",
                 matches + mismatches);
        $display("Matches: %0d", matches);
        $display("Mismatches: %0d", mismatches);

        if (mismatches == 0)
            $display("PASS: Classifier matches expected labels.");
        else
            $display("FAIL: Classifier mismatch.");

        $finish;
    end

endmodule