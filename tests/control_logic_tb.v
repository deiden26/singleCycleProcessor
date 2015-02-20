module control_logic_tb;
	reg [0:31] instruction;
	wire REG_DST;
	wire REG_WR;
	wire F_REG_WR;
	wire BRANCH;
	wire JUMP;
	wire [0:3] ALU_CTRL_BITS;
	wire FPU_CTRL_BITS;
	wire ALU_SRC;
	wire IMM_ZERO;
	wire MEM_WR;
	wire MEM_TO_REG;
	wire MOV_INSTR;
	wire EXT_OP;
	wire MEM_BYTE_OP;
	wire MEM_HALFWORD_OP;
	wire MEM_SIGN_EXT;
	wire JAL_INSTR;

	control_logic control0 (
	.instruction(instruction),
	.REG_DST(REG_DST),
	.REG_WR(REG_WR),
	.F_REG_WR(F_REG_WR),
	.BRANCH(BRANCH),
	.JUMP(JUMP),
	.ALU_CTRL_BITS(ALU_CTRL_BITS),
	.FPU_CTRL_BITS(FPU_CTRL_BITS),
	.ALU_SRC(ALU_SRC),
	.IMM_ZERO(IMM_ZERO),
	.MEM_WR(MEM_WR),
	.MEM_TO_REG(MEM_TO_REG),
	.MOV_INSTR(MOV_INSTR),
	.EXT_OP(EXT_OP),
	.MEM_BYTE_OP(MEM_BYTE_OP),
	.MEM_HALFWORD_OP(MEM_HALFWORD_OP),
	.MEM_SIGN_EXT(MEM_SIGN_EXT),
	.JAL_INSTR(JAL_INSTR)
	);


initial
	begin

	$monitor("instruction: %h\t REG_DST = %d\t REG_WR = %d\t F_REG_WR = %d\t BRANCH = %d\t JUMP = %d\t ALU_CTRL_BITS = %b\t FPU_CTRL_BITS = %d\t ALU_SRC = %d\t IMM_ZERO = %d\t MEM_WR = %d\t MEM_TO_REG = %d\t MOV_INSTR = %d\t EXT_OP = %d\t MEM_BYTE_OP = %d\t MEM_HALFWORD_OP = %d\t MEM_SIGN_EXT = %d\t JAL_INSTR = %d\n\n", instruction, REG_DST, REG_WR, F_REG_WR, BRANCH, JUMP, ALU_CTRL_BITS,FPU_CTRL_BITS,ALU_SRC,IMM_ZERO,MEM_WR,MEM_TO_REG, MOV_INSTR, EXT_OP, MEM_BYTE_OP, MEM_HALFWORD_OP, MEM_SIGN_EXT, JAL_INSTR);


	#0 instruction =32'h00221820;

	#10 instruction = 32'h20230008;

	#20 instruction = 32'h0c00000c;

	#30 instruction = 32'h10800000;
end

initial
	#60 $finish;

endmodule	