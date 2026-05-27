module depart (
    input  jg_in,
    input  clk,
    input  clk_fast,
    input  clk_high,
    input  clk_middle,
    input  clk_low,
    output speak_out
);

reg [5:0] div = 6'd0;
reg speak_out_reg;

always @(posedge clk) begin
    if (jg_in == 1'b0) begin
        div <= 6'd0;
    end else begin
        if (div < 6'd59)
            div <= div + 1'b1;
    end
end

wire tone_clk;
assign tone_clk = (div >= 6'd0 && div < 6'd20)  ? clk_high
                : (div >= 6'd20 && div < 6'd40) ? clk_middle
                : clk_low;

always @(posedge clk_fast) begin
    speak_out_reg <= jg_in ? tone_clk : 1'b0;
end

assign speak_out = speak_out_reg;

endmodule
