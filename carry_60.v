module carry_60 (
    input       CLK,
    input       IN1D, IN1C, IN1B, IN1A,
    input       IN0D, IN0C, IN0B, IN0A,
    output reg  clk_60
);

wire [7:0] bcd_in;
assign bcd_in = {IN1D, IN1C, IN1B, IN1A, IN0D, IN0C, IN0B, IN0A};
    
always @(posedge CLK) begin
    if (bcd_in == 8'b01011001)
        clk_60 <= 1'b1;
    else
        clk_60 <= 1'b0;
end

endmodule 