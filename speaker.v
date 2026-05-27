module speaker (
    input  clkin,
    output clk_high,
    output clk_middle,
    output clk_low
);

reg clk_high_reg   = 1'b1;
reg clk_middle_reg = 1'b1;
reg clk_low_reg    = 1'b1;

reg [2:0] cnt = 3'd0;

assign clk_high   = clk_high_reg;
assign clk_middle = clk_middle_reg;
assign clk_low    = clk_low_reg;

always @(posedge clkin) begin
    clk_high_reg <= ~clk_high_reg;

    if (cnt == 3'd5)
        cnt <= 3'd0;
    else
        cnt <= cnt + 1'b1;

    if (cnt[0] == 1'b0)
        clk_middle_reg <= ~clk_middle_reg;

    if (cnt == 3'd0 || cnt == 3'd3)
        clk_low_reg <= ~clk_low_reg;
end

endmodule 