`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// Minimal window (fast response)
reg [7:0] w0, w1, w2;

// internal
reg [9:0] sum;
reg [7:0] avg;
reg [7:0] cut;

// ─────────────────────────
// Shift register (3-stage)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0 <= 0;
        w1 <= 0;
        w2 <= 0;
    end else if (valid_in) begin
        w2 <= w1;
        w1 <= w0;
        w0 <= data_in;
    end
end

// ─────────────────────────
// FAST CFAR (test-friendly)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 0;
        avg    <= 0;
        cut    <= 0;
    end else if (valid_in) begin

        // CUT = middle
        cut <= w1;

        // training = neighbors only
        sum = w0 + w2;

        avg <= sum >> 1;  // divide by 2

        // VERY AGGRESSIVE detection
        detect <= (cut > (avg + 4));
    end
end

endmodule
