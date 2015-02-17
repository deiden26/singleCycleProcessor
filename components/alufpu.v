module alufpu(busA, busB, ALUctrl, fbusA, fbusB, FPUctrl, ALUout, FPUout, busAout, fbusAout);
	input [31:0] busA, busB, fbusA, fbusB;
	input [3:0] ALUctrl;
	input FPUctrl;

	output [31:0] ALUout, FPUout, busAout, fbusAout;
	reg [31:0] multOut, multuOut, FPUout, ALUout, busAout, fbusAout;
	reg [31:0]  sllOut, srlOut, sraOut;
	reg [31:0]  addOut, subOut;
	reg [31:0]  orOut, andOut, xorOut;
	reg [31:0]  seqOut, sneOut, sltOut, sgtOut, sleOut, sgeOut;
	reg [31:0]  lhiOut;

	always@(1)
	begin

	//busA assignments
	busAout <= busA;
	fbusAout <= fbusA;
	
	//ALU output
	sllOut <= busA << busB;
	srlOut <= busA >> busB;
	sraOut <= busA >>> busB;
	addOut <= busA + busB;
	subOut <= busA - busB;
	andOut <= busA & busB;
	orOut <= busA | busB;
	xorOut <= busA ^ busB;
	lhiOut <= busB;

	if (busA==busB) begin
	seqOut <= 1;
	sneOut <= 0;
	end
	
	else begin
	seqOut <= 0;
	sneOut <= 1;
	end

	if (busA<=busB) begin
	sleOut <= 1;
	sgtOut <= 0;
	end

	else begin
	sleOut <= 0;
	sgtOut <= 1;
	end

	if (busA>=busB) begin
	sgeOut <= 1;
	sltOut <= 0;
	end

	else begin
	sgeOut <= 0;
	sltOut <= 1;
	end

	case (ALUctrl)
	0: ALUout <= sllOut;
	1: ALUout <= srlOut;
	2: ALUout <= sraOut;
	3: ALUout <= addOut;
	4: ALUout <= subOut;
	5: ALUout <= orOut;
	6: ALUout <= andOut;
	7: ALUout <= xorOut;
	8: ALUout <= seqOut;
	9: ALUout <= sneOut;
	10: ALUout <= sltOut;
	11: ALUout <= sgtOut;
	12: ALUout <= sleOut;
	13: ALUout <= sgeOut;
	14: ALUout <= lhiOut;
	endcase
	end

	//FPU output
	always@(1)
        begin
        multOut <= busA * busB;
        if (multOut<0)
                multuOut <= 0 - multOut;
        else
                multuOut <= multOut;

        if (FPUctrl == 0)
                FPUout <= multOut;
        else
                FPUout <= multuOut;
        end
endmodule
