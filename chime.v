module chime (
    input  M1D, M1C, M1B, M1A, M0D, M0C, M0B, M0A,
    input  S1D, S1C, S1B, S1A, S0D, S0C, S0B, S0A,
    input  tone_in,
    output chime_out
);

// combinational: detect minute=00 & second=00, gate 5kHz tone
wire min_zero = ({M1D, M1C, M1B, M1A, M0D, M0C, M0B, M0A} == 8'd0);
wire sec_zero = ({S1D, S1C, S1B, S1A, S0D, S0C, S0B, S0A} == 8'd0);

assign chime_out = (min_zero & sec_zero) ? tone_in : 1'b0;

endmodule
