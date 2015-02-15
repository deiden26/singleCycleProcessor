/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  lu.v                                                //
//                                                                     //
//  Description :  Unit to allow for storing of byte, half word,       //
//                 and word sized chunks of data into memory           //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps


module su(
    input      [31:0] data_in,               // data from register
    input      [31:0] old_vale,              // data from memory
    input             byte,                  // mux signal to slect byte
    input             half_word,             // mux signal to slect half word

    output reg [31:0] data_out               // data to memory
  );


  wire         [31:0] extended_byte;
  wire         [31:0] extended_half_word;

  //Extend data in with old value from memory
  assign extended_byte = {old_vale[31:8], data_in[7:0]};
  assign extended_half_word = {old_vale[31:16], data_in[15:0]};

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
