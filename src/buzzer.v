module buzzer(
    input clk,
    input detect,
    input rst,
    output reg buzzer_out
);

reg [11:0] hold_counter;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        hold_counter <= 0;
        buzzer_out <= 0;
    end
    else if(detect) begin
        hold_counter <= 2000;
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
