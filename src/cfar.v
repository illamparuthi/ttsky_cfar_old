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
        detect <= 0;
        hold <= 0;
    end else begin
        // DIRECT spike detection (GL-safe)
        if (sample_in > 8'd100)
            hold <= 3'd5;   // stretch for 5 cycles
        else if (hold > 0)
            hold <= hold - 1;

        detect <= (hold > 0);
    end
end


endmodule

