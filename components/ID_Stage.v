module ID_Stage(
	input clk,
	input reset,
	input instruction[0:31],
	input BUS_W [31:0],
	input FBUS_W [31:0],
	output OPERAND_A [31:0],
	output OPERAND_B [31:0],
	output F_OPERAND_A [31:0],
	output F_OPERAND_B [31:0],
	output BRANCH,
	output JUMP,
	output ALU_CTRL_BITS[3:0],
	output FPU_CTRL_BITS,
	output ALU_SRC,
	output MEM_WR,
	output MEM_TO_REG,
	output MOV_INSTR,
	output MEM_BYTE_OP,
	output MEM_HALFWORD_OP,
	output MEM_SIGN_EXT
	output JAL_INSTR);

logic temp_REG_DST, temp_R_31, temp_REG_WR, temp_F_REG_WR, temp_IMM_ZERO, temp_ALU_SRC, temp_EXT_OP;

logic [31:0] temp_bus_B, temp_f_bus_B;


logic [4:0] Rs = instruction[6:10];
logic [4:0] Rt = instruction[11:15];
logic [4:0] Rd = instruction[16:20];


control_logic control_0 (
	.instruction(instruction),
	.REG_DST(temp_REG_DST),
	.REG_WR(temp_REG_WR),
	.F_REG_WR(temp_F_REG_WR),
	.BRANCH(BRANCH),
	.JUMP(JUMP),
	.ALU_CTRL_BITS(ALU_CTRL_BITS),
	.FPU_CTRL_BITS(FPU_CTRL_BITS),
	.ALU_SRC(temp_ALU_SRC),
	.IMM_ZERO(temp_IMM_ZERO),
	.MEM_WR(MEM_WR),
	.MEM_TO_REG(MEM_TO_REG),
	.MOV_INSTR(MOV_INSTR),
	.EXT_OP(temp_EXT_OP),
	.MEM_BYTE_OP(MEM_BYTE_OP),
	.MEM_HALFWORD_OP(MEM_HALFWORD_OP),
	.MEM_SIGN_EXT(MEM_SIGN_EXT),
	.JAL_INSTR(JAL_INSTR) );

gprFile gprFile0 (
	.clk(clk),
	.reset(reset),
	.regWr(temp_REG_WR),
	.Rs(Rs),
	.Rt(Rt),
	.Rd(Rd),
	.Rdst(temp_REG_DST),
	.jal_instr(JAL_INSTR),
	.busW(BUS_W)
	.busA(OPERAND_A),
	.busB(temp_bus_B)
	);

fprFile fprFile0 (
	.clk(clk),
	.reset(reset),
	.regWr(temp_F_REG_WR),
	.Rs(Rs),
	.Rt(Rt),
	.Rd(Rd),
	.Rdst(temp_REG_DST),
	.busW(F_BUS_W)
	.busA(F_OPERAND_A),
	.busB(F_OPERAND_B)
	);


logic [15:0]IMM_FIELD = (temp_IMM_ZERO == 1) ? 16'h0 : instruction[16:31];

logic [31:0] IMM_FIELD_EXT;

	IMM_FIELD_EXT = (temp_EXT_OP == 1) ? {{16{IMM_FIELD[15]}}, IMM_FIELD[15:0]} : {16'h0, IMM_FIELD[15:0]};

	OPERAND_B = (temp_ALU_SRC ==1) ? IMM_FIELD_EXT : temp_busB;

endmodule
