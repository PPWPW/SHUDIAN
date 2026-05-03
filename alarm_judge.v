//       MOA[3:0] - 当前分钟十位 BCD
//       MOB[3:0] - 当前分钟个位 BCD
//       HOA[3:0] - 当前小时十位 BCD
//       HOB[3:0] - 当前小时个位 BCD
//       M1A[3:0] - 闹钟分钟十位 BCD
//       M1B[3:0] - 闹钟分钟个位 BCD
//       H1A[3:0] - 闹钟小时十位 BCD
//       H1B[3:0] - 闹钟小时个位 BCD
module alarm_judge (
    input       clk,
    input       EN1,
    input [3:0] MOA, MOB, HOA, HOB,
    input [3:0] M1A, M1B, H1A, H1B,
    output reg  jg_out
);

reg alarm_en;

always @(posedge clk) begin
    if (EN1 == 1'b1)
        alarm_en <= 1'b1;
end

always @(posedge clk) begin
    if (alarm_en == 1'b1) begin
        if (MOA == M1A && MOB == M1B && HOA == H1A && HOB == H1B)
            jg_out <= 1'b1;
        else
            jg_out <= 1'b0;
    end else begin
        jg_out <= 1'b0;
    end
end

endmodule 