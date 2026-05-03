module Decoder_2to4 (
    input  inB, inA,
    input  EN,
    output reg outD,
    output reg outC,
    output reg outB,
    output reg outA
);

always @(*) begin
    if (EN == 1'b0) begin
        outD = 1'b1;
        outC = 1'b1;
        outB = 1'b1;
        outA = 1'b1;
    end else begin
        case ({inB, inA})
            2'b00: begin outD=1'b1; outC=1'b1; outB=1'b1; outA=1'b0; end
            2'b01: begin outD=1'b1; outC=1'b1; outB=1'b0; outA=1'b1; end
            2'b10: begin outD=1'b1; outC=1'b0; outB=1'b1; outA=1'b1; end
            2'b11: begin outD=1'b0; outC=1'b1; outB=1'b1; outA=1'b1; end
            default: begin outD=1'b1; outC=1'b1; outB=1'b1; outA=1'b1; end
        endcase
    end
end

endmodule 