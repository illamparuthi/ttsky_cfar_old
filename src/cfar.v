`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// Shift registers
reg [7:0] w0, w1, w2, w3, w4, w5;

// internal
reg [15:0] sum;
reg [7:0] avg;
reg [8:0] threshold;
reg [7:0] cut;

// ─────────────────────────
// Shift register (smaller window)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0 <= 0; w1 <= 0; w2 <= 0;
        w3 <= 0; w4 <= 0; w5 <= 0;
    end else if (valid_in) begin
        w5 <= w4;
        w4 <= w3;
        w3 <= w2;
        w2 <= w1;
        w1 <= w0;
        w0 <= data_in;
    end
end

// ─────────────────────────
// CFAR logic (fast + sensitive)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect    <= 0;
        avg       <= 0;
        threshold <= 0;
        cut       <= 0;
    end else if (valid_in) begin

        // CUT = center
        cut <= w3;

        // training cells (exclude neighbors)
        sum = w0 + w1 + w5;

        // avg
        avg <= sum / 3;

        // VERY IMPORTANT: low threshold
        threshold <= avg + (avg >> 2); // 1.25x

        // detection
        detect <= ({1'b0, cut} > threshold);
    end
end

endmodule
