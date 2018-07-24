`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:52 10/10/2017 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(input enable,input [3:0]	fn_sel,
		input	 [7:0]	a, b,
		output reg	[7:0]	out,
		input cmpflag);				

	//All alu operations have 3 operands , 1st destination, 2nd input1, 3rd input2.
	//except Dec and Inc where only one operand used.

	parameter z=3'd0,c=3'd1,v=3'd2,s=3'd3; 
	//z is zero flag, c is carry flag,v is overflow,s is signed bit flag
	//Parameters are just used for more readablitiy.

	wire [8:0] sub_ab;			//subtraction
	wire [8:0] add_ab;			//Addition		
	wire [8:0] left_shift_ab;	//LeftShift
	wire [8:0] right_shift_ab;	//RightShift
	wire [8:0]	decrement_a, increment_a; //Decrement and Increment

	reg [3:0]flags;				//Status Register or Flags

	assign add_ab = a+b;			//Add operation	
	assign sub_ab = a-b;			//Sub operation
	assign left_shift_ab = a<<b;	//leftshift a by b units
	assign right_shift_ab = a>>b;	//right shift a by b units
	assign decrement_a = a-1;		//Dec a by 1
	assign increment_a = a+1;		// Inc a by 1
		
	always @(posedge enable) begin
		case (fn_sel)				
			4'd0:  								//Add
			begin
				out <= add_ab;
				if(add_ab[8]==1'd1)begin		//When the 9th bit of output is 1 then it has carry or overflow 
					flags[c] = 1'd1;
					flags[v] = 1'd1;
				end	
				else begin
					flags[c] = 1'd0;
					flags[v] = 1'd0;
				end
			end
			4'd1: 								//Subtract			
			begin
				out <= sub_ab;
				if(sub_ab[8]==1'd1)begin		//9th bit is 1 when output is 2's compliment of negative number 
					flags[s] = 1'd1;			//obtained by subtracting
					flags[v] = 1'd1;
				end		
				if(a<b)begin					//if a<b subtraction gives negative result
					flags[s] = 1'd1;
				end	
				else begin
					flags[s] = 1'd0;
					flags[v] = 1'd0;
				end	
			end
			4'd2:  out <= a & b;					//And operation
			4'd3:  out <= a | b;					//Or operation
			4'd4:  									//LEft shift
			begin
				out <= left_shift_ab;
				if(left_shift_ab[8]==1'd1)begin		//overflow when 9th bit is 1 while shifting
						flags[v] = 1'd1;
				end		
				else begin
					flags[v] = 1'd0;
				end	
			end				
			4'd5:  									//Right shift
			begin
				out <= right_shift_ab;
				if(right_shift_ab[8]==1'd1)begin	//overflow when 9th bit is 1 while shifting
						flags[v] = 1'd1;
				end		
				else begin
					flags[v] = 1'd0;
				end	
			end		
			4'd6:									//Decrement Register
			begin
				out <= decrement_a;
				if(decrement_a[8]==1'd1)begin	//9th bit is 1 when output is 2's compliment of negative number 
					flags[s] = 1'd1;			//obtained by decrementing
					flags[v] = 1'd1;
				end		
				else begin
					flags[s] = 1'd0;
					flags[v] = 1'd0;
				end	

			end		
			4'd7:									//Increment Register
			begin
				out <= increment_a;
				if(increment_a[8]==1'd1)begin		//overflow when 9th bit is 1 while incrementing
						flags[v] = 1'd1;
				end		
				else begin
					flags[v] = 1'd0;
				end	
			end	
			default: out <= 0;					
		endcase

		if(out==8'd0)begin							//when output is zero 
			flags[z] =1'd1;							//Zero flag is set
		end	
		else begin						
			flags[z] = cmpflag-1;					//or zero flag is set when CMP two equal numbers.
		end	
	end

endmodule
