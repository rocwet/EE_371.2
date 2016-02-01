module top_johnson_counter_behavioural(KEY, LED, init_clk);
	input init_clk, KEY;
	output[9:0] LED;

//	reg[26:0] tBase; //  system timebase
//	wire slow_clk, inv_q;
//	
//	always @(posedge init_clk) tBase <= tBase + 1'b1; 	         //  build the timebase
//	
//	D_FF time_flip (.q(slow_clk), .qBar(inv_q), .D(inv_q), .clk(tBase[24]), .rst(KEY));  //  uses system clock / 2^19 ~= 10 cycles per second
//	
//	count_down_johnson_behavioural johnson_please (.out(LED[3:0]), .reset(KEY), .clk(slow_clk));
	
	count_down_johnson_behavioural johnson_please (.out(LED[3:0]), .reset(KEY), .clk(init_clk));
endmodule 