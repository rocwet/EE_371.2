module top_lights(LED, SW, KEY, CLOCK_50);
	input KEY, CLOCK_50;
	input[7:0] SW;
	output[7:0] LED;

	nios_lights hello_there (.clk_clk(CLOCK_50), .reset_reset_n(KEY), .switches_export(SW), .leds_export(LED));

endmodule