module classifier (
    input wire signed [15:0] dense_in,
    output wire prediction
);

    // Sigmoid >= 0.5 khi Dense >= 0
    assign prediction = (dense_in >= 16'sd0);

endmodule