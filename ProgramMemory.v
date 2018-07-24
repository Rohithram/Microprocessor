`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:20 10/31/2017 
// Design Name: 
// Module Name:    InstructionMEM 
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
module InstructionMemory (input wire	clk,
		input wire	[6:0]	addr,
		input wire	rd,
		output wire	[15:0]	rdata);

	//Maximum 128 lines of instructions with each 0f 16bits.
	//READ ONLY MEMORY
    parameter max_instruc = 128, width = 16;
	reg [width-1:0] mem [0:max_instruc-1];  

	//Instruction is of 16 bit wide.
	//LSB of instruction is used for stopping the program
	//so if LSB is 1 it is the last instruction.
	//so otherwise LSB should be zero.

	//writing instructions to memory through binary file created assembler.py by compiling programs
	always@(posedge clk)begin							
		$readmemb("instructions.dat", mem,0,12);	// 0-12 is the no of instructions of a program
	end												//should be changed manually

	// //1 . Program to find factorial of number n!
	// mem[7'd0] = 16'b1001000000000000; 	//Ldi r0,#0
	// mem[7'd1] = 16'b1001001000001100; 	//Ldi r1,#6
	// mem[7'd2] = 16'b1001010000000010; 	//Ldi r2,#1
	// mem[7'd3] = 16'b1100011001000000;   //Mov r3,r1  //opcode = 1100
	// mem[7'd4] = 16'b1100101001000000;   //Mov r5,r1  //opcode = 1100
	// // mem[7'd5] = 16'b0001001001010000;   //sub r5,r1,r2 	
	// mem[7'd5] = 16'b0001100001010000;   //sub r4,r1,r2 
	// mem[7'd6] = 16'b0000011011101000;   //Add r3,r3,r5 
	// mem[7'd7] = 16'b0001100100010000;   //sub r4,r4,r2 
	// mem[7'd8] = 16'b1101100000011000;   //CMP r4,r0       //OPcode = 1101	
	// mem[7'd9] = 16'b1110000110100000;   //BE #address(13) //OPcode = 1110
	// mem[7'd10] = 16'b1101100010011000;   //CMP r4,r2       //OPcode = 1101	
	// mem[7'd11] = 16'b1111000011100000;   //BNE #address(7) //OPcode = 1111
	// mem[7'd12] = 16'b1100101011110000;  //Mov r5,r3  //opcode = 1100
	// mem[7'd13] = 16'b0001001001010000;  //sub r1,r1,r2 
	// mem[7'd14] = 16'b1101001010011000;  //CMP r1,r2     //OPcode = 1101
	// mem[7'd15] = 16'b1111000011000000; 	//BNE #address(6) //OPcode = 1111
	// mem[7'd16] = 16'b1011101000000101;  //str r5,#01 

	// //2 . Program to store nth fibonacci number in the memory excluding 0 and 1.
	// mem[7'd0] = 16'b1001000000000000; 	//Ldi r0,#0
	// mem[7'd1] = 16'b1001001000000010; 	//Ldi r1,#1
	// mem[7'd2] = 16'b1001100000010000; 	//Ldi r4,#8
	// mem[7'd3] = 16'b1100011001000000;   //Mov r3,r1  //opcode = 1100
	// mem[7'd4] = 16'b1100010000000000;   //Mov r2,r0  //opcode = 1100
	// mem[7'd5] = 16'b0000101011000010;   //add r5,r3,r0 	
	// mem[7'd6] = 16'b0001100100001000;   //sub r4,r4,r1
	// mem[7'd7] = 16'b1100000011000000;   //Mov r0,r3  //opcode = 1100
	// mem[7'd8] = 16'b1100011101000000;   //Mov r3,r5  //opcode = 1100
	// mem[7'd9] = 16'b1101100010011000;   //CMP r4,r2       //OPcode = 1101
	// mem[7'd10] = 16'b1111000010100000; 	//BNE #address(5) //OPcode = 1111
	// mem[7'd11] = 16'b1011101000000100;  //str r5,#01 
	// mem[7'd12] = 16'b1010001000001001; 	//Ld r1,#01(mem_Address)
	
	// mem[7'd8] = 16'b1110000101000000;   //Branch #address(10) //Opcode = 1110 (Unconditional)
	// mem[7'd9] = 16'b0000001010011000;   //Add r1,r2,r3 
	// mem[7'd10] = 16'b1001011000000100; 	//Ldi r3,#2
	// mem[7'd14] = 16'b0001100010011000;   //sub r4,r2,r3 
	// mem[7'd15] = 16'b0000100100011001;   //Add r4,r4,r3 
	
		assign rdata = (rd)? mem[addr]: 1'd0;
endmodule
