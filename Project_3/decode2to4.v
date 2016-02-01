/*
The decode2to4 is a 2 to 4 decoder.
 
@ author    Minh Khuu
@ author    Denny Ly
@ author    Ruchira Kulkarni
@ date      2016.01.31
@ version   Project 3

TYPE      |NAME       |WIDTH    |DESCRIPTION       
-----------------------------------------------------------------------------------
output    |out        |4 bit    |Output of the decoder.
input     |in         |2 bit    |Input of the decoder.
input     |enable     |1 bit    |Enable decoder on active high.
*/
module decode2to4(in, out, enable);
  
  /* define output and input ports */
  output [3:0] out;
  input  [1:0] in;
  input enable;
  
  /* wires */
  wire [1:0] dec1to2out;

  /* 1:2 decoders */
  decode1to2 d12_0 (.in(in[1]), .out(dec1to2out), .enable(enable));
  decode1to2 d12_1 (.in(in[0]), .out(out[1:0]), .enable(dec1to2out[0]));
  decode1to2 d12_2 (.in(in[0]), .out(out[3:2]), .enable(dec1to2out[1]));

endmodule