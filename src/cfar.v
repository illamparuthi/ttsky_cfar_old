`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// ─────────────────────────────────────────
// Shift register (manual, no arrays)
// ─────────────────────────────────────────
reg [7:0] w0, w1, w2, w3, w4, w5, w6, w7;

// CUT (center cell)
reg [7:0] cut;

// CFAR internal signals
reg [15:0] sum;
reg [7:0]  avg;
reg [8:0]  threshold;

// ─────────────────────────────────────────
// Shift logic
// ─────────────────────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0 <= 0; w1 <= 0; w2 <= 0; w3 <= 0;
        w4 <= 0; w5 <= 0; w6 <= 0; w7 <= 0;
    end else if (valid_in) begin
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

// ─────────────────────────────────────────
// Combinational sum (exclude CUT = w4)
// ─────────────────────────────────────────
always @(*) begin
    sum = w0 + w1 + w2 + w3 + w5 + w6 + w7;
end

// ─────────────────────────────────────────
// CFAR logic
// ─────────────────────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        avg       <= 0;
        threshold <= 0;
        detect    <= 0;
        cut       <= 0;
    end else if (valid_in) begin

        // Select CUT (center of window)
        cut <= w4;

        // Average (divide by 8 → shift)
        avg <= sum[15:3];

        // Threshold = 1.5 × avg
        threshold <= {1'b0, avg} + ({1'b0, avg} >> 1);

        // Detection
        detect <= ({1'b0, cut} > threshold);
    end
end

endmodule
