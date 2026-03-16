
module cfar (
    input clk,
    input rst,
    input [7:0] sample_in,
    output reg detect
);

parameter THRESHOLD_FACTOR = 2;

reg [7:0] window [0:10];
integer i;

reg [15:0] noise_sum;
reg [7:0] threshold;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for(i=0;i<11;i=i+1)
            window[i] <= 0;
        detect <= 0;
    end
    else begin

        // shift window
        for(i=10;i>0;i=i-1)
            window[i] <= window[i-1];

        window[0] <= sample_in;

        // calculate noise from training cells
        noise_sum = window[0] + window[1] + window[2] + window[3] +
                    window[7] + window[8] + window[9] + window[10];

        threshold = (noise_sum >> 3) * THRESHOLD_FACTOR;

        // CUT = window[5]
        if(window[5] > threshold)
            detect <= 1;
        else
            detect <= 0;

    end
end

endmodule
