`default_nettype none

module cfar_core (
    input        clk,
    input        rst_n,
    input  [7:0] data_in,
    output       detect
);

wire rst = ~rst_n;

// -------------------------------
// Sliding Window
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
// CUT and Training cells
// -------------------------------
wire [7:0] cut = w4;

// use fewer training cells → stronger detection
wire [10:0] sum = w0 + w1 + w6 + w7;

// -------------------------------
// GL-safe noise estimate
// -------------------------------
wire [7:0] noise = sum >> 2;   // divide by 4 (no division hardware)

// -------------------------------
// Lower threshold
// -------------------------------
wire [7:0] threshold = noise + 8'd5;

// -------------------------------
// Pipeline + Detection
// -------------------------------
reg detect_r;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect_r <= 0;
    end else begin
        // direct comparison (no extra pipeline delay)
        if (cut > threshold)
            detect_r <= 1'b1;
        else
            detect_r <= 1'b0;
    end
end

assign detect = detect_r;

endmodule
