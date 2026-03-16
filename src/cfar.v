module cfar (
    input clk,
    input rst,
    input [7:0] sample_in,
    output reg detect
);

parameter THRESHOLD_FACTOR = 2;

reg [7:0] window [0:7];
integer i;

reg [15:0] noise_sum;
reg [7:0] threshold;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for(i=0;i<8;i=i+1)
            window[i] <= 0;
        detect <= 0;
    end
    else begin

        // shift history
        for(i=7;i>0;i=i-1)
            window[i] <= window[i-1];

        window[0] <= sample_in;

        // estimate noise from previous samples
        noise_sum = window[1] + window[2] + window[3] + window[4] +
                    window[5] + window[6] + window[7];

        threshold = (noise_sum >> 3) * THRESHOLD_FACTOR;

        // current sample is CUT
        if(sample_in > threshold)
            detect <= 1;
        else
            detect <= 0;

    end
end

endmodule
