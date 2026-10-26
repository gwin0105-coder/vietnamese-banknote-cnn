module cnn_top (
    output wire signed [15:0] dense_result,
    output wire [15:0] sigmoid_result,
    output wire prediction
);

    // ==========================================
    // 1. INPUT IMAGE: 32 x 32 x 1
    // ==========================================
    reg signed [15:0] image [0:1023];

    initial begin
        $readmemh("image32_q.mem", image);
    end

    // ==========================================
    // 2. CONV1: 32x32x1 -> 30x30x8
    // ==========================================
    wire signed [15:0] conv1_out [0:7199];
    wire signed [15:0] conv1_relu [0:7199];

    genvar y1, x1, f1;

    generate
        for (y1 = 0; y1 < 30; y1 = y1 + 1) begin : C1_Y
            for (x1 = 0; x1 < 30; x1 = x1 + 1) begin : C1_X
                for (f1 = 0; f1 < 8; f1 = f1 + 1) begin : C1_F

                    localparam integer IDX =
                        ((y1 * 30 + x1) * 8 + f1);

                    conv2d_mem u_conv1 (
                        image[y1*32 + x1],
                        image[y1*32 + x1 + 1],
                        image[y1*32 + x1 + 2],

                        image[(y1+1)*32 + x1],
                        image[(y1+1)*32 + x1 + 1],
                        image[(y1+1)*32 + x1 + 2],

                        image[(y1+2)*32 + x1],
                        image[(y1+2)*32 + x1 + 1],
                        image[(y1+2)*32 + x1 + 2],

                        f1,
                        conv1_out[IDX]
                    );

                    // ReLU
                    assign conv1_relu[IDX] =
                        conv1_out[IDX][15]
                        ? 16'sd0
                        : conv1_out[IDX];

                end
            end
        end
    endgenerate

    // ==========================================
    // 3. CONV2 INPUT PATCHES: 3x3x8
    // ==========================================
    wire [1151:0] conv2_patch [0:783];

    genvar y2p, x2p, ky, kx, ch;

    generate
        for (y2p = 0; y2p < 28; y2p = y2p + 1) begin : P2_Y
            for (x2p = 0; x2p < 28; x2p = x2p + 1) begin : P2_X
                for (ky = 0; ky < 3; ky = ky + 1) begin : P2_KY
                    for (kx = 0; kx < 3; kx = kx + 1) begin : P2_KX
                        for (ch = 0; ch < 8; ch = ch + 1) begin : P2_CH

                            localparam integer SLOT =
                                ((ky * 3 + kx) * 8 + ch);

                            assign conv2_patch[y2p*28 + x2p]
                                [SLOT*16 +: 16] =
                                conv1_relu[
                                    (((y2p+ky)*30 + (x2p+kx))*8) + ch
                                ];

                        end
                    end
                end
            end
        end
    endgenerate

    // ==========================================
    // 4. CONV2: 30x30x8 -> 28x28x8
    // ==========================================
    wire signed [15:0] conv2_out [0:6271];
    wire signed [15:0] conv2_relu [0:6271];

    genvar y2, x2, f2;

    generate
        for (y2 = 0; y2 < 28; y2 = y2 + 1) begin : C2_Y
            for (x2 = 0; x2 < 28; x2 = x2 + 1) begin : C2_X
                for (f2 = 0; f2 < 8; f2 = f2 + 1) begin : C2_F

                    localparam integer IDX =
                        ((y2 * 28 + x2) * 8 + f2);

                    conv2_mem u_conv2 (
                        conv2_patch[y2*28 + x2],
                        f2,
                        conv2_out[IDX]
                    );

                    // ReLU
                    assign conv2_relu[IDX] =
                        conv2_out[IDX][15]
                        ? 16'sd0
                        : conv2_out[IDX];

                end
            end
        end
    endgenerate

    // ==========================================
    // 5. MAXPOOL 2x2: 28x28x8 -> 14x14x8
    // ==========================================
    wire signed [15:0] maxpool_out [0:1567];

    genvar yp, xp, fp;

    generate
        for (yp = 0; yp < 14; yp = yp + 1) begin : MP_Y
            for (xp = 0; xp < 14; xp = xp + 1) begin : MP_X
                for (fp = 0; fp < 8; fp = fp + 1) begin : MP_F

                    localparam integer IDX =
                        ((yp * 14 + xp) * 8 + fp);

                    maxpool2x2 u_pool (
                        conv2_relu[((2*yp)*28 + 2*xp)*8 + fp],
                        conv2_relu[((2*yp)*28 + 2*xp + 1)*8 + fp],
                        conv2_relu[((2*yp+1)*28 + 2*xp)*8 + fp],
                        conv2_relu[((2*yp+1)*28 + 2*xp + 1)*8 + fp],
                        maxpool_out[IDX]
                    );

                end
            end
        end
    endgenerate

    // ==========================================
    // 6. FLATTEN: 14x14x8 -> 1568
    // ==========================================
    wire [25087:0] flatten_bus;

    genvar k;

    generate
        for (k = 0; k < 1568; k = k + 1) begin : FLATTEN
            assign flatten_bus[k*16 +: 16] = maxpool_out[k];
        end
    endgenerate

    // ==========================================
    // 7. DENSE: 1568 -> 1
    // ==========================================
    dense_mem u_dense (
        flatten_bus,
        dense_result
    );

    // ==========================================
    // 8. SIGMOID
    // ==========================================
    sigmoid_approx u_sigmoid (
        dense_result,
        sigmoid_result
    );

    // ==========================================
    // 9. CLASSIFICATION
    // ==========================================
    classifier u_classifier (
        dense_result,
        prediction
    );

endmodule