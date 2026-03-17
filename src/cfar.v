
`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// Shift registers
reg [7:0] w0, w1, w2, w3, w4, w5, w6, w7;

// Pipeline registers
reg [7:0] cut;
reg [7:0] avg;
reg [8:0] threshold;

// temp
reg [15:0] sum;

// ─────────────────────────
// Shift register
// ─────────────────────────
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

// ─────────────────────────
// CFAR pipeline (aligned)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cut       <= 0;
        avg       <= 0;
        threshold <= 0;
        detect    <= 0;
    end else if (valid_in) begin

        // Step 1: compute sum from OLD window
        sum = w0 + w1 + w2 + w3 + w5 + w6 + w7;

        // Step 2: compute avg
        avg <= sum[15:3];

        // Step 3: threshold
        threshold <= {1'b0, avg} + ({1'b0, avg} >> 1);

        // Step 4: CUT (same cycle reference)
        cut <= w4;

        // Step 5: detection using PREVIOUS stable values
        detect <= ({1'b0, cut} > threshold);
    end
end

endmodule
