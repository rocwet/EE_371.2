module limit_pressure (limit, key, SW, clk, reset);
	input clk, key, SW, reset;
	output reg limit;

	wire PS, singleKey;
	reg NS;

	inputHandler inputL (.out(singleKey), .Clock(clk), .reset(reset), .button(key));
	
	parameter WITHIN = 1'b0, BEYOND = 1'b1;
	
	always @(singleKey or reset) begin
		case (PS) 
			 
			/* WITHIN LIMIT OF 16000 PSI and 13 PSI */
			WITHIN: begin
				if (singleKey && SW) NS = BEYOND;
				else NS = PS;
			end

			/* BEYOND LIMIT OF 16000 PSI and 13 PSI */
			BEYOND: begin
				if (singleKey && SW) NS = WITHIN;
				else NS = PS;
			end

			default: NS = 1'bx;
		endcase
	end
	
	DFlipFlop flip0 (.q(PS), .qBar(), .D(NS), .clk(clk), .rst(reset));

	always @(PS) begin
		limit = PS;
	end
endmodule

///* ---------------------------------------------------------------------------------------- */
///* ------------------------------------TEST BENCH------------------------------------------ */
///* ---------------------------------------------------------------------------------------- */
//
///*
//The limit_pressure_testBench module tests the limit_pressure module. 
//*/
//module limit_pressure_testBench;
//
//  /* Wires for testing */
//  wire limit, key, SW, clk, reset;
//  
//  /* declare instance of limit_pressure module */
//  limit_pressure dut (.limit(limit), .key(key), .SW(SW), .clk(clk), .reset(reset));
//  
//  /* declare instance of test module */
//  limit_pressure_tester aTest (.resetOut(reset), .clkOut(clk), .SWOut(SW), .keyOut(key), .limit(limit));
//  
//  /* file for gtkwave */
//  initial begin
//    $dumpfile("____gtkwave____LIMIT_PRESSURE____.vcd");
//    $dumpvars(1, dut);
//  end
//  
//endmodule
//
///*
//The limit_pressure_tester module generates the reset, clock, and key signals for testing.
//It also prints limit, on stdout, the output and inputs of the limit_pressure module.
//
//TYPE      |NAME       |WIDTH    |DESCRIPTION       
//-----------------------------------------------------------------------------------
//output    |resetOut   |1 bit    |The generated reset signal for testing.
//output    |clkOut     |1 bit    |The genereated clk signal for testing.
//output    |keyOut     |1 bit    |The genereated key signal for testing.
//input     |limit      |1 bit    |The output signal used for printing to stdout.
// */
//module limit_pressure_tester(resetOut, clkOut, SWOut, keyOut, limit);
//
//  /* Defining the output/input ports */
//  output reg resetOut, clkOut, keyOut, SWOut;
//  input limit;
//  
//  /* Delay Constant */
//  parameter DELAY = 10;
//  integer i;
//  
//  /* Display information of ports to stdout */
//  initial begin
//    $display("\t resetOut \t clkOut \t keyOut \t SWOut \t out ");
//    $monitor("\t %b \t\t %b \t\t %b \t\t %b \t\t %b", resetOut, clkOut, keyOut, SWOut, limit);
//  end
//  
//  /* Update Clock */
//  always begin
//    #DELAY clkOut = 1;
//    #DELAY clkOut = 0;
//  end
//  
//  /* Set values for ports w/ delays*/
//  initial begin
//    clkOut = 0;
//    resetOut = 1; #40;
//		resetOut = 0;
//		SWOut = 1;
//		keyOut = 0; #20;
//    for(i = 0; i < 4; i = i + 1) begin
//			keyOut = 0; #DELAY; #DELAY; #DELAY; #DELAY;
//			keyOut = 1; #DELAY; #DELAY; #DELAY; #DELAY;
//    end
//		for(i = 0; i < 4; i = i + 1) begin
//      keyOut = 1; #DELAY; #DELAY;
//			keyOut = 0; #DELAY; #DELAY;
//    end
//    resetOut = 1; #40;
//    for(i = 0; i < 4; i = i + 1) begin
//      keyOut = 0; #DELAY; #DELAY;
//			keyOut = 1; #DELAY; #DELAY;
//    end
//		resetOut = 0; #40;
//    for(i = 0; i < 4; i = i + 1) begin
//      keyOut = 0; #DELAY; #DELAY;
//			keyOut = 1; #DELAY; #DELAY;
//    end
//    $finish;
//	end
//  
//endmodule