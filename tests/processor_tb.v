module processor_tb();
	parameter IMEMFILE = "../tests/instr.hex";
    parameter DMEMFILE = "../tests/data.hex";
    reg [8*80-1:0] filename;
    reg reset, clock; 
    wire [0:31] addr, iaddr, data_from_mem, data_from_reg, instr;
	wire write_enable, byte, half_word, sign_extend;

    integer i;

    dmem #(.SIZE(16384)) DMEM(
		.addr(addr),
		.data_out(data_from_mem),
		.data_in(data_from_reg),
		.write_enable(write_enable),
		.byte(byte),
		.half_word(half_word),
		.sign_extend(sign_extend),
		.clock(clock)
	);

	imem #(.SIZE(1024)) IMEM(
		.addr(iaddr),
		.instr(instr)
	);

	processor PROCESSOR(
		//Global signals
		.clock(clock),
		.reset(reset),
		//DMEM signals
		.addr(addr),
		.write_enable(write_enable),
		.byte(byte),
		half_word(half_word),
		sign_extend(sign_extend),
		.data_out(data_from_proc),
		.data_in(data_from_mem),
		//IMEM signals
		.iaddr(iaddr),
		.instr(instr)
	);

	always
		//Clock cycle is 100
		#50 clock = !clock;

    initial begin
        // Clear DMEM
        for (i = 0; i < DMEM.SIZE; i = i+1)
            DMEM.mem[i] = 8'h0;

		// Load IMEM from file
		if (!$value$plusargs("instrfile=%s", filename)) begin
			filename = IMEMFILE;
		end
		$readmemh(filename, IMEM.mem);

        // Load DMEM from file
        if (!$value$plusargs("datafile=%s", filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DMEM.mem);

		//Monitor memory
        $monitor("write enable=%b | byte=%b | half word=%b | sign extend=%b | address=%x | data out= %x | data in=%x",
			write_enable, byte, half_word, sign_extend, addr, data_out, data_in);

		//Start clock
		clock = 0;

		//Reset registers for 1 cycle
		reset = 1;
		#100 reset = 0;

		//End Simulation after 100 cycles
		#10000 $finish;

        // Debug: dump memory
        //$writememh("dmem", DMEM.mem);
	end
endmodule

