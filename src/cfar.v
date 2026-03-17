`timescale 1ns / 1ps

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

// ── Parameters ─────────────────────────────
parameter N = 8;  // number of reference cells

// ── Registers (ALL declared at module level) ─────────────────────
reg [7:0] window [0:N-1];
reg [15:0] sum;
reg [7:0] avg;
reg [8:0] threshold;

integer i;

// ── CFAR Logic ────────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum       <= 0;
        avg       <= 0;
        threshold <= 0;
        detect    <= 0;

        for (i = 0; i < N; i = i + 1)
            window[i] <= 0;

    end else if (valid_in) begin

        // Shift window
        for (i = N-1; i > 0; i = i - 1)
            window[i] <= window[i-1];

        window[0] <= data_in;

        // Compute sum
        sum = 0;
        for (i = 0; i < N; i = i + 1)
            sum = sum + window[i];

        // Average
        avg = sum / N;

        // Threshold (simple scaling)
        threshold = avg + (avg >> 1); // 1.5x

        // Detection
        if (data_in > threshold)
            detect <= 1;
        else
            detect <= 0;
    end
end

endmodule
