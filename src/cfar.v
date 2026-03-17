`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

parameter N = 8;
parameter CUT_INDEX = 4; // center

reg [7:0] window [0:N-1];
integer i;

// registers
reg [15:0] sum;
reg [7:0] avg;
reg [8:0] threshold;
reg [7:0] cut;

// ── Shift register ─────────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < N; i = i + 1)
            window[i] <= 0;
    end else if (valid_in) begin
        for (i = N-1; i > 0; i = i - 1)
            window[i] <= window[i-1];

        window[0] <= data_in;
    end
end

// ── CFAR computation ───────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum       <= 0;
        avg       <= 0;
        threshold <= 0;
        detect    <= 0;
        cut       <= 0;
    end else if (valid_in) begin

        // capture CUT
        cut <= window[CUT_INDEX];

        // compute sum (blocking is OK inside loop temp)
        sum = 0;
        for (i = 0; i < N; i = i + 1) begin
            if (i != CUT_INDEX)
                sum = sum + window[i];
        end

        // average
        avg <= sum >> 3; // divide by 8

        // threshold (1.5x)
        threshold <= avg + (avg >> 1);

        // detection using CUT (correct)
        detect <= (cut > threshold);
    end
end

endmodule
