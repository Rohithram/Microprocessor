`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:07 10/17/2017 
// Design Name: 
// Module Name:    IM 
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
//This is internal registers module which contains 6 registers 
//used for writing and reading from the registers.
module InternalMemory(input wire [2:0] addr,
			input wire wr,rd,
			input  [7:0] in_data,
			output reg [7:0] out_data
    );
	// 6 registers each of 8bit.
	reg [7:0] r0,r1,r2,r3,r4,r5;

	always@*begin
		if(wr) begin				//writing into registers depending on the address given from CU_EU
			case(addr)
			3'b000: r0 <= in_data;
			3'b001: r1 <= in_data;
			3'b010: r2 <= in_data;
			3'b011: r3 <= in_data;
			3'b100: r4 <= in_data;
			3'b101: r5 <= in_data;
			endcase
		end
		else if(rd) begin			//Reading from registers depending on the address given from CU_EU
				case(addr)
				3'b000:  out_data <= r0;
				3'b001:  out_data <= r1;
				3'b010:  out_data <= r2;
				3'b011:  out_data <= r3;
				3'b100:  out_data <= r4;
				3'b101:  out_data <= r5;
				endcase
			end
	end
	
endmodule
