module buzzer_test (
    input  CLK_10K,   // 10kHz, pin 56
    output speaker    // pin 52
);

reg [15:0] cnt = 16'd0;

always @(posedge CLK_10K) begin
    cnt <= cnt + 1'b1;
end

assign speaker = cnt[1];  // 10kHz / 4 = 2.5kHz

endmodule
