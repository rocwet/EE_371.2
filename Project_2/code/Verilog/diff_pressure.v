module diff_pressure (diff, key, SW, clk, reset);
	input clk, key, reset, SW;
	output reg diff;

	wire PS, singleKey;
	reg NS;
  
	inputHandler inputH (.out(singleKey), .Clock(clk), .reset(reset), .button(key));

	parameter UNDER = 1'b0, OVER = 1'b1;
	
	always @(singleKey or reset) begin    
		case (PS) 
		
			/* DIFFERENTIAL PRESSURE IS <= 0.1 atm */
			UNDER: begin
				if (singleKey && SW) NS = OVER;
				else NS = PS;
			end

			/* DIFFERENTIAL PRESSURE IS > 0.1 atm */
			OVER: begin
				if (singleKey && SW) NS = UNDER;
				else NS = PS;
			end

			default: NS = 1'bx;
		endcase
	end
		
	DFlipFlop flip0 (.q(PS), .qBar(), .D(NS), .clk(clk), .rst(reset));
	
	always @(PS) begin
		diff = PS;
	end
endmodule

///* ---------------------------------------------------------------------------------------- */
///* ------------------------------------TEST BENCH------------------------------------------ */
///* ---------------------------------------------------------------------------------------- */
//
///*
//The diff_pressure_testBench module tests the diff_pressure module. 
//*/
//module diff_pressure_testBench;
//
//  /* Wires for testing */
//  wire diff, key, SW, clk, reset;
//  
//  /* declare instance of diff_pressure module */
//  diff_pressure dut (.diff(diff), .key(key), .SW(SW), .clk(clk), .reset(reset));
//  
//  /* declare instance of test module */
//  diff_pressure_tester aTest (.resetOut(reset), .clkOut(clk), .SWOut(SW), .keyOut(key), .diff(diff));
//  
//  /* file for gtkwave */
//  initial begin
//    $dumpfile("____gtkwave____DIFF_PRESSURE____.vcd");
//    $dumpvars(1, dut);
//  end
//  
//endmodule
//
///*
//The diff_pressure_tester module generates the reset, clock, and key signals for testing.
//It also prints diff, on stdout, the output and inputs of the diff_pressure module.
//
//TYPE      |NAME       |WIDTH    |DESCRIPTION       
//-----------------------------------------------------------------------------------
//output    |resetOut   |1 bit    |The generated reset signal for testing.
//output    |clkOut     |1 bit    |The genereated clk signal for testing.
//output    |keyOut     |1 bit    |The genereated key signal for testing.
//input     |diff       |1 bit    |The output signal used for printing to stdout.
// */
//module diff_pressure_tester(resetOut, clkOut, SWOut, keyOut, diff);
//
//  /* Defining the output/input ports */
//  output reg resetOut, clkOut, SWOut, keyOut;
//  input diff;
//  
//  /* Delay Constant */
//  parameter DELAY = 10;
//  integer i;
//  
//  /* Display information of ports to stdout */
//  initial begin
//    $display("\t resetOut \t clkOut \t keyOut \t SWOut \t out ");
//    $monitor("\t %b \t\t %b \t\t %b \t\t %b \t\t %b", resetOut, clkOut, keyOut, SWOut, diff);
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
//		SWOut = 0;
//		resetOut = 0;
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