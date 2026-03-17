`default_nettype none

module cfar (
    input              clk,
    input              rst,
    input      [7:0]   data_in,
    input              valid_in,
    output reg         detect
);

parameter N = 8;
parameter CUT_INDEX = 4;

reg [7:0] window [0:N-1];
integer i;

// Proper widths
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

// ── Combinational sum (FIXED) ─────────────
always @(*) begin
    sum = 0;
    for (i = 0; i < N; i = i + 1) begin
        if (i != CUT_INDEX)
            sum = sum + window[i];
    end
end

// ── Sequential logic ──────────────────────
always @(posedge clk or posedge rst) begin
    if (rst) begin
        avg       <= 0;
        threshold <= 0;
        detect    <= 0;
        cut       <= 0;
    end else if (valid_in) begin

        cut <= window[CUT_INDEX];

        // FIXED width handling
        avg <= sum[15:3];  // instead of sum >> 3

        // FIXED width match
        threshold <= {1'b0, avg} + ({1'b0, avg} >> 1);

        // FIXED comparison width
        detect <= ({1'b0, cut} > threshold);
    end
end

endmodule
