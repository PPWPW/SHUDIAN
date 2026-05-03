module DigitalClock (
    input           CLK_1HZ,
    input           CLK_SCAN,
    input           CLK_SPK,
    input           nRST,
    input           ADJ_MIN,
    input           ADJ_HOUR,
    input           ALM_EN,
    input           ALM_SET_MIN,
    input           ALM_SET_HOUR,
    input   [3:0]   ALM_SW1,
    input   [3:0]   ALM_SW0,
    output  [6:0]   SEG,
    output  [5:0]   DIG,
    output          BUZZER
);

// ============================================================
// wires: second counter
// ============================================================
wire    S1D, S1C, S1B, S1A;
wire    S0D, S0C, S0B, S0A;
wire    sec_carry;

// ============================================================
// wires: minute counter
// ============================================================
wire    M1D, M1C, M1B, M1A;
wire    M0D, M0C, M0B, M0A;
wire    min_carry;

// ============================================================
// wires: hour counter
// ============================================================
wire    H1D, H1C, H1B, H1A;
wire    H0D, H0C, H0B, H0A;

// ============================================================
// wires: alarm storage
// ============================================================
wire [3:0] alm_min_1, alm_min_0;
wire [3:0] alm_hour_1, alm_hour_0;

// ============================================================
// wires: alarm / speaker
// ============================================================
wire jg_out;
wire spk_high, spk_middle, spk_low;

// ============================================================
// display scanning
// ============================================================
reg  [2:0] scan_cnt;
reg  [3:0] bcd_mux;
wire dec_outD, dec_outC, dec_outB, dec_outA;

always @(posedge CLK_SCAN or negedge nRST) begin
    if (!nRST)
        scan_cnt <= 3'd0;
    else if (scan_cnt == 3'd5)
        scan_cnt <= 3'd0;
    else
        scan_cnt <= scan_cnt + 1'b1;
end

always @(*) begin
    case (scan_cnt)
        3'd0: bcd_mux = {H1D, H1C, H1B, H1A};
        3'd1: bcd_mux = {H0D, H0C, H0B, H0A};
        3'd2: bcd_mux = {M1D, M1C, M1B, M1A};
        3'd3: bcd_mux = {M0D, M0C, M0B, M0A};
        3'd4: bcd_mux = {S1D, S1C, S1B, S1A};
        3'd5: bcd_mux = {S0D, S0C, S0B, S0A};
        default: bcd_mux = 4'd0;
    endcase
end

// ============================================================
// reset / time-adjust control
// ============================================================
reg reset_active;
reg adj_min_d1, adj_min_d2;
reg adj_hour_d1, adj_hour_d2;

always @(posedge CLK_1HZ or negedge nRST) begin
    if (!nRST)
        reset_active <= 1'b1;
    else
        reset_active <= 1'b0;
end

always @(posedge CLK_1HZ) begin
    {adj_min_d2, adj_min_d1}   <= {adj_min_d1, ADJ_MIN};
    {adj_hour_d2, adj_hour_d1} <= {adj_hour_d1, ADJ_HOUR};
end

wire adj_min_pulse  = adj_min_d1 && ~adj_min_d2;
wire adj_hour_pulse = adj_hour_d1 && ~adj_hour_d2;

wire sec_en  = ~reset_active;
wire min_en  = ~reset_active ? (sec_carry  | adj_min_pulse)  : 1'b0;
wire hour_en = ~reset_active ? (min_carry  | adj_hour_pulse) : 1'b0;

// ============================================================
// second counter: MOD_60
// ============================================================
MOD_60 u_sec (
    .CLK        (CLK_1HZ),
    .EN         (sec_en),
    .IN1D       (1'b0),
    .IN1C       (1'b0),
    .IN1B       (1'b0),
    .IN1A       (1'b0),
    .IN0D       (1'b0),
    .IN0C       (1'b0),
    .IN0B       (1'b0),
    .IN0A       (1'b0),
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
    .CLK        (CLK_1HZ),
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
    .CLK        (CLK_1HZ),
    .EN         (min_en),
    .IN1D       (M1D),
    .IN1C       (M1C),
    .IN1B       (M1B),
    .IN1A       (M1A),
    .IN0D       (M0D),
    .IN0C       (M0C),
    .IN0B       (M0B),
    .IN0A       (M0A),
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
    .CLK        (CLK_1HZ),
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
    .CLK        (CLK_1HZ),
    .EN         (hour_en),
    .IN1D       (H1D),
    .IN1C       (H1C),
    .IN1B       (H1B),
    .IN1A       (H1A),
    .IN0D       (H0D),
    .IN0C       (H0C),
    .IN0B       (H0B),
    .IN0A       (H0A),
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
// BCD to 7-segment
// ============================================================
BCD_7 u_seg (
    .inD        (bcd_mux[3]),
    .inC        (bcd_mux[2]),
    .inB        (bcd_mux[1]),
    .inA        (bcd_mux[0]),
    .EN         (1'b1),
    .a          (SEG[0]),
    .b          (SEG[1]),
    .c          (SEG[2]),
    .d          (SEG[3]),
    .e          (SEG[4]),
    .f          (SEG[5]),
    .g          (SEG[6])
);

// ============================================================
// digit select: Decoder_2to4 + extra logic for 6 digits
// ============================================================
Decoder_2to4 u_dig_dec (
    .inB        (scan_cnt[1]),
    .inA        (scan_cnt[0]),
    .EN         (~scan_cnt[2]),
    .outD       (dec_outD),
    .outC       (dec_outC),
    .outB       (dec_outB),
    .outA       (dec_outA)
);

assign DIG[3] = dec_outD;
assign DIG[2] = dec_outC;
assign DIG[1] = dec_outB;
assign DIG[0] = dec_outA;
assign DIG[4] = (scan_cnt == 3'd4) ? 1'b0 : 1'b1;
assign DIG[5] = (scan_cnt == 3'd5) ? 1'b0 : 1'b1;

// ============================================================
// alarm control: EN=0/EN1=1 for store, EN=1/EN1=0 for output
// ============================================================
wire alm_set_mode = ALM_SET_MIN | ALM_SET_HOUR;
wire alm_en       = ~alm_set_mode;
wire alm_en1      =  alm_set_mode;

// ============================================================
// alarm storage (minutes)
// ============================================================
alarm_storage u_alm_min (
    .CLK        (ALM_SET_MIN),
    .CLK1       (CLK_1HZ),
    .EN         (alm_en),
    .EN1        (alm_en1),
    .IN1D       (ALM_SW1[3]),
    .IN1C       (ALM_SW1[2]),
    .IN1B       (ALM_SW1[1]),
    .IN1A       (ALM_SW1[0]),
    .IN0D       (ALM_SW0[3]),
    .IN0C       (ALM_SW0[2]),
    .IN0B       (ALM_SW0[1]),
    .IN0A       (ALM_SW0[0]),
    .OUT1       (alm_min_1),
    .OUT0       (alm_min_0)
);

// ============================================================
// alarm storage (hours)
// ============================================================
alarm_storage u_alm_hour (
    .CLK        (ALM_SET_HOUR),
    .CLK1       (CLK_1HZ),
    .EN         (alm_en),
    .EN1        (alm_en1),
    .IN1D       (ALM_SW1[3]),
    .IN1C       (ALM_SW1[2]),
    .IN1B       (ALM_SW1[1]),
    .IN1A       (ALM_SW1[0]),
    .IN0D       (ALM_SW0[3]),
    .IN0C       (ALM_SW0[2]),
    .IN0B       (ALM_SW0[1]),
    .IN0A       (ALM_SW0[0]),
    .OUT1       (alm_hour_1),
    .OUT0       (alm_hour_0)
);

// ============================================================
// alarm judge
// ============================================================
alarm_judge u_judge (
    .clk        (CLK_1HZ),
    .EN1        (ALM_EN),
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
    .clkin      (CLK_SPK),
    .clk_high   (spk_high),
    .clk_middle (spk_middle),
    .clk_low    (spk_low)
);

// ============================================================
// depart (alarm output control)
// ============================================================
depart u_depart (
    .jg_in      (jg_out),
    .clk        (CLK_SPK),
    .clk_high   (spk_high),
    .clk_middle (spk_middle),
    .clk_low    (spk_low),
    .speak_out  (BUZZER)
);

endmodule
