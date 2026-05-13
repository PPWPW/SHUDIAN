module MOD_60 (
    input CLK,
    input EN,
    input IN1D, IN1C, IN1B, IN1A,
    input IN0D, IN0C, IN0B, IN0A,
    output reg OUT1D, OUT1C, OUT1B, OUT1A,
    output reg OUT0D, OUT0C, OUT0B, OUT0A
);

reg [3:0] ten_reg = 4'd0;
reg [3:0] one_reg = 4'd0;

always @(*) begin
    {OUT1D, OUT1C, OUT1B, OUT1A} = ten_reg;
    {OUT0D, OUT0C, OUT0B, OUT0A} = one_reg;
end

always @(posedge CLK) begin
    if (EN == 1'b0) begin
        ten_reg <= {IN1D, IN1C, IN1B, IN1A};
        one_reg <= {IN0D, IN0C, IN0B, IN0A};
    end else begin
        if (one_reg == 4'd9) begin
            one_reg <= 4'd0;
            if (ten_reg == 4'd5)
                ten_reg <= 4'd0;
            else
                ten_reg <= ten_reg + 1'b1;
        end else begin
            one_reg <= one_reg + 1'b1;
        end
    end
end

endmodule 