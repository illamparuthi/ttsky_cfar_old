`default_nettype none

module cfar (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] sample_in,
    output reg        detect
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        detect <= 1'b0;
    end
    else begin
        // Simple spike detector (CFAR approximation)
        if (sample_in > 8'd100)
            detect <= 1'b1;
        else
            detect <= 1'b0;
    end
end

endmodule
