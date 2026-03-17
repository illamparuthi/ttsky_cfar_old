`default_nettype none
`default_nettype wire


module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);

reg [7:0] prev;
reg [2:0] hold;

always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
prev   <= 0;
detect <= 0;
hold   <= 0;
end else begin
prev <= sample_in;


    // spike detection
    if (sample_in > prev + 8'd50)
        hold <= 3'd6;
    else if (hold > 0)
        hold <= hold - 1;

    detect <= (hold > 0);
end


end

endmodule

