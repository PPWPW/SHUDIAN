module carry_60 (
    input       IN1D, IN1C, IN1B, IN1A,
    input       IN0D, IN0C, IN0B, IN0A,
    output wire clk_60
);

wire [7:0] bcd_in;
assign bcd_in = {IN1D, IN1C, IN1B, IN1A, IN0D, IN0C, IN0B, IN0A};
assign clk_60 = (bcd_in == 8'b01011001);

endmodule