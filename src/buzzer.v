`default_nettype none

module buzzer (
input  wire clk,
input  wire rst,
input  wire detect,
output reg  buzzer_out
);

```
always @(posedge clk) begin
    if (rst)
        buzzer_out <= 0;
    else
        buzzer_out <= detect;
end
```

endmodule

`default_nettype wire
