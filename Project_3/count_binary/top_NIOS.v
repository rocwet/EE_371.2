module top_NIOS(LED, reset, clk);
	input reset, clk;
	output[9:0] LED;
	
	first_nios2_system hi_guys (.clk_clk(clk), .reset_reset_n(reset), .led_connection_export(LED[7:0]));

endmodule 