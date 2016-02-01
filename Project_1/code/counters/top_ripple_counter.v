module top_ripple_counter(KEY, LED, init_clk);
	input init_clk;
	input KEY;
	output[9:0] LED;

	reg[26:0] tBase;  //  system timebase
	wire slow_clk, inv_q;
	
	always @(posedge init_clk) tBase <= tBase + 1'b1;  //  build the timebase

	DFlipFlop time_flip (.q(slow_clk), .qBar(inv_q), .D(inv_q), .clk(tBase[24]), .rst(KEY));  //  uses system clock / 2^19 ~= 10 cycles per second

	ripple_counter ripple_please (.out(LED[3:0]), .reset(KEY), .clk(slow_clk));
	
//	ripple_counter ripple_please (.out(LED[3:0]), .reset(KEY), .clk(init_clk));
endmodule 