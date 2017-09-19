module	READ(
		input	wire	RSTN,
		input	wire	DIN,
		input	wire	CLK_30MHZ,
		output	reg	[7:0]	DATA,
		output	reg	[9:0]	ADDR
		);
reg	[9:0]	buff;
reg	[4:0]	cnt;
reg	bn;
always@(negedge	CLK_30MHZ)
	if(RSTN)
		begin
		cnt=0;
		buff=0;
		bn=0;
		ADDR=721;
		end
	else
		begin
		if(bn)
			begin
			if((cnt>7)&&(buff[1:0]==2'b01))
				begin
				DATA<=buff[9:2];
				ADDR=ADDR+1;
				cnt=0;
				if(ADDR==721)
					begin
					ADDR=0;
					bn=0;
					end
				end
			else
				begin
				cnt=cnt+1;
				end
			end
		else
			begin
			if(buff==10'h3ff)
				begin
				bn=1;
				ADDR=0;
				end
			end
		buff=buff<<1;
		buff[0]=DIN;
		end
endmodule
