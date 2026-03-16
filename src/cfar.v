module cfar (
    input clk,
    input rst,
    input [7:0] sample_in,
    output reg detect
);

reg [7:0] prev1, prev2, prev3, prev4;
reg [9:0] noise_avg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        prev1 <= 0;
        prev2 <= 0;
        prev3 <= 0;
        prev4 <= 0;
        detect <= 0;
    end
    else begin

        // compute average noise
        noise_avg = (prev1 + prev2 + prev3 + prev4) >> 2;

        // CFAR detection rule
        if(sample_in > (noise_avg << 1))
            detect <= 1;
        else
            detect <= 0;

        // shift register
        prev4 <= prev3;
        prev3 <= prev2;
        prev2 <= prev1;
        prev1 <= sample_in;

    end
end

endmodule
