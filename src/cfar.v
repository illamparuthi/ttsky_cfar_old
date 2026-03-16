module cfar (
    input clk,
    input rst,
    input [7:0] sample_in,
    output reg detect
);

reg [7:0] noise_level;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        noise_level <= 8'd10;
        detect <= 0;
    end
    else begin
        noise_level <= (noise_level + sample_in) >> 1;

        if(sample_in > (noise_level << 2))
            detect <= 1;
        else
            detect <= 0;
    end
end

endmodule
