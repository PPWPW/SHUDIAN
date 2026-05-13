//       MOA[3:0] - ��ǰ����ʮλ BCD
//       MOB[3:0] - ��ǰ���Ӹ�λ BCD
//       HOA[3:0] - ��ǰСʱʮλ BCD
//       HOB[3:0] - ��ǰСʱ��λ BCD
//       M1A[3:0] - ���ӷ���ʮλ BCD
//       M1B[3:0] - ���ӷ��Ӹ�λ BCD
//       H1A[3:0] - ����Сʱʮλ BCD
//       H1B[3:0] - ����Сʱ��λ BCD
module alarm_judge (
    input       clk,
    input       EN1,
    input [3:0] MOA, MOB, HOA, HOB,
    input [3:0] M1A, M1B, H1A, H1B,
    output reg  jg_out
);

reg alarm_en = 1'b0;

initial begin
    jg_out = 1'b0;
end

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