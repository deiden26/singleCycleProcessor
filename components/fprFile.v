module fprFile
	(input clk,
	 input reset,
	 input regWr,
	 input [4:0] Rs,
	 input [4:0] Rt,
	 input [4:0] Rd,
	 input Rdst,
	 input [31:0] busW,
	 output [31:0] busA,
	 output [31:0] busB
	 );

	 reg [31:0] regFile[31:0];

	 reg [4:0] Rw;
	 reg [4:0] Rd_or_Rt;


	 assign busA = regFile[Rs];
	 assign busB = regFile[Rt];

	 integer i;

	 always @(posedge clk) begin
	 	if(reset) begin
		 	for (i = 0; i < 32; i = i+1) begin
	 			regFile[i] <= 0;
 			end
		end 

		else begin
			 case(Rdst)
		 	 	0: assign Rw = Rt;
				1: assign Rw = Rd;
			 endcase
			 
			if(regWr)
				regFile[Rw] <=busW;
		end
	end
endmodule