
module relu (
    input  wire signed [15:0] in,
    output wire signed [15:0] out
);

    assign out = (in < 0) ? 16'sd0 : in;

endmodule

