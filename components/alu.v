module alu
	(input [31:0] busA,
	input [31:0] busB,
	input [3:0] ALUctrl,
	output [31:0] ALUout
	);

	wire sllOut, srlOut, sraOut;
	wire addOut, subOut;
	wire orOut, andOut, xorOut;
	wire seqOut, sneOut, sltOut, sgtOut, sleOut, sgeOut;
	wire lhiOut;

	assign sllOut = busA << busB;
	assign srlOut = busA >> busB;
	assign sraOut = bus A >>> busB;

	assign addOut = busA + busB;
	assign subOut = busA - busB;

	assign andOut = busA & busB;
	assign orOut = busA | busB;
	assign xorOut = busA ^ busB;

	assign lhiOut = busB;

	if (busA==busB) begin
		assign seqOut = 1;
		assign sneOut = 0;

	end
	else begin
		assign seqOut = 0;
		assign sneOut = 1;
	end

	if (busA<=busB) begin
		assign sleOut = 1;
		assign sgtOut = 0;
	end
	else begin
		assign sleOut = 0;
		assign sgtOut = 1;
	end

	if (busA>=busB) begin
		assign sgeOut = 1;
		assign sltOut = 0;
	end
	else begin
		assign sgeOut = 0;
		assign sltOut = 1;
	end

	begin
		case (ALUctrl)
			0: assign ALUout = sllOut;
			1: assign ALUout = srlOut;
			2: assign ALUout = sraOut;
			3: assign ALUout = addOut;
			4: assign ALUout = subOut;
			5: assign ALUout = orOut;
			6: assign ALUout = andOut;
			7: assign ALUout = xorOut;
			8: assign ALUout = seqOut;
			9: assign ALUout = sneOut;
			10: assign ALUout = sltOut;
			11: assign ALUout = sgtOut;
			12: assign ALUout = sleOut;
			13: assign ALUout = sgeOut;
			14: assign ALUout = lhiOut;
		endcase
	end

endmodule