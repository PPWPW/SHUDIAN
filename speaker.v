module speaker (
    input  clkin,
    output clk_high,
    output clk_middle,
    output clk_low
);

reg clk_high_reg   = 1'b1;
reg clk_middle_reg = 1'b1;
reg clk_low_reg    = 1'b1;

reg [1:0] div4_cnt = 2'd0;
reg [2:0] div6_cnt = 3'd0;

assign clk_high   = clk_high_reg;
assign clk_middle = clk_middle_reg;
assign clk_low    = clk_low_reg;

always @(posedge clkin) begin
    clk_high_reg <= ~clk_high_reg;
end

always @(posedge clkin) begin
    if (div4_cnt == 2'd1) begin
        div4_cnt <= 2'd0;
        clk_middle_reg <= ~clk_middle_reg;
    end else begin
        div4_cnt <= div4_cnt + 1'b1;
    end
end

always @(posedge clkin) begin
    if (div6_cnt == 3'd2) begin
        div6_cnt <= 3'd0;
        clk_low_reg <= ~clk_low_reg;
    end else begin
        div6_cnt <= div6_cnt + 1'b1;
    end
end

endmodule 