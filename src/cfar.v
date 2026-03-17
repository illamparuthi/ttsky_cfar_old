`default_nettype none

module cfar (
input  wire        clk,
input  wire        rst_n,
input  wire [7:0]  sample_in,
output reg         detect
);

```
// Sliding window of 11 samples
reg [7:0] window [0:10];

integer i;

// Shift register
always @(posedge clk) begin
    if (!rst_n) begin
        for (i = 0; i < 11; i = i + 1)
            window[i] <= 0;
    end else begin
        for (i = 10; i > 0; i = i - 1)
            window[i] <= window[i-1];

        window[0] <= sample_in;
    end
end

// CUT (middle sample)
wire [7:0] cut = window[5];

// Training cells (exclude guard cells at 4 and 6)
wire [15:0] sum =
    window[0] + window[1] + window[2] + window[3] +
    window[7] + window[8] + window[9] + window[10];

// Average (8 cells → divide by 8)
wire [7:0] avg = sum >> 3;

// Threshold = 2 × average
wire [8:0] threshold = avg << 1;

// Detection
always @(posedge clk) begin
    if (!rst_n)
        detect <= 0;
    else if (cut > threshold)
        detect <= 1;
    else
        detect <= 0;
end
```

endmodule

`default_nettype wire
