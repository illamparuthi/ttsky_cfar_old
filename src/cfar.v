`default_nettype none

module cfar_core (
    input clk,
    input rst_n,
    input [7:0] data_in,
    output detect
);

wire rst = ~rst_n;

// Sliding window
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
        w0 <= data_in;   // ✅ FIXED
    end
end

// CFAR logic
wire [7:0] cut = w4;

wire [10:0] sum = w0 + w1 + w2 + w6 + w7;

// divide by 5 approximation
wire [15:0] mult = sum * 8'd51;
wire [7:0] noise = mult >> 8;

wire [7:0] threshold = noise + (noise >> 1);  // k ≈ 1.5

// pipeline
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

assign detect = detect_r;  // ✅ ONLY output

endmodule
