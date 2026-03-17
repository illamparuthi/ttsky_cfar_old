`default_nettype none
module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// Shift register
reg [7:0] w0, w1, w2;

// Use wires for combinational intermediate values
// so the detect comparison uses fresh data in the same cycle
wire [9:0] sum_comb  = w0 + w2;
wire [7:0] avg_comb  = sum_comb[9:1];   // divide by 2, no truncation
wire [7:0] cut_comb  = w1;              // CUT is always current w1

// ─────────────────────────
// Shift register (3-stage)
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
// Detection
// ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 1'b0;
    end else if (valid_in) begin
        // cut_comb and avg_comb are wires — no pipeline lag
        detect <= (cut_comb > (avg_comb + 8'd4));
    end
end

endmodule
