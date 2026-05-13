module alarm_storage (
    input       CLK, CLK1,
    input       EN, EN1,
    input       IN1D, IN1C, IN1B, IN1A,
    input       IN0D, IN0C, IN0B, IN0A,
    output reg [3:0] OUT1,
    output reg [3:0] OUT0
);
reg [3:0] Q1 = 4'd0;
reg [3:0] Q0 = 4'd0;

initial begin
    OUT1 = 4'd0;
    OUT0 = 4'd0;
end

always @(posedge CLK) begin
    if (EN == 1'b0 && EN1 == 1'b1) begin
        Q1 <= {IN1D, IN1C, IN1B, IN1A};
        Q0 <= {IN0D, IN0C, IN0B, IN0A};
    end
end

always @(posedge CLK1) begin
    if (EN == 1'b1 && EN1 == 1'b0) begin
        OUT1 <= Q1;
        OUT0 <= Q0;
    end
end

endmodule 