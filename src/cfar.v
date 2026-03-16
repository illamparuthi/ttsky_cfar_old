`default_nettype none

module cfar (
    input wire clk,
    input wire rst_n,
    input wire [7:0] sample_in,
    output reg detect
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        detect <= 1'b0;
    else if (sample_in > 8'd50)
        detect <= 1'b1;
    else
        detect <= 1'b0;
end

endmodule
