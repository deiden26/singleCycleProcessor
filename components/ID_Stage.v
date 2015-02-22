module ID_Stage(
	input clk,
	input reset,
	input [0:31] instruction,
	input [0:31] BUS_W ,
	input [0:31] FBUS_W,
	output [0:31] OPERAND_A,
	output logic [0:31] OPERAND_B,
	output [0:31] F_OPERAND_A,
	output [0:31] F_OPERAND_B,
	output BRANCH,
	output JUMP,
	output [0:3] ALU_CTRL_BITS,
	output FPU_CTRL_BITS,
	output ALU_SRC,
	output MEM_WR,
	output MEM_TO_REG,
	output MOV_INSTR,
	output MEM_BYTE_OP,
	output MEM_HALFWORD_OP,
	output MEM_SIGN_EXT,
	output JAL_INSTR);

logic temp_REG_DST, temp_R_31, temp_REG_WR, temp_F_REG_WR, temp_IMM_ZERO, temp_ALU_SRC, temp_EXT_OP;

logic [0:31] temp_bus_B, temp_f_bus_B;

logic [0:4] Rs;
logic [0:4] Rt;
logic [0:4] Rd;
logic [0:15]IMM_FIELD;
logic [0:31] IMM_FIELD_EXT;




control_logic control_0(
	.instruction(instruction),
	.REG_DST(temp_REG_DST),
	.REG_WR(temp_REG_WR),
	.F_REG_WR(temp_F_REG_WR),
	.BRANCH(BRANCH),
	.JUMP(JUMP),
	.ALU_CTRL_BITS(ALU_CTRL_BITS),
	.FPU_CTRL_BITS(FPU_CTRL_BITS),
	.ALU_SRC(ALU_SRC),
	.IMM_ZERO(temp_IMM_ZERO),
	.MEM_WR(MEM_WR),
	.MEM_TO_REG(MEM_TO_REG),
	.MOV_INSTR(MOV_INSTR),
	.EXT_OP(temp_EXT_OP),
	.MEM_BYTE_OP(MEM_BYTE_OP),
	.MEM_HALFWORD_OP(MEM_HALFWORD_OP),
	.MEM_SIGN_EXT(MEM_SIGN_EXT),
	.JAL_INSTR(JAL_INSTR) 
	);

gprFile gprFile0(
	.clk(clk),
	.reset(reset),
	.regWr(temp_REG_WR),
	.Rs(Rs),
	.Rt(Rt),
	.Rd(Rd),
	.Rdst(temp_REG_DST),
	.jal_instr(JAL_INSTR),
	.busW(BUS_W),
	.busA(OPERAND_A),
	.busB(temp_bus_B)
	);

fprFile fprFile0(
	.clk(clk),
	.reset(reset),
	.regWr(temp_F_REG_WR),
	.Rs(Rs),
	.Rt(Rt),
	.Rd(Rd),
	.Rdst(temp_REG_DST),
	.busW(FBUS_W),
	.busA(F_OPERAND_A),
	.busB(F_OPERAND_B)
	);

always @(posedge clk) begin
Rs = instruction[6:10];
Rt = instruction[11:15];
Rd = instruction[16:20];

IMM_FIELD = (temp_IMM_ZERO == 1) ? 16'h0 : instruction[16:31];



	IMM_FIELD_EXT = (temp_EXT_OP == 1) ? {{16{IMM_FIELD[15]}}, IMM_FIELD[0:15]} : {16'h0, IMM_FIELD[0:15]};

	OPERAND_B = (ALU_SRC ==1) ? IMM_FIELD_EXT : temp_bus_B;
	end
endmodule
