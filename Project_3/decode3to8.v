/*
The decode3to8 is a 3 to 8 decoder.
 
@ author    Minh Khuu
@ author    Denny Ly
@ author    Ruchira Kulkarni
@ date      2016.01.31
@ version   Project 3

TYPE      |NAME       |WIDTH    |DESCRIPTION       
-----------------------------------------------------------------------------------
output    |out        |8 bit    |Output of the decoder.
input     |in         |3 bit    |Input of the decoder.
input     |enable     |1 bit    |Enable decoder on active high.
*/
module decode3to8(in, out, enable);
	
	/* define output and input ports */
  output [7:0] out;
	input  [2:0] in;
	input enable;
		
	/* wires */
	wire [1:0] dec1to2out;

	/* 1:2 decoders */
	decode1to2 d12_0 (.in(in[2]), .out(dec1to2out), .enable(enable));
	
	/* 2:4 decoder */
	decode2to4 d24_0 (.in(in[1:0]), .out(out[3:0]), .enable(dec1to2out[0]));
	decode2to4 d24_1 (.in(in[1:0]), .out(out[7:4]), .enable(dec1to2out[1]));

endmodule