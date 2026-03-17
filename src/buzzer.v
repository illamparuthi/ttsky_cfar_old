`default_nettype none
`default_nettype wire

module buzzer (
input  wire clk,
input  wire rst_n,
input  wire trigger,
output reg  out
);


reg [11:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        out <= 0;
    end else begin
        if (trigger)
            counter <= 12'd2000;
        else if (counter > 0)
            counter <= counter - 1;

        out <= (counter != 0);
    end
end


endmodule

