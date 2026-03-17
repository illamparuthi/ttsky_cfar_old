`timescale 1ns/1ps
`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// ─────────────────────────
// 3-stage shift register
// ─────────────────────────
reg [7:0] w0, w1, w2;

// Detection hold counter
reg [3:0] detect_hold;

// ─────────────────────────
// Shift logic
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w0 <= 8'd0;
        w1 <= 8'd0;
        w2 <= 8'd0;
    end else if (valid_in) begin
        w2 <= w1;
        w1 <= w0;
        w0 <= data_in;
    end
end

// ─────────────────────────
// Combinational CFAR signals
// ─────────────────────────
wire [9:0] sum_comb = w0 + w2;        // training cells
wire [7:0] avg_comb = sum_comb[9:1];  // divide by 2
wire [7:0] cut_comb = w1;             // CUT (center)

// ─────────────────────────
// Detection with HOLD (critical fix)
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 1'b0;
        detect_hold <= 4'd0;
    end else if (valid_in) begin

        // Trigger detection
        if (cut_comb > (avg_comb + 8'd2)) begin
            detect <= 1'b1;
            detect_hold <= 4'd10;   // hold for 10 cycles
        end 

        // Hold detection (prevents missing pulse in GL)
        else if (detect_hold != 0) begin
            detect_hold <= detect_hold - 1;
            detect <= 1'b1;
        end 

        // No detection
        else begin
            detect <= 1'b0;
        end
    end
end

endmodule
