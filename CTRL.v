module	CTRL(
		input	wire	RSTN,
		input	wire	CLK_30MHZ,CLK_48MHZ,
		input	wire	[1:0]	MODE,
		input	wire	[9:0]	i_ADDR,
		input	wire	[7:0]	i_DATA,
		input	wire	DONE_A,DONE_B,DONE_C,
		output	reg	[7:0]	o_DATA_A,o_DATA_B,o_DATA_C,
		output	reg	CLK_OUT,
		output	reg	VALID
		);
wire	DONE;
wire	[9:0]	addr;
reg	[1:0]	mode,mode_reg;
reg	[7:0]	mem1k0	[719:0];
reg	dir_in,dir_out,tmp4,tmp6,tmp7;
reg	tmp2;
reg	[1:0]	tmp3;
assign	DONE=DONE_A&&DONE_B&&DONE_C;
reg	[9:0]	cnt1,cnt3,cnt5,cnt8,tmp5;		//cnt1	0,2,..718
//initial	begin CLK_OUT=0;tmp3=2'b00;tmp2=0;tmp9=0; end
assign	addr=i_ADDR-1;
always@(negedge	CLK_30MHZ)			//cnt2	cnt1+1
	begin					//cnt3	718,716,..0
	if(RSTN)
		begin
		dir_in=1;
		tmp7=0;
		end
	if(tmp5==718)	tmp7=1;
	if((tmp5==719)&&(addr==1023))
		begin
		tmp7=0;
		dir_in=tmp6;
		mode=mode_reg;
		end
	if(addr==0)
		begin
		mode_reg=MODE;
		end
	if((addr<719)&&(dir_out==0))
		begin
		mem1k0[719-addr]=i_DATA;
		tmp6=0;
		end
	if((addr<719)&&(dir_out==1))
		begin
		mem1k0[addr]=i_DATA;
		tmp6=1;
		end
	tmp5=addr;
	end
/*always@(CLK_48MHZ)
	begin
	tmp3=tmp3+1;
	if(mode>1)
		begin
		if(tmp3==2'b11)	begin CLK_OUT=~CLK_OUT;tmp3=0; end
		end
	else
		begin
		if(tmp2==1)	begin CLK_OUT=~CLK_OUT; end
		end
	tmp2=tmp2+1;
	end
*/
reg	tmp9;
always@(CLK_48MHZ)
	begin
	tmp3=tmp3+1;
	if(mode>1)
		begin
		if(tmp3==2'b11)	begin tmp9=~tmp9;tmp3=0; end
		end
	else
		begin
		if(tmp2==1)	begin tmp9=~tmp9; end
		end
	tmp2=tmp2+1;
	end
always@(posedge	tmp9)
	begin
	CLK_OUT=~CLK_OUT;
	end

always@(posedge	CLK_OUT or posedge tmp7)
	if(tmp7)				//cnt4	cnt3+1
		begin				//cnt5	0,3,..717
		o_DATA_A=0;			//cnt6	cnt5+1
		o_DATA_B=0;			//cnt7	cnt5+2
		o_DATA_C=0;			//cnt8	717,714,..0
		cnt1=0;				//cnt9	cnt8+1
		cnt3=718;			//cnt10	cnt8+2
		cnt5=0;
		cnt8=717;
		VALID=1;
		dir_in=1;
		dir_out=1;
		end
	else
		begin
		if(VALID)
			begin
			if(DONE)
				begin
				if(mode==2'b00)
					begin
					if(cnt1>718)
						begin
						cnt1=0;
						VALID=0;
						end
					if(dir_in)
						begin
						o_DATA_A=mem1k0[cnt1];
						o_DATA_B=mem1k0[cnt1+1];
						o_DATA_C=0;
						dir_out=1;
						end
					else
						begin
						o_DATA_A=mem1k0[719-cnt1];
						o_DATA_B=mem1k0[719-cnt1-1];
						o_DATA_C=0;
						dir_out=0;
						end
					cnt1=cnt1+2;
					end
				if(mode==2'b01)
					begin
					if(cnt3==0)
						begin
						cnt3=718;
						VALID=0;
						end
					if(dir_in)
						begin
						o_DATA_A=mem1k0[cnt3];
						o_DATA_B=mem1k0[cnt3+1];
						o_DATA_C=0;
						dir_out=0;
						end
					else
						begin
						o_DATA_A=mem1k0[719-cnt3];
						o_DATA_B=mem1k0[719-cnt3-1];
						o_DATA_C=0;
						dir_out=1;
						end
					cnt3=cnt3-2;
					end
				if(mode==2'b10)
					begin
					if(cnt5>717)
						begin
						cnt5=0;
						VALID=0;
						end
					if(dir_in)
						begin
						o_DATA_A=mem1k0[cnt5];
						o_DATA_B=mem1k0[cnt5+1];
						o_DATA_C=mem1k0[cnt5+2];
						dir_out=1;
						end
					else 
						begin
						o_DATA_A=mem1k0[719-cnt5];
						o_DATA_B=mem1k0[719-cnt5-1];
						o_DATA_C=mem1k0[719-cnt5-2];
						dir_out=0;
						end
					cnt5=cnt5+3;
					end
				if(mode==2'b11)
					begin
					if(cnt8==0)	
						begin
						cnt8=717;
						VALID=0;
						end
					if(dir_in) 
						begin
						o_DATA_A=mem1k0[cnt8];
						o_DATA_B=mem1k0[cnt8+1];
						o_DATA_C=mem1k0[cnt8+2];
						dir_out=0;
						end
					else 
						begin
						o_DATA_A=mem1k0[719-cnt8];
						o_DATA_B=mem1k0[719-cnt8-1];
						o_DATA_C=mem1k0[719-cnt8-2];
						dir_out=1;
						end
					cnt8=cnt8-3;
					end
				end
			end
		else
			begin
			o_DATA_A=0;
			o_DATA_B=0;
			o_DATA_C=0;
			end
		end
endmodule
