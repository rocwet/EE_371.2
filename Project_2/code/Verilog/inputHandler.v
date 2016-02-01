// The inputS module will define the rules for button presses for tug of war
// No presses        = No presses
// Single Presses    = Single Press
// Held Presses      = Single Press
// PARAMETER     
// Clock             = clock cyle
// reset             = reset signal
// button            = received button press
// BT                = new button signal w/ implemented rules
module inputHandler(out, Clock, reset, button);

	// ports
	input Clock, reset, button;
	output reg out;
	
	// variables
	parameter[1:0]  A = 2'b00, B = 2'b01, C = 2'b10;
	wire[1:0] PS;
	reg[1:0] NS;
	
	// next state logic
	always @(PS or button) begin
		case(PS)
			A:	if(button) 	NS = B;
				else 			NS = A;
			B: if(button) 	NS = C;
				else 			NS = A;
			C: if(button) 	NS = C;
				else 			NS = A;
		endcase
	end
		
	// output logic
	always @(PS) begin
		case(PS)
			A: out = 0;
			B: out = 1;
			C: out = 0;
		endcase
	end
	
	// state holding changing
	DFlipFlop msb (.q(PS[0]), .qBar(), .D(NS[0]), .clk(Clock), .rst(reset));
  
	DFlipFlop lsb (.q(PS[1]), .qBar(), .D(NS[1]), .clk(Clock), .rst(reset));
	
endmodule