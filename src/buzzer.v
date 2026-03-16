module buzzer(
    input clk,
    input rst,
    input detect,
    output reg buzzer_out
);

reg [11:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        buzzer_out <= 0;
    end
    else if (detect) begin
        counter <= 12'd2000;
        buzzer_out <= 1;
    end
    else if (counter > 0) begin
        counter <= counter - 1;
        buzzer_out <= 1;
    end
    else begin
        buzzer_out <= 0;
    end
end

endmodule
