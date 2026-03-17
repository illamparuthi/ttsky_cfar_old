`default_nettype none
`default_nettype wire


module buzzer (
input  wire clk,
input  wire rst,
input  wire detect,
output reg  buzzer_out
);


reg [11:0] counter;

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        buzzer_out <= 0;
    end else begin
        if (detect)
            counter <= 12'd2000;
        else if (counter > 0)
            counter <= counter - 1;

        buzzer_out <= (counter > 0);
    end
end


endmodule

