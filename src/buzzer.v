module buzzer(
    input clk,
    input detect,
    output reg buzzer_out
);

reg [11:0] hold_counter;

always @(posedge clk) begin
    if(detect) begin
        hold_counter <= 12'd2000;
        buzzer_out <= 1;
    end
    else if(hold_counter > 0) begin
        hold_counter <= hold_counter - 1;
        buzzer_out <= 1;
    end
    else begin
        buzzer_out <= 0;
    end
end

endmodule
