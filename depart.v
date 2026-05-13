module depart (
    input  jg_in,
    input  clk,
    input  clk_high,
    input  clk_middle,
    input  clk_low,
    output reg speak_out
);

reg [5:0] div = 6'd0;

initial begin
    speak_out = 1'b0;
end

always @(posedge clk) begin
    if (jg_in == 1'b0) begin
        div <= 6'd0;
        speak_out <= 1'b0;
    end else begin
        if (div == 6'd59)
            div <= 6'd0;
        else
            div <= div + 1'b1;
        // div>0 and div<20 (1~19)
        //div>=20 and div<40 (20~39)
        //else (div=0 �� 40~59)
        if (div > 6'd0 && div < 6'd20)
            speak_out <= clk_high;
        else if (div >= 6'd20 && div < 6'd40)
            speak_out <= clk_middle;
        else
            speak_out <= clk_low;
    end
end

endmodule 