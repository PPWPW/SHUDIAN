module hour_convert (
    input  [3:0] H_ten,
    input  [3:0] H_one,
    input        mode_12h,
    output [3:0] D_ten,
    output [3:0] D_one
);

wire is_13plus = (H_ten == 4'd2) || ((H_ten == 4'd1) && (H_one >= 4'd3));

wire borrow    = (H_one < 4'd2);
wire [3:0] sub_ten = H_ten - 4'd1 - {3'd0, borrow};
wire [3:0] sub_one = borrow ? (H_one + 4'd8) : (H_one - 4'd2);

assign D_ten = mode_12h && is_13plus ? sub_ten : H_ten;
assign D_one = mode_12h && is_13plus ? sub_one : H_one;

endmodule
