module dmem(
	input [0:31] addr,
	input [0:31] data_in,
	input clock,
	input write_enable,
	input byte,
	input half_word,
    input sign_extend,

	output reg [0:31] data_out);

	parameter SIZE=32768;
	reg [0:7] mem[0:(SIZE-1)];

	always @ (negedge clock) begin
		//Write
		if (write_enable) begin
			if(byte)
				mem[addr] <= data_in[24:31];
			else if(half_word)
				{mem[addr], mem[addr+1]} <= data_in[16:31];
			else
				{mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} <= data_in[0:31];
		end
		//Read
		else begin
			if(byte) begin
				if(sign_extend)
					data_out <= $signed(mem[addr]);
				else
					data_out <= $unsigned(mem[addr]);
			end

			else if(half_word) begin
				if(sign_extend)
					data_out <= $signed({mem[addr], mem[addr+1]});
				else
					data_out <= $unsigned({mem[addr], mem[addr+1]});
			end

			else
				data_out <= {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
		end
	end

endmodule // dmem

// Test module. Loads data files
module memload_example();
    parameter DMEMFILE = "data.hex";
    reg [8*80-1:0] filename;
    reg [0:31] addr, data_in;
    wire [0:31] data_out;
    reg clock, write_enable, byte, half_word, sign_extend;

    integer i;

    dmem #(.SIZE(16384)) DMEM(.addr(addr), .data_out(data_out), .data_in(data_in), .write_enable(write_enable), .byte(byte), .half_word(half_word), .sign_extend(sign_extend), .clock(clock));

    initial begin
        // Clear DMEM
        for (i = 0; i < DMEM.SIZE; i = i+1)
            DMEM.mem[i] = 8'h0;

        // Load DMEM from file
        if (!$value$plusargs("datafile=%s", filename)) begin
            filename = DMEMFILE;
        end
        $readmemh(filename, DMEM.mem);

        //// Debug: dump memory
        //$writememh("dmem", DMEM.mem);

        // - Some Data values
        // 'monitor' follows signals automatically as they change
        $monitor("addr= %x data = %x", addr, data_out);
        addr = 32'h2000;
        #1
        addr = 32'h2001;
    end // initial
endmodule

