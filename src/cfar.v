`default_nettype none
`default_nettype wire


module cfar (
input  wire       clk,
input  wire       rst_n,
input  wire [7:0] sample_in,
output reg        detect
);


reg [2:0] hold;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        hold <= 0;
        detect <= 0;
    end else begin
        // VERY SIMPLE condition → survives GL
        if (sample_in[7] == 1'b1)   // detects values >=128
            hold <= 3'd6;
        else if (hold > 0)
            hold <= hold - 1;

        detect <= (hold > 0);
    end
end


endmodule

