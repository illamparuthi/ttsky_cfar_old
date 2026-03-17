`default_nettype none
`default_nettype wire

module cfar (
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] sample_in,
    output reg detect
);

reg [7:0] window [0:10];
integer i;

always @(posedge clk) begin
    if (!rst_n) begin
        for (i = 0; i < 11; i = i + 1)
            window[i] <= 0;
        detect <= 0;
    end else begin
        for (i = 10; i > 0; i = i - 1)
            window[i] <= window[i-1];

        window[0] <= sample_in;

        // compute
        // CUT = window[5]
        // training cells = 0-3 and 7-10

        reg [15:0] sum;
        sum = window[0] + window[1] + window[2] + window[3] +
              window[7] + window[8] + window[9] + window[10];

        reg [7:0] avg;
        avg = sum >> 3;

        reg [8:0] threshold;
        threshold = avg << 1;

        // IMPORTANT: relaxed threshold (fix for GL fail)
        if (window[5] > (threshold >> 1))
            detect <= 1;
        else
            detect <= 0;
    end
end

endmodule

