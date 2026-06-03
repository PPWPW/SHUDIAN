module DigitalClock (
    input           CLK,        // 1Hz clock, pin 58
    input           CLK_10K,    // 10kHz clock, pin 56 (alarm speaker)
    input           SW_MODE,    // pin 63, 0=clock, 1=stopwatch
    input           SW_RUN,     // pin 64, 0=pause, 1=run
    input           MODE_12_24, // pin 65, 0=24h, 1=12h
    input           ALARM_SW,   // pin 67, alarm on/off switch
    input           EN_setalarm,
    input           EN_setclock,
    input           settime0A,
    input           settime0B,
    input           settime0C,
    input           settime0D,
    input           settime1A,
    input           settime1B,
    input           settime1C,
    input           settime1D,
    input           SettimeA,
    input           SettimeB,
    output          Alarm,
    output          hour_high_A,
    output          hour_high_B,
    output          hour_high_C,
    output          hour_high_D,
    output          hour_low_A,
    output          hour_low_B,
    output          hour_low_C,
    output          hour_low_D,
    output          minute_high_A,
    output          minute_high_B,
    output          minute_high_C,
    output          minute_high_D,
    output          minute_low_A,
    output          minute_low_B,
    output          minute_low_C,
    output          minute_low_D,
    output          second_high_A,
    output          second_high_B,
    output          second_high_C,
    output          second_high_D,
    output          second_low_a,
    output          second_low_b,
    output          second_low_c,
    output          second_low_d,
    output          second_low_e,
    output          second_low_f,
    output          second_low_g,
    output          speaker
);

// ============================================================
// second counter wires
// ============================================================
wire    S1D, S1C, S1B, S1A;
wire    S0D, S0C, S0B, S0A;
wire    sec_carry;

// ============================================================
// minute counter wires
// ============================================================
wire    M1D, M1C, M1B, M1A;
wire    M0D, M0C, M0B, M0A;
wire    min_carry;

// ============================================================
// hour counter wires
// ============================================================
wire    H1D, H1C, H1B, H1A;
wire    H0D, H0C, H0B, H0A;

// ============================================================
// alarm storage wires
// ============================================================
wire [3:0] alm_min_1, alm_min_0;
wire [3:0] alm_hour_1, alm_hour_0;

// ============================================================
// alarm / speaker wires
// ============================================================
wire jg_out;
wire spk_high, spk_middle, spk_low;

// ============================================================
// time setting
// ============================================================
wire [3:0] set_tens = {settime0D, settime0C, settime0B, settime0A};
wire [3:0] set_ones = {settime1D, settime1C, settime1B, settime1A};

wire dec_outD, dec_outC, dec_outB, dec_outA;

Decoder_2to4 u_dec_set (
    .inB        (SettimeB),
    .inA        (SettimeA),
    .EN         (EN_setclock),
    .outD       (dec_outD),
    .outC       (dec_outC),
    .outB       (dec_outB),
    .outA       (dec_outA)
);

wire set_sec  = ~dec_outA;
wire set_min  = ~dec_outB;
wire set_hour = ~dec_outC;

wire sec_carry_gated = sec_carry & ~set_sec;
wire min_carry_gated = min_carry & sec_carry & ~set_min;

// ============================================================
// alarm setting
// ============================================================
wire alm_set_min  = EN_setalarm && ~SettimeA;
wire alm_set_hour = EN_setalarm &&  SettimeA;

// ============================================================
// second counter: MOD_60
// ============================================================
MOD_60 u_sec (
    .CLK        (CLK),
    .EN         (~set_sec),
    .IN1D       (set_sec ? set_tens[3] : S1D),
    .IN1C       (set_sec ? set_tens[2] : S1C),
    .IN1B       (set_sec ? set_tens[1] : S1B),
    .IN1A       (set_sec ? set_tens[0] : S1A),
    .IN0D       (set_sec ? set_ones[3] : S0D),
    .IN0C       (set_sec ? set_ones[2] : S0C),
    .IN0B       (set_sec ? set_ones[1] : S0B),
    .IN0A       (set_sec ? set_ones[0] : S0A),
    .OUT1D      (S1D),
    .OUT1C      (S1C),
    .OUT1B      (S1B),
    .OUT1A      (S1A),
    .OUT0D      (S0D),
    .OUT0C      (S0C),
    .OUT0B      (S0B),
    .OUT0A      (S0A)
);

// ============================================================
// second carry detect
// ============================================================
carry_60 u_sec_carry (
    .IN1D       (S1D),
    .IN1C       (S1C),
    .IN1B       (S1B),
    .IN1A       (S1A),
    .IN0D       (S0D),
    .IN0C       (S0C),
    .IN0B       (S0B),
    .IN0A       (S0A),
    .clk_60     (sec_carry)
);

// ============================================================
// minute counter: MOD_60
// ============================================================
MOD_60 u_min (
    .CLK        (CLK),
    .EN         (set_min ? 1'b0 : sec_carry_gated),
    .IN1D       (set_min ? set_tens[3] : M1D),
    .IN1C       (set_min ? set_tens[2] : M1C),
    .IN1B       (set_min ? set_tens[1] : M1B),
    .IN1A       (set_min ? set_tens[0] : M1A),
    .IN0D       (set_min ? set_ones[3] : M0D),
    .IN0C       (set_min ? set_ones[2] : M0C),
    .IN0B       (set_min ? set_ones[1] : M0B),
    .IN0A       (set_min ? set_ones[0] : M0A),
    .OUT1D      (M1D),
    .OUT1C      (M1C),
    .OUT1B      (M1B),
    .OUT1A      (M1A),
    .OUT0D      (M0D),
    .OUT0C      (M0C),
    .OUT0B      (M0B),
    .OUT0A      (M0A)
);

// ============================================================
// minute carry detect
// ============================================================
carry_60 u_min_carry (
    .IN1D       (M1D),
    .IN1C       (M1C),
    .IN1B       (M1B),
    .IN1A       (M1A),
    .IN0D       (M0D),
    .IN0C       (M0C),
    .IN0B       (M0B),
    .IN0A       (M0A),
    .clk_60     (min_carry)
);

// ============================================================
// hour counter: MOD_24
// ============================================================
MOD_24 u_hour (
    .CLK        (CLK),
    .EN         (set_hour ? 1'b0 : min_carry_gated),
    .IN1D       (set_hour ? set_tens[3] : H1D),
    .IN1C       (set_hour ? set_tens[2] : H1C),
    .IN1B       (set_hour ? set_tens[1] : H1B),
    .IN1A       (set_hour ? set_tens[0] : H1A),
    .IN0D       (set_hour ? set_ones[3] : H0D),
    .IN0C       (set_hour ? set_ones[2] : H0C),
    .IN0B       (set_hour ? set_ones[1] : H0B),
    .IN0A       (set_hour ? set_ones[0] : H0A),
    .OUT1D      (H1D),
    .OUT1C      (H1C),
    .OUT1B      (H1B),
    .OUT1A      (H1A),
    .OUT0D      (H0D),
    .OUT0C      (H0C),
    .OUT0B      (H0B),
    .OUT0A      (H0A)
);

// ============================================================
// BCD to 7-segment for second_low digit
// ============================================================
wire [3:0] seg_in = SW_MODE ? sw_s0 : {S0D, S0C, S0B, S0A};

BCD_7 u_seg (
    .inD        (seg_in[3]),
    .inC        (seg_in[2]),
    .inB        (seg_in[1]),
    .inA        (seg_in[0]),
    .EN         (1'b1),
    .a          (second_low_a),
    .b          (second_low_b),
    .c          (second_low_c),
    .d          (second_low_d),
    .e          (second_low_e),
    .f          (second_low_f),
    .g          (second_low_g)
);

// ============================================================
// alarm storage (minutes)
// ============================================================
alarm_storage u_alm_min (
    .CLK        (CLK_10K),
    .EN_set     (alm_set_min),
    .IN1D       (set_tens[3]),
    .IN1C       (set_tens[2]),
    .IN1B       (set_tens[1]),
    .IN1A       (set_tens[0]),
    .IN0D       (set_ones[3]),
    .IN0C       (set_ones[2]),
    .IN0B       (set_ones[1]),
    .IN0A       (set_ones[0]),
    .OUT1       (alm_min_1),
    .OUT0       (alm_min_0)
);

// ============================================================
// alarm storage (hours)
// ============================================================
alarm_storage u_alm_hour (
    .CLK        (CLK_10K),
    .EN_set     (alm_set_hour),
    .IN1D       (set_tens[3]),
    .IN1C       (set_tens[2]),
    .IN1B       (set_tens[1]),
    .IN1A       (set_tens[0]),
    .IN0D       (set_ones[3]),
    .IN0C       (set_ones[2]),
    .IN0B       (set_ones[1]),
    .IN0A       (set_ones[0]),
    .OUT1       (alm_hour_1),
    .OUT0       (alm_hour_0)
);

// ============================================================
// alarm judge
// ============================================================
alarm_judge u_judge (
    .clk        (CLK),
    .EN1        (1'b1),
    .alarm_sw   (ALARM_SW),
    .MOA        ({M1D, M1C, M1B, M1A}),
    .MOB        ({M0D, M0C, M0B, M0A}),
    .HOA        ({H1D, H1C, H1B, H1A}),
    .HOB        ({H0D, H0C, H0B, H0A}),
    .M1A        (alm_min_1),
    .M1B        (alm_min_0),
    .H1A        (alm_hour_1),
    .H1B        (alm_hour_0),
    .jg_out     (jg_out)
);

// ============================================================
// speaker
// ============================================================
speaker u_spk (
    .clkin      (CLK_10K),
    .clk_high   (spk_high),
    .clk_middle (spk_middle),
    .clk_low    (spk_low)
);

// ============================================================
// depart (alarm output control)
// ============================================================
depart u_depart (
    .jg_in      (jg_out),
    .clk        (CLK),
    .clk_fast   (CLK_10K),
    .clk_high   (spk_high),
    .clk_middle (spk_middle),
    .clk_low    (spk_low),
    .speak_out  (speaker)
);

// ============================================================
// stopwatch (MM:SS)
// ============================================================
wire [3:0] sw_s0, sw_s1, sw_m0, sw_m1;

stopwatch u_sw (
    .CLK        (CLK),
    .SW_MODE    (SW_MODE),
    .SW_RUN     (SW_RUN),
    .s0         (sw_s0),
    .s1         (sw_s1),
    .m0         (sw_m0),
    .m1         (sw_m1)
);

// ============================================================
// 12h/24h display conversion
// ============================================================
wire [3:0] disp_h_ten, disp_h_one;

hour_convert u_hconv (
    .H_ten      ({H1D, H1C, H1B, H1A}),
    .H_one      ({H0D, H0C, H0B, H0A}),
    .mode_12h   (MODE_12_24),
    .D_ten      (disp_h_ten),
    .D_one      (disp_h_one)
);

// ============================================================
// output assignments
// ============================================================
// display source: SW_MODE=0 → clock, SW_MODE=1 → stopwatch
wire [3:0] d_h_ten  = SW_MODE ? 4'd0      : disp_h_ten;
wire [3:0] d_h_one  = SW_MODE ? 4'd0      : disp_h_one;
wire [3:0] d_m_ten  = SW_MODE ? sw_m1     : {M1D, M1C, M1B, M1A};
wire [3:0] d_m_one  = SW_MODE ? sw_m0     : {M0D, M0C, M0B, M0A};
wire [3:0] d_s_high = SW_MODE ? sw_s1     : {S1D, S1C, S1B, S1A};

assign Alarm = jg_out;

assign hour_high_A = d_h_ten[0];
assign hour_high_B = d_h_ten[1];
assign hour_high_C = d_h_ten[2];
assign hour_high_D = d_h_ten[3];

assign hour_low_A = d_h_one[0];
assign hour_low_B = d_h_one[1];
assign hour_low_C = d_h_one[2];
assign hour_low_D = d_h_one[3];

assign minute_high_A = d_m_ten[0];
assign minute_high_B = d_m_ten[1];
assign minute_high_C = d_m_ten[2];
assign minute_high_D = d_m_ten[3];

assign minute_low_A = d_m_one[0];
assign minute_low_B = d_m_one[1];
assign minute_low_C = d_m_one[2];
assign minute_low_D = d_m_one[3];

assign second_high_A = d_s_high[0];
assign second_high_B = d_s_high[1];
assign second_high_C = d_s_high[2];
assign second_high_D = d_s_high[3];

endmodule
