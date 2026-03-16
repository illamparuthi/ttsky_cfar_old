`default_nettype none

module cfar (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] sample_in,
    output reg        detect
);

reg [7:0] noise_avg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        noise_avg <= 8'd10;
        detect <= 1'b0;
    end
    else begin
        // simple running average
        noise_avg <= (noise_avg + sample_in) >> 1;

        // detection rule
        if (sample_in > (noise_avg << 2))
            detect <= 1'b1;
        else
            detect <= 1'b0;
    end
end

endmodule
