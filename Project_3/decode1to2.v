/*
The decode1to2 is a 1 to 2 decoder.
 
@ author    Minh Khuu
@ author    Denny Ly
@ author    Ruchira Kulkarni
@ date      2016.01.31
@ version   Project 3

TYPE      |NAME       |WIDTH    |DESCRIPTION       
-----------------------------------------------------------------------------------
output    |out        |2 bit    |Output of the decoder.
input     |in         |1 bit    |Input of the decoder.
input     |enable     |1 bit    |Enable decoder on active high.
*/
module decode1to2(out, in, enable);
	
	/* define output and input ports */
  output [1:0] out;
	input in;
	input enable;
	
	/* wires */
	wire notin;
	
	/* gate logic */
	not notinput (notin, in);
	and output0  (out[0], notin, enable);
	and output1  (out[1], in, enable);
	
endmodule