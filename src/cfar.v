module cfar (
    input clk,
    input rst,
    input [7:0] sample_in,
    output reg detect
);

reg [7:0] noise_level;

always @(posedge clk) begin

    // simple running noise estimate
    noise_level <= (noise_level + sample_in) >> 1;

    // CFAR rule
    if(sample_in > (noise_level << 2))   // spike detection
        detect <= 1;
    else
        detect <= 0;

end

endmodule
