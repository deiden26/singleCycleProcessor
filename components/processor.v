module processor(
	//Global signals
	 input clock,
	 input reset,
	//DMEM signals
	 output addr_to_mem,
	 output write_enable_to_mem,
	 output byte_to_mem,
	 output half_word_to_mem,
	 output sign_extend_to_mem,
	 output data_to_mem,
	 input data_from_mem,
	//IMEM signals
	 output iaddr,
	 input instr
);

	wire gp_branch, fp_branch, jump, jump_use_reg, branch, fpu_ctrl_bits, write_enable, mem_to_reg, mov_instr, mem_byte, mem_half_word, mem_sign_extend, jal_instr,
	wire [0:31] pc_from_reg, inst_from_mem, pc_to_mem, pc_plus_8, instr, bus_w, fbus_w, operand_a, operand_b, f_operand_a, f_operand_b, alu_out, fpu_out,
	wire [0:3] alu_ctrl_bits

	ifu IFU(
		.clock (clock),                  // system clock
		.reset (reset),                  // system reset
		.branch (branch),
		.gp_branch (gp_branch),              // taken-branch signal for alu
		.fp_branch (fp_branch),              // taken-branch signal for fpu 
		.jump (jump),                   // jump signal
		.use_reg (jump_use_reg),                // if JR or JALR
		.pc_from_reg (pc_from_reg),            // use if use_reg is TRUE
		.inst_from_mem (inst_from_mem),          // Data coming back from instruction-memory

		.pc_to_mem (pc_to_mem),              // Address sent to Instruction memory
		.pc_8_out (pc_plus_8),               // PC of to store in reg31 for JAL & JALR (PC+8)
		.inst_out (instr)               // fetched instruction out
	);

	ID_Stage ID(
		.clk(clock),
		.reset(reset),
		.instruction(instr),
		.BUS_W(bus_w),
		.FBUS_W(fbus_w),
		.OPERAND_A(operand_a),
		.OPERAND_B(operand_b),
		.F_OPERAND_A(f_operand_a),
		.F_OPERAND_B(f_operand_b),
		.BRANCH(branch),
		.JUMP(jump),
		.ALU_CTRL_BITS(alu_ctrl_bits),
		.FPU_CTRL_BITS(fpu_ctrl_bits),
		.MEM_WR(write_enable),
		.MEM_TO_REG(mem_to_reg),
		.MOV_INSTR(mov_instr),
		.MEM_BYTE_OP(mem_byte),
		.MEM_HALFWORD_OP(mem_half_word),
		.MEM_SIGN_EXT(mem_sign_extend),
		.JAL_INSTR(jal_instr)
		.JUMP_USE_REG(jump_use_reg),
	);
	
	alufpu ALUFPU(
		.busA(operand_a),
		.busB(operand_b),
		.ALUctrl(alu_ctrl_bits),
		.fbusA(f_operand_a),
		.fbusB(f_operand_b),
		.FPUctrl(fpu_ctrl_bits),
		.ALUout(alu_out),
		.FPUout(fpu_out),
	);

	mem_stage MEM(
		.store_fp(1'b0),
		//Connections to processor
		.addr_from_proc(alu_out),
		.gp_data_from_proc(operand_b),
		.fp_data_from_proc(f_operand_b),
		.write_enable_from_proc(write_enable),
		.byte_from_proc(mem_byte),
		.half_word_from_proc(mem_half_word),
		.sign_extend_from_proc(mem_sign_extend),
		.data_to_proc(mem_data),

		//Connections to memory
		.addr_to_mem(addr_to_mem),
		.data_to_mem(data_to_mem),
		.write_enable_to_mem(write_enable_to_mem),
		.byte_to_mem(byte_to_mem),
		.half_word_to_mem(half_word_to_mem),
		.sign_extend_to_mem(sign_extend_to_mem),
		.data_from_mem(data_from_mem)
	);

	wb WB(
		.ALUout(alu_out),
		.FPUout(fpu_out),
		.busA(operand_a),
		.fbusA(f_operand_a),
		.MEMout(mem_data),
		.busW(bus_w),
		.fbusW(fbus_w),
		.busWctrl(jal_instr),
		.memToReg(mem_to_reg),
		.movInstr(mov_instr),
		.jalOut(pc_plus_8)
	):
	
endmodule
