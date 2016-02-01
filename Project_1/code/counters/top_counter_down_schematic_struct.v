module top_counter_down_schematic_struct(KEY, LED, init_clk);
	input init_clk, KEY;
	output[9:0] LED;

	reg[26:0] tBase; //  system timebase
	wire slow_clk, inv_q;
	
	always @(posedge init_clk) tBase <= tBase + 1'b1; 	         //  build the timebase
	
	DFlipFlop time_flip (.q(slow_clk), .qBar(inv_q), .D(inv_q), .clk(tBase[24]), .rst(KEY));  //  uses system clock / 2^19 ~= 10 cycles per second
	
	count_down_schematic schematic_please (.CLOCK(slow_clk), .RESET(KEY), .out(LED[3:0]));
//	count_down_schematic schematic_please (.CLOCK(init_clk), .RESET(KEY), .out(LED[3:0]));
endmodule 