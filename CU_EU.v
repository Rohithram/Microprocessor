`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:56 10/17/2017 
// Design Name: 
// Module Name:    CU 
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
module CU_EU(input wire clk, input wire enableCU);

	//control cum Execution unit
	
	output reg [6:0] pc;					//program counter [7 bit address]
	output reg Load,Store,Read,Write;		//status signals like read write load store
	parameter fetch = 0, decode = 1, fetch_operand = 2, execute = 3, store = 4;	//these are the states
	// totally 5 states, parameters are used for readability.

	reg [2:0]state;
	reg enable,Cmpflag;
	wire [15:0] instruction;
	reg [3:0] op_code;
	reg [2:0] Rdes,Ra,Rb,register_addr;
	reg [7:0] Direct_Input;
	wire [7:0] register_oper,oper3_w,oper1_w;
	reg [7:0] oper1,oper2,oper3,register_in;
	reg [6:0] src_addr,mem_address,des_addr;

	initial begin
		state = fetch;
		pc = 7'd0;
		Cmpflag = 1'd0;
		enable <= 1'd0;			//ALu is intially switched off
	end

	//Connecting CU_EU with program memory
	InstructionMemory instruc_mem(.clk(clk),
			.addr(pc),					//address of instruction
			.rd(1'd1),
			.rdata(instruction));		//output		

	//Connecting CU_EU with internal memory (6 Registers R0-R5)		
	InternalMemory internal_mem(.addr(register_addr),
					.wr(Write),
					.rd(Read),
					.in_data(register_in),
					.out_data(register_oper));

	always@*begin
		op_code <= instruction[15:12];
	end	

	//Connecting CU_EU with ALU
	ALU alu (
		.enable(enable),
		.fn_sel(op_code), 
		.a(oper1), 
		.b(oper2),
		.out(oper3_w), 
		.cmpflag(Cmpflag)
	);

	DataMemory data_mem(.clk(clk),
				.addr(mem_address),
				.rd(Read),
				.wr(Write),
				.wdata(oper1),
				.rdata(oper1_w));

	always@(posedge (clk*enableCU))begin
		case(state)
		fetch:
			begin
				Read = 1'd1;
				Write = 1'd0;
				Load = 1'd0;
				Store = 1'd0;
				state <= state+1;
				
			end	
		decode:
			begin
				op_code <= instruction[15:12];
				if(op_code[3]==1'd0)begin
					//Alu operation
					if(op_code[3:1]!=3'b011)begin
						Rdes <= instruction[11:9];
						Ra <= instruction[8:6];
						Rb <= instruction[5:3];
					end
					else begin
						Ra <= instruction[11:9];
					end		
				end
				else if(op_code[3:1]==3'b110)begin
					//Mov and CMP
					Load <= 1'd0;
					Read <= 1'd1;
					Write <= 1'd0;
					Store <= 1'd0;
					//ra <- rb and ra-rb
					Ra <= instruction[11:9];
					Rb <= instruction[8:6];				
				end
				else if(op_code==4'b1001)begin
					//LoadImediate
					//ra <- #number
					Ra <= instruction[11:9];
					Direct_Input <= instruction[8:1];			

				end
				else if(op_code==4'b1010)begin
					//Load
					//ra <- #mem_address
					Ra <= instruction[11:9];
					src_addr <= instruction[8:2];
				end
				else if(op_code==4'b1011)begin
					//Store
					Ra <= instruction[11:9];
					des_addr <= instruction[8:2];
				end
				else if(op_code[3:1]==3'b111)begin
					//BE and BNE
					des_addr <= instruction[11:5];
					state <= execute;
				end	
				if(op_code[3:1]!=3'b111)begin
					state <= state+1;
				end
			end
		fetch_operand:
			begin
				Read <= 1'd1;
				Write <= 1'd0;
				Load <= 1'd0;
				Store <= 1'd0;
	 			if(op_code[3]==1'd0)begin
				 //ALU
				 	if(op_code[3:1]!=3'b011)begin
						register_addr <= Rdes;
						#1oper3 <= register_oper;
						register_addr <= Ra;
						#1oper1 <= register_oper;
						register_addr <= Rb;
						#1oper2 <= register_oper;
					end
					else begin
						register_addr <= Ra;
						#1oper1 <= register_oper;
					end	
				end
				else if(op_code[3:1]==3'b110)begin
					//Mov or CMP
					//ra <- rb or ra-rb
					register_addr <= Ra;
					#1oper1 <= register_oper;
					register_addr <= Rb;
					#1oper2 <= register_oper;
				end
				else begin
					//Load,LDI,Store
					register_addr <= Ra;
					oper1 <= register_oper;
				end
				state <= state+1;		
			end
		execute:
			begin
				if(op_code[3]==1'd0)begin
					enable <= 1'd1;	
					if(op_code[3:1]!=3'b011)begin			//ALU is now turned ON
						oper3 <= oper3_w;
					end
					else begin
						oper1 <= oper3_w;					//For Dec and Inc 
					end		
				end
				else if(op_code==4'b1001)begin
					//LoadImediate
					//ra <- #number
					enable <= 1'd0;
					Write <= 1'd0;
					Read <= 1'd1;
					Store <= 1'd0;
					Load <= 1'd1;

					oper1 <= Direct_Input;
				end
				else if(op_code==4'b1010)begin
					//Load
					//ra <- #memaddress
					enable <= 1'd0;					
					Write <= 1'd0;
					Read <= 1'd1;
					Store <= 1'd0;
					Load <= 1'd1;
					mem_address <= src_addr;
					
				end
				else if(op_code==4'b1011)begin
					//Store
					Write <= 1'd1;
					Read <= 1'd0;
					Store <= 1'd1;
					Load <= 1'd0;
					enable <= 1'd0;					
					mem_address <= des_addr;

				end
				else if(op_code==4'b1100)begin
					//Mov
					//ra <- rb
					oper1 <=  oper2;
					enable <= 1'd0;
					
				end
				else if(op_code==4'b1101)begin
					//CMP
					//ra-rb
					enable <= 1'd0;
					
					if(oper1 == oper2)begin
						Cmpflag <= 1'd0;
					end
					else begin
						Cmpflag <= 1'd1;
					end		
					
				end
				else if(op_code==4'b1110)begin
					//BranchifEqual
					Write <= 1'd0;
					Read <= 1'd0;
					Store <= 1'd0;
					Load <= 1'd0;
					enable <= 1'd0;

					if(Cmpflag == 1'd0)begin
						pc <= des_addr;
						state <= fetch;
					end	
					else begin
						pc <= pc+1;
						state <= fetch;
					end	
			
				end	
				else if(op_code==4'b1111)begin
					//BNE
					Write <= 1'd0;
					Read <= 1'd0;
					Store <= 1'd0;
					enable <= 1'd0;
					Load <= 1'd0;
					if(Cmpflag == 1'd1)begin
						pc <= des_addr;
						state <= fetch;
					end	
					else begin
						pc <= pc+1;
						state <= fetch;
					end	
				end	
				
				if(op_code[3:1]!=3'b111)begin
					state <= state+1;
				end
		end
		store:
			begin
				if(op_code[3]==1'd0)begin
					//ALU
					enable <= 1'd0;
					Write <= 1'd1;
					Read <= 1'd0;
					Store <= 1'd0;
					Load <= 1'd0;
					if(op_code[3:1]!=3'b011)begin
						register_addr <= Rdes;
						register_in <= oper3_w;
					end
					else begin
						register_addr <= Ra;
						register_in <= oper3_w;
					end		

				end
				else if(op_code==4'b1100)begin
					//Mov
					//ra <- rb
					Write <= 1'd1;
					Read <= 1'd0;
					Store <= 1'd0;
					Load <= 1'd0;
					register_addr <= Ra;
					register_in <= oper1;

				end
				else if(op_code==4'b1001)begin
					//LoadImediate
					//ra <- #number
					Write <= 1'd1;
					Read <= 1'd0;
					Store <= 1'd0;
					Load <= 1'd1;
					register_addr <= Ra;
					register_in <= oper1;
				end
				else if(op_code==4'b1010)begin
					//Load
					//ra <- #memaddress
					Write <= 1'd1;
					Read <= 1'd0;
					Store <= 1'd0;
					Load <= 1'd1;
					register_addr <= Ra;
					register_in <= oper1;					
				end

				if(instruction[0]==1'd0)begin
					pc <= pc+1;
					state <= fetch;
				end
				
			end
		endcase
	end		 
		
endmodule
