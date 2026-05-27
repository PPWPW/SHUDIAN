module alarm_storage (
    input       CLK,
    input       EN_set,
    input       IN1D, IN1C, IN1B, IN1A,
    input       IN0D, IN0C, IN0B, IN0A,
    output [3:0] OUT1,
    output [3:0] OUT0
);
reg [3:0] OUT1_r = 4'd0;
reg [3:0] OUT0_r = 4'd0;

assign OUT1 = OUT1_r;
assign OUT0 = OUT0_r;

always @(posedge CLK) begin
    if (EN_set) begin
        OUT1_r <= {IN1D, IN1C, IN1B, IN1A};
        OUT0_r <= {IN0D, IN0C, IN0B, IN0A};
    end
end

endmodule 