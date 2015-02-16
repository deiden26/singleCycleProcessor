module gprFile
	(input clk,
	 input reset,
	 input regWr,
	 input [4:0] Rs,
	 input [4:0] Rt,
	 input [4:0] Rd,
	 input Rdst,
	 input jal_instr,
	 input [31:0] busW,
	 output logic [31:0] busA,
	 output logic [31:0] busB
	 );

	 reg [31:0] regFile[31:0];

	 reg [4:0] Rw;
	 reg [4:0] Rd_or_Rt;


	 integer i;

	 always @(posedge clk) begin
	 	if(reset) begin
		 	for (i = 0; i < 32; i = i+1) begin
	 			regFile[i] = 0;
 			end
		end 

		else begin
			 case(Rdst)
			 	0: Rd_or_Rt = Rt;
				1: Rd_or_Rt = Rd;
			 endcase

			 case(jal_instr)
		 	 	0: Rw = Rd_or_Rt;
				1: Rw = 5'b11111;
			 endcase

			if(regWr)
				regFile[Rw] =busW;
			else
				regFile[Rw] <=regFile[Rw];

			regFile[0] <= 0;
		end

		busA<=regFile[Rs];
		busB<=regFile[Rt];
	end
endmodule