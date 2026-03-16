`default_nettype none

module cfar (
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] sample_in,
    output reg detect
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        detect <= 1'b0;
    else
        detect <= (sample_in > 8'd50);
end

endmodule
