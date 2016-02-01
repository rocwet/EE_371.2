// `include "DFlipFlop.v"
// `include "diff_pressure.v"
// `include "limit_pressure.v"
// `include "inputHandler.v"

module interlock (LED, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, arrive, depart, fill, drain, iport, oport, select, testPressure, reset, clock);
  
  /* define the output and input ports */
  output reg [9:0] LED;
  output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  input arrive, depart, fill, drain, iport, oport, select, testPressure;
  input reset, clock;
  
  /* new state holding wire and reg */
  wire [3:0] PS;
  reg  [3:0] NS;
  
  reg  [26:0] count;
  wire diffError, limitError;
  
  /* TIME DELAY of ~ 5 seconds */
	parameter TIME_DELAY = 16;
	parameter BLINKS = 4; // (2^(BLINKS-1))
	
	/* For Simulations (gtkwave) */
	// parameter TIME_DELAY = 2;
	// parameter BLINKS = 2;

	/* Real Time Output (signal tap) */
  // parameter TIME_DELAY = 5;
  // parameter BLINKS = 5;
  
  /* define conditions */
  parameter [3:0] INIT             = 4'h0, PREP             = 4'h1, WAIT_FILL  = 4'h2, FILLING  = 4'h3,
                  WAIT_IPORT_OPEN  = 4'h4, WAIT_OPORT_OPEN  = 4'h5, WAIT_DRAIN = 4'h6, DRAINING = 4'h7,
                  WAIT_IPORT_CLOSE = 4'h8, WAIT_OPORT_CLOSE = 4'h9, WAIT_USER  = 4'hA, ERROR    = 4'hB;
                  
  always @ (PS or arrive or depart or count or fill or drain or iport or oport or limitError or diffError) begin
    case (PS) 
    
      /* INTIAL CONDITION */
      INIT: begin
        if (arrive) NS = PREP;
        else if (iport) NS = WAIT_USER;
        else NS = INIT;
      end
      
			/* WAITING FOR DEPART CONDITION */
      WAIT_USER: begin
        if (!iport && depart) begin 
          NS = PREP;
        end
        else begin
          NS = WAIT_USER;
        end
			end
			
      /* PREP CONDITION */
      PREP: begin
        if (count[TIME_DELAY]) begin 
          NS = WAIT_FILL;
        end
        else begin
          NS = PREP;
        end
			end
		
      /* WAITING TO FILL CONDITION */
      WAIT_FILL: begin
				if (fill && !depart && !arrive) begin
					NS = FILLING;
				end
				else begin
					NS = WAIT_FILL;
				end
      end

      /* FILLING CONDITION*/
      FILLING: begin
				if (limitError) begin
					NS = ERROR;
				end
				else if (count[TIME_DELAY] && count[TIME_DELAY - 1]) begin
					NS = WAIT_OPORT_OPEN;
				end
				else begin
					NS = FILLING;
				end
      end
      
      /* WAITING FOR OUTER PORT TO OPEN */
      WAIT_OPORT_OPEN: begin
				if (diffError) begin
					NS = ERROR;
				end
				else if (oport) begin
					NS = WAIT_OPORT_CLOSE;
				end
				else begin
					NS = WAIT_OPORT_OPEN;
				end
      end
      
      /* WAITING FOR OUTER PORT TO OPEN */
      WAIT_OPORT_CLOSE: begin
				if (!oport) begin
					NS = WAIT_DRAIN;
				end
				else begin
					NS = WAIT_OPORT_CLOSE;
				end
      end
      
      /* WAITING FOR DRAIN CONDITION */
      WAIT_DRAIN: begin
				if (drain) begin
					NS = DRAINING;
				end
				else begin
					NS = WAIT_DRAIN;
				end
      end
      
      /* DRAINING CONDITION */
      DRAINING: begin
				if (limitError) begin
					NS = ERROR;
				end
				else if (count[TIME_DELAY] && count[TIME_DELAY - 1] && count[TIME_DELAY - 2]) begin
					NS = WAIT_IPORT_OPEN;
				end
				else begin
					NS = DRAINING;
				end
      end
			
			/* WAITING FOR INNER PORT TO OPEN */
      WAIT_IPORT_OPEN: begin
				if (diffError) begin
					NS = ERROR;
				end
				else if (iport) begin
					NS = WAIT_IPORT_CLOSE;
				end
				else begin
					NS = WAIT_IPORT_OPEN;
				end
      end
			
			/* WAITING FOR INNER PORT TO CLOSE */
      WAIT_IPORT_CLOSE: begin
				if (!iport) begin
					NS = INIT;
				end
				else begin
					NS = WAIT_IPORT_CLOSE;
				end
      end
			
			/* ERROR CONDITION */
      ERROR: begin
				NS = ERROR;
      end
    
      default: NS = 4'hx;
    endcase
  end
  
  always @(PS) begin
		case (PS) 
		 
			/* INTIAL CONDITION */
			INIT: begin
				HEX5 = ~7'b1101101; // start
				HEX4 = ~7'b1111000;
				HEX3 = ~7'b1110111;
				HEX2 = ~7'b1010000;
				HEX1 = ~7'b1111000;
				HEX0 = ~7'b0000000;
			end
			
			/* WAITING FOR DEPART CONDITION */
			WAIT_USER: begin
				HEX5 = ~7'b1111100; // board
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b1110111;
				HEX2 = ~7'b1010000;
				HEX1 = ~7'b1011110;
				HEX0 = ~7'b0000000;
			end
				
			/* PREP CONDITION */
			PREP: begin
				HEX5 = ~7'b1110011; // prep
				HEX4 = ~7'b1010000;
				HEX3 = ~7'b1111001;
				HEX2 = ~7'b1110011;
				HEX1 = ~7'b0000000;
				HEX0 = ~7'b0000000;
			end
			
			/* WAITING TO FILL CONDITION */
			WAIT_FILL: begin
				HEX5 = ~7'b1110100; // hold-f
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b0000110;
				HEX2 = ~7'b1011110;
				HEX1 = ~7'b1000000;
				HEX0 = ~7'b1110001;
			end

			/* FILLING CONDITION*/
			FILLING: begin
				HEX5 = ~7'b1110001; // fill
				HEX4 = ~7'b0000100;
				HEX3 = ~7'b0000110;
				HEX2 = ~7'b0000110;
				HEX1 = ~7'b0000000;
				HEX0 = ~7'b0000000;
			end
			
			/* WAITING FOR OUTER PORT TO OPEN */
			WAIT_OPORT_OPEN: begin
				HEX5 = ~7'b0111111; // Oopen
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b1110011;
				HEX2 = ~7'b1111001;
				HEX1 = ~7'b1010100;
				HEX0 = ~7'b0000000;
			end

			/* WAITING FOR OUTER PORT TO OPEN */
			WAIT_OPORT_CLOSE: begin
				HEX5 = ~7'b0111111; // Oclose
				HEX4 = ~7'b1011000;
				HEX3 = ~7'b0000110;
				HEX2 = ~7'b1011100;
				HEX1 = ~7'b1101101;
				HEX0 = ~7'b1111001;
			end
			
			/* WAITING FOR DRAIN CONDITION */
			WAIT_DRAIN: begin
				HEX5 = ~7'b1110100; // hold-d
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b0000110;
				HEX2 = ~7'b1011110;
				HEX1 = ~7'b1000000;
				HEX0 = ~7'b1011110;
			end
			
			/* DRAINING CONDITION */
			DRAINING: begin
				HEX5 = ~7'b1011110; // drain
				HEX4 = ~7'b1010000;
				HEX3 = ~7'b1110111;
				HEX2 = ~7'b0000100;
				HEX1 = ~7'b1010100;
				HEX0 = ~7'b0000000;
			end
				
			/* WAITING FOR INNER PORT TO OPEN */
			WAIT_IPORT_OPEN: begin
				HEX5 = ~7'b0000100; // iopen
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b1110011;
				HEX2 = ~7'b1111001;
				HEX1 = ~7'b1010100;
				HEX0 = ~7'b0000000;
			end
				
			/* WAITING FOR INNER PORT TO CLOSE */
			WAIT_IPORT_CLOSE: begin
				HEX5 = ~7'b0000100; // iclose
				HEX4 = ~7'b1011000;
				HEX3 = ~7'b0000110;
				HEX2 = ~7'b1011100;
				HEX1 = ~7'b1101101;
				HEX0 = ~7'b1111001;
			end
				
			/* ERROR CONDITION */
			ERROR: begin
				HEX5 = ~7'b1111001; // error
				HEX4 = ~7'b1010000;
				HEX3 = ~7'b1010000;
				HEX2 = ~7'b0111111;
				HEX1 = ~7'b1010000;
				HEX0 = ~7'b0000000;
			end
		 
			default: begin
				HEX5 = ~7'bxxxxxxx; // default
				HEX4 = ~7'bxxxxxxx;
				HEX3 = ~7'bxxxxxxx;
				HEX2 = ~7'bxxxxxxx;
				HEX1 = ~7'bxxxxxxx;
				HEX0 = ~7'bxxxxxxx;
			end
		endcase
	end
  
	always @(posedge clock) begin 
		case (PS)
			WAIT_FILL:        count = 27'h0;
			WAIT_OPORT_OPEN:  count = 27'h0;
			WAIT_IPORT_OPEN:  count = 27'h0;
			PREP:             count = count + 27'h1;
			FILLING:          count = count + 27'h1;
			DRAINING:         count = count + 27'h1;
			default:          count = 27'h0;
		endcase
	end
	
	always @(PS or count) begin
		case (PS) 
		 
			/* INTIAL CONDITION */
			INIT: begin
				LED[7:0] = 8'h00;
			end
			
			/* WAITING FOR DEPART CONDITION */
			WAIT_USER: begin
				LED[3] = 1'h1;
			end
				
			/* PREP CONDITION */
			PREP: begin
				if (arrive) begin
					LED[0] = 1'h1;
					LED[1] = 1'h0;
				end
				else if (depart) begin 
					LED[1] = 1'h1;
					LED[0] = 1'h0;
				end
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = count[TIME_DELAY - BLINKS];
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
			
			/* WAITING TO FILL CONDITION */
			WAIT_FILL: begin
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end

			/* FILLING CONDITION*/
			FILLING: begin
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = count[TIME_DELAY - BLINKS];
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
			
			/* WAITING FOR OUTER PORT TO OPEN */
			WAIT_OPORT_OPEN: begin
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end

			/* WAITING FOR OUTER PORT TO OPEN */
			WAIT_OPORT_CLOSE: begin
				LED[2] = 1'b1;
				LED[3] = 1'h0;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
			
			/* WAITING FOR DRAIN CONDITION */
			WAIT_DRAIN: begin
				LED[2] = 1'b0;
				LED[3] = 1'h0;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
			
			/* DRAINING CONDITION */
			DRAINING: begin
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = count[TIME_DELAY - BLINKS];
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;			
			end
				
			/* WAITING FOR INNER PORT TO OPEN */
			WAIT_IPORT_OPEN: begin
				LED[2] = 1'h0;
				LED[3] = 1'h0;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
				
			/* WAITING FOR INNER PORT TO CLOSE */
			WAIT_IPORT_CLOSE: begin
				LED[2] = 1'h0;
				LED[3] = 1'h1;
				LED[4] = 1'h0;
				LED[5] = 1'h0;
				LED[6] = 1'h0;
				LED[7] = 1'h0;
			end
				
			/* ERROR CONDITION */
			ERROR: begin
				LED[7:0] = 8'h00;
			end
		 
			default: begin
				LED[7:0] = 8'hXX;
			end
		endcase
	end
	
	always @(diffError or limitError) begin
		LED[8] = diffError;
		LED[9] = limitError;
	end
  
	diff_pressure diff0 (.diff(diffError), .key(testPressure), .SW(~select), .clk(clock), .reset(reset));
	limit_pressure limit0 (.limit(limitError), .key(testPressure), .SW(select), .clk(clock), .reset(reset));
	
	// HEX DISPLAY STATUS & EXTRA LEDS DISPLAY TIME
	
	DFlipFlop flip0 (.q(PS[0]), .qBar(), .D(NS[0]), .clk(clock), .rst(reset));
	DFlipFlop flip1 (.q(PS[1]), .qBar(), .D(NS[1]), .clk(clock), .rst(reset));
	DFlipFlop flip2 (.q(PS[2]), .qBar(), .D(NS[2]), .clk(clock), .rst(reset));
	DFlipFlop flip3 (.q(PS[3]), .qBar(), .D(NS[3]), .clk(clock), .rst(reset));
  
endmodule


 
 /* ---------------------------------------------------------------------------------------- */
/* ------------------------------------TEST BENCH------------------------------------------ */
/* ---------------------------------------------------------------------------------------- */

/*
The interlock_testBench module tests the diff_pressure module. 
*/
module interlock_testBench;

  /* Wires for testing */
  wire arrive, depart, fill, drain, iport, oport, select, testPressure, reset, clock;
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire[9:0] LED;
  /* declare instance of diff_pressure module */
  
  interlock dut (.LED(LED), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .arrive(arrive), .depart(depart),
						.fill(fill), .drain(drain), .iport(iport), .oport(oport), .select(select), .testPressure(testPressure), .reset(reset), .clock(clock));
  
  /* declare instance of test module */
  interlock_tester iTest (.LED(LED), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .arrive(arrive), .depart(depart),
						.fill(fill), .drain(drain), .iport(iport), .oport(oport), .select(select), .testPressure(testPressure), .reset(reset), .clock(clock));
  
  /* file for gtkwave */
  initial begin
    $dumpfile("____gtkwave____INTERLOCK____.vcd");
    $dumpvars(1, dut);
  end
  
endmodule

/*
The interlock_tester module generates the reset, clock, and key signals for testing.

TYPE      |NAME         |WIDTH    |DESCRIPTION       
-----------------------------------------------------------------------------------
output    |arrive       |1 bit    |The generated reset signal for testing.
output    |clock        |1 bit    |The genereated clk signal for testing.
output    |depart       |1 bit    |The genereated key signal for testing.
output    |fill         |1 bit    |The generated reset signal for testing.
output    |drain        |1 bit    |The genereated clk signal for testing.
output    |iport        |1 bit    |The genereated key signal for testing.
output    |oport        |1 bit    |The output signal used for printing to stdout.
output    |select       |1 bit    |The genereated clk signal for testing.
output    |testPressure |1 bit    |The genereated key signal for testing.
output    |reset        |1 bit    |The genereated clk signal for testing.
input     |LED          |10 bit    |The genereated key signal for testing.
input     |HEX0         |7 bit    |The genereated key signal for testing.
input     |HEX1         |7 bit    |The genereated key signal for testing.
input     |HEX2         |7 bit    |The genereated key signal for testing.
input     |HEX3         |7 bit    |The genereated key signal for testing.
input     |HEX4         |7 bit    |The genereated key signal for testing.
input     |HEX5         |7 bit    |The genereated key signal for testing.

 */
module interlock_tester(LED, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, arrive, depart, fill, drain, iport, oport, select, testPressure, reset, clock);

  /* Defining the output/input ports */
  output reg arrive, depart, fill, drain, iport, oport, select, testPressure, reset, clock;
  input [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  input [9:0] LED;

  /* Delay Constant */
  parameter DELAY = 10;
  
  /* Display information of ports to stdout */
  initial begin
    $display("\t arrive \t depart \t fill \t drain \t iport \t oport \t select \t testPressure \t reset \t clock \t HEX0 \t HEX1 \t HEX2 \t HEX3 \t HEX4 \t HEX5 \t LED ");
    $monitor("\t %b \t\t %b \t\t %b \t\t %b \t\t  %b \t\t  %b \t\t  %b \t\t %b \t\t %b \t\t %b \t\t %d \t\t %d \t\t %d \t\t %d \t\t %d \t\t %d \t\t %b",
					arrive, depart, fill, drain, iport, oport, select, testPressure, reset, clock, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LED);
  end
  
  /* Update Clock */
  always begin
    #DELAY clock = 1;
    #DELAY clock = 0;
  end
  
  /* Set values for ports w/ delays*/
  initial begin
		// REGULAR ARRIVAL AND DEPATURE CASES 
		arrive = 0; 
		depart = 0; 
		fill = 0; 
		drain = 0; 
		iport = 0; 
		oport = 0; 
		select = 0; 
		testPressure = 0;
		
		// Reset On and Off
		reset = 1; #80;
		reset = 0; #40;
		
		// NOW ARRIVING AT THE INTERLOCK 
		// Arrival signal, waits for the 5 second arrival
		arrive = 1; #100;
		arrive = 0; #60;
		
		// Fill Signal, waits for the 7 seconds to pressurize
		fill = 1; #40;
		fill = 0; #100;
		
		 // Opens and closes the oport
		oport = 1; #40;
		oport = 0; #40;
		
		// Drain Signal, waits for the 8 seconds to drain
		drain = 1; #100;
		drain = 0; #80;
		
		// Opens and closes tje iport
		iport = 1; #40;
		iport = 0; #40;
		
		// BACK TO THE INITIAL STATE 

		// NOW DEPARTING THE INTERLOCK 
		// Opens the inner port and sends the departing signal
		iport = 1; #40;
		depart = 1; #20;
	   
		// Closes the inner port
		iport = 0; #100;
		depart = 0; #60;
		
		// Fill Signal, pressurizes the interlock chamber
		fill = 1; #40;
		fill = 0; #100;
		
		// Open and closes the outer port 
		oport = 1; #40;
		oport = 0; #40;
		
		// Drain Signal, depressurizes the interlock chamber
		drain = 1; #100;
		drain = 0; #80;
		
		// Open and closes the inner port
		iport = 1; #40;
		iport = 0; #40;

		// // Check ERROR state for differential pressure
		// arrive = 1; #100;
		// arrive = 0; #60;
		
		// fill = 1; #40;
		// testPressure = 1; #20;
		// fill = 0; #80;
		// testPressure = 0; #20;
		
		// oport = 1; #40;
		// oport = 0; #40;
		
		// reset = 1; #40;
		// reset = 0; #40;

		// arrive = 1; #100;
		// arrive = 0; #60;
		
		// fill = 1; #40;
		// fill = 0; #100;
		
		// oport = 1; #40;
		// oport = 0; #40;
		
		// drain = 1; #40;
		// testPressure = 1; #20;
		// drain = 0; #80;
		// testPressure = 0; #80;
		
		// iport = 1; #40;
		// iport = 0; #40;

		// // Check ERROR state for pressure LIMITS
		// select = 1;
		// arrive = 1; #100;
		// arrive = 0; #60;
		
		// fill = 1; #40;
		// testPressure = 1; #40;
		// testPressure = 0; #20;
		// fill = 0; #40;
		
		// oport = 1; #40;
		// oport = 0; #40;
		
		// reset = 1; #40;
		// reset = 0; #40;

		// select = 1;
		// arrive = 1; #100;
		// arrive = 0; #60;
		
		// fill = 1; #40;
		// fill = 0; #100;
		
		// oport = 1; #40;
		// oport = 0; #40;
		
		// drain = 1; #60;
		// testPressure = 1; #40;
		// testPressure = 0; #20;
		// drain = 0; #40;
		
		// iport = 1; #40;
		// iport = 0; #40;
		$finish;
	end
  
endmodule
