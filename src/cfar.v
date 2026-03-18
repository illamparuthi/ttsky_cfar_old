`default_nettype none

module cfar_core (
    input        clk,
    input        rst_n,
    input  [7:0] data_in,
    output       detect
);

wire rst = ~rst_n;

// -------------------------------
// Sliding Window (8 samples)
// -------------------------------
reg [7:0] w0, w1, w2, w3, w4, w5, w6, w7;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0<=0; w1<=0; w2<=0; w3<=0;
        w4<=0; w5<=0; w6<=0; w7<=0;
    end else begin
        w7 <= w6;
        w6 <= w5;
        w5 <= w4;
        w4 <= w3;
        w3 <= w2;
        w2 <= w1;
        w1 <= w0;
        w0 <= data_in;
    end
end

// -------------------------------
// CFAR structure
// [T T T G C G T T]
// -------------------------------

// CUT
wire [7:0] cut = w4;

// Training cells (exclude guards)
wire [10:0] sum = w0 + w1 + w2 + w6 + w7;

// -------------------------------
// SAFE noise estimate (NO MULTIPLY)
// noise ≈ sum / 5
// -------------------------------
wire [7:0] noise = sum / 5;

// -------------------------------
// STABLE threshold (GL-safe)
// -------------------------------
wire [7:0] threshold = noise + 8'd10;

// -------------------------------
// Pipeline
// -------------------------------
reg [7:0] cut_r, thr_r;
reg detect_r;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cut_r <= 0;
        thr_r <= 0;
        detect_r <= 0;
    end else begin
        cut_r <= cut;
        thr_r <= threshold;
        detect_r <= (cut_r > thr_r);
    end
end

// -------------------------------
// Output
// -------------------------------
detect_r <= (cut_r > (thr_r - 8'd5));

endmodule
