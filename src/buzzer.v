module buzzer(
    input clk,
    input detect,
    output reg buzzer_out
);

always @(posedge clk) begin
    if(detect)
        buzzer_out <= 1;
    else
        buzzer_out <= 0;
end

endmodule
