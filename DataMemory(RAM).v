`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:04 10/10/2017 
// Design Name: 
// Module Name:    DM 
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
//This is the 128 bytes memory  to store data and read data for loading onto registers
module DataMemory(input wire			clk,
		input wire	[6:0]	addr,
		input wire rd, wr,
		input wire 	[7:0]	wdata,
		output reg [7:0]	rdata);

	parameter mem_size = 128, width = 8;	//128 bytes memory each of 8 bit width
	reg [width-1:0] mem [0:mem_size-1];  

	always @(posedge clk) begin				//write or Read happens positive edge of clk
		if (wr) begin
			mem[addr] <= wdata;				
		end
	end
	// During a write, avoid the one cycle delay by reading from 'wdata'
	always @* begin
		if(rd) begin
			rdata <= mem[addr];
		end	
	end			
	
endmodule
