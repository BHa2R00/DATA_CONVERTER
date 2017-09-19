module	DATA_CONVERT(
		input	wire	RSTN,
		input	wire	DIN,
		input	wire	CLK_30MHZ,
		input	wire	CLK_48MHZ,
		input	wire	[1:0]	MODE,
		output	wire	CLK_OUT,
		output	wire	VALID,
		output	wire	DOUT_A,
		output	wire	DOUT_B,
		output	wire	DOUT_C
		);
wire	[7:0]	i_DATA,o_DATA_A,o_DATA_B,o_DATA_C;
wire	[9:0]	i_ADDR;
wire	tx_done_a,tx_done_b,tx_done_c;
READ	i1(
		.RSTN(~RSTN),
		.DIN(DIN),
		.CLK_30MHZ(CLK_30MHZ),
		.DATA(i_DATA),
		.ADDR(i_ADDR)
		);
OUT	oa(
		.DATA(o_DATA_A),
		.CLK_48MHZ(CLK_OUT),
		.RSTN(~RSTN),
		.DONE(tx_done_a),
		.OUT_F(DOUT_A)
		);
OUT	ob(
		.DATA(o_DATA_B),
		.CLK_48MHZ(CLK_OUT),
		.RSTN(~RSTN),
		.DONE(tx_done_b),
		.OUT_F(DOUT_B)
	  	);
OUT	oc(
		.DATA(o_DATA_C),
		.CLK_48MHZ(CLK_OUT),
		.RSTN(~RSTN),
		.DONE(tx_done_c),
		.OUT_F(DOUT_C)
	  	);
CTRL	c1(
		.RSTN(~RSTN),
		.CLK_30MHZ(CLK_30MHZ),
		.CLK_48MHZ(CLK_48MHZ),
		.MODE(MODE),
		.i_ADDR(i_ADDR),
		.i_DATA(i_DATA),
		.DONE_A(tx_done_a),
		.DONE_B(tx_done_b),
		.DONE_C(tx_done_c),
		.o_DATA_A(o_DATA_A),
		.o_DATA_B(o_DATA_B),
		.o_DATA_C(o_DATA_C),
		.CLK_OUT(CLK_OUT),
		.VALID(VALID)
		);
endmodule
