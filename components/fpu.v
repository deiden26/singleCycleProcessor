module fpu
	(input [31:0] busA,
	input [31:0] busB,
	input FPUctrl,
	output [31:0] FPUout
	);

	wire multOut, multuOut;

	assign multOut = busA * busB;

	if (multOut<0) begin
		assign multuOut = 0 - multOut;
	end
	else begin
		assign multuOut = multOut;
	end

	begin
		case (FPUctrl)
			0: assign FPUout = multOut;
			1: assign FPUout = multuOut;
		endcase
	end

endmodule