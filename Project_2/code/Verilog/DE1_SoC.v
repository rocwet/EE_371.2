// Top level module for bathyshpere port.
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW); 
	input CLOCK_50;  // 50MHZ clock
	input[3:0] KEY; 
	input[9:0] SW;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	output[9:0] LEDR;

	reg[26:0] tBase;  // System timebase
	wire slow_clk, inv_q, resetReal;
	  
	assign resetReal = ~KEY[0];
	always @(posedge CLOCK_50) tBase <= tBase + 1'b1; 	         //  Build timebase

	DFlipFlop time_flip (.q(slow_clk), .qBar(inv_q), .D(inv_q), .clk(tBase[10]), .rst(resetReal));  //  uses system clock / 2^19 ~= 10 cycles per second
  
	interlock i_lock (.LED(LEDR), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .arrive(SW[0]), .depart(SW[1]),
						.fill(~KEY[1]), .drain(~KEY[2]), .iport(SW[3]), .oport(SW[2]), .select(SW[4]), .testPressure(~KEY[3]), .reset(resetReal), .clock(slow_clk));

endmodule 