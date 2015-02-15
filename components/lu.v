/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  lu.v                                                //
//                                                                     //
//  Description :  Unit to allow for loading of byte, half word,       //
//                 and word sized chunks of data out of memory         //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps


module lu(
    input      [31:0] data_in,               // data from memory
    input             sign_extend,           // whether to sign or zero extend
    input             byte,                  // mux signal to slect byte
    input             half_word,             // mux signal to slect half word

    output reg [31:0] data_out               // data to bus
  );


  reg          [31:0] extended_byte;
  reg          [31:0] extended_half_word;

  //Byte extender
  always@(sign_extend or data_in) begin
	  if(sign_extend)
		  extended_byte <= $signed(data_in[31:24]);
	  else
		  extended_byte <= $unsigned(data_in[31:24]);
  end

  //Half word extender
  always@(sign_extend or data_in) begin
	  if(sign_extend)
		  extended_half_word <= $signed(data_in[31:16]);
	  else
		  extended_half_word <= $unsigned(data_in[31:16]);
  end

  //Output mux
  always@(byte or half_word or extended_byte or extended_half_word) begin
	  if(byte)
		  data_out <= extended_byte;
	  else if(half_word)
		  data_out <= extended_half_word;
	  else
		  data_out <= data_in;
  end

endmodule
