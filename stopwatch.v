module stopwatch (
    input           CLK,
    input           SW_MODE,
    input           SW_RUN,
    output [3:0]    s0,
    output [3:0]    s1,
    output [3:0]    m0,
    output [3:0]    m1
);

reg  [3:0] sw_s0, sw_s1, sw_m0, sw_m1;

wire s0_carry = SW_RUN && (sw_s0 == 4'd9);
wire s1_carry = s0_carry && (sw_s1 == 4'd5);
wire m0_carry = s1_carry && (sw_m0 == 4'd9);

always @(posedge CLK)
    if (~SW_MODE)
        sw_s0 <= 4'd0;
    else if (SW_RUN)
        sw_s0 <= (sw_s0 == 4'd9) ? 4'd0 : sw_s0 + 1'b1;

always @(posedge CLK)
    if (~SW_MODE)
        sw_s1 <= 4'd0;
    else if (s0_carry)
        sw_s1 <= (sw_s1 == 4'd5) ? 4'd0 : sw_s1 + 1'b1;

always @(posedge CLK)
    if (~SW_MODE)
        sw_m0 <= 4'd0;
    else if (s1_carry)
        sw_m0 <= (sw_m0 == 4'd9) ? 4'd0 : sw_m0 + 1'b1;

always @(posedge CLK)
    if (~SW_MODE)
        sw_m1 <= 4'd0;
    else if (m0_carry)
        sw_m1 <= (sw_m1 == 4'd5) ? 4'd0 : sw_m1 + 1'b1;

assign s0 = sw_s0;
assign s1 = sw_s1;
assign m0 = sw_m0;
assign m1 = sw_m1;

endmodule
