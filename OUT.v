module	OUT(
		input	wire	[7:0]	DATA,
		input	wire	CLK_48MHZ,RSTN,
		output	reg	DONE,
		output	reg	OUT_F
		);
reg	[4:0]	cnt;
reg	[7:0]	buff;
always@(posedge	CLK_48MHZ)
	begin
	if(RSTN)
		begin
		cnt=0;
		DONE=1;
		OUT_F=0;
		buff=0;
		end
	else
		begin
		buff=DATA;
		OUT_F=buff[7-cnt];
		cnt=cnt+1;
		DONE=0;
		if(cnt==8)
			begin
			cnt=0;
			DONE=1;
			end
		end
	end
endmodule
