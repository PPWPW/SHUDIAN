module alarm_judge (
    input       clk,
    input       EN1,
    input       alarm_sw,
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
    if (alarm_sw && alarm_en == 1'b1 && MOA == M1A && MOB == M1B && HOA == H1A && HOB == H1B)
        jg_out <= 1'b1;
    else
        jg_out <= 1'b0;
end

endmodule 