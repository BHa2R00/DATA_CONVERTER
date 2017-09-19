`timescale	1ns/1ns
module	tb;
reg	CLK_30MHZ,CLK_48MHZ,RSTN;
wire	DIN,VALID,DOUT_A,DOUT_B,DOUT_C;
reg	[1:0]	MODE;
reg [7:0] NUM_Z;
reg  NUM;
reg [5:0] COUNTER;                                   
reg [2:0] SCALER;
DATA_CONVERT	u1(
		.RSTN(RSTN),                                      //?????1???0?????
		.DIN(DIN),                                        //????
		.CLK_30MHZ(CLK_30MHZ),
		.CLK_48MHZ(CLK_48MHZ),
		.MODE(MODE),                                         //????
		.CLK_OUT(CLK_OUT),
		.VALID(VALID),
		.DOUT_A(DOUT_A),
		.DOUT_B(DOUT_B),
		.DOUT_C(DOUT_C)
		);
initial	begin	CLK_30MHZ=0;CLK_48MHZ=0;RSTN=0;	end
initial	begin	#200	RSTN=1;	end
always	begin #17	CLK_30MHZ=~CLK_30MHZ; end                     //????17ns???
always	begin #10	CLK_48MHZ=~CLK_48MHZ;end                       //10ns???
initial	begin	#4000000	RSTN=0;	end 
initial	begin #150 MODE=2'b00;	end
always	begin	#245000 MODE=MODE+1; end                        //34*7200=244800
initial begin NUM_Z=0;COUNTER=0;SCALER=0;end 
always@(posedge CLK_30MHZ)
begin
if(SCALER==0)                                                     //??????????????
  begin                                                              //???????
  COUNTER=COUNTER+1;                                                //?????
  if(COUNTER<30)begin NUM={$random}%1; end                           //?50*17?????????????
   if(COUNTER>=30 && COUNTER<40) begin NUM=0;end
   if(COUNTER>=40 && COUNTER<49) begin NUM=1;end
    if(COUNTER==49) begin SCALER=1; COUNTER=9;NUM=1;end
  end 
else
  begin
 if(COUNTER>1)
	  begin
	NUM=NUM_Z[COUNTER-2];
	   end
 if(COUNTER==0)
    begin
	COUNTER=10;                                                        //????????9?
	NUM_Z=NUM_Z+1;                                                     //0?239 
	NUM=1;
	 if(NUM_Z==240) 
	      begin 
	     NUM_Z=0;SCALER=SCALER+1;
	     if(SCALER==4)
            begin 
			SCALER=0; 
		        end 
		    end 
	   end 
	if(COUNTER==1)
	   begin
	 NUM=0;
	   end
   COUNTER=COUNTER-1;  
 end   
end 
assign DIN =NUM;

initial	begin	#4000000	$finish;	end
initial
	begin
	$dumpfile("out1.vcd");
	$dumpvars(0,tb);
	end
endmodule
