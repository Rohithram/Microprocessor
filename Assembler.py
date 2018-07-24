import numpy as np       
from sys import stdin 
#List of operations
add = {'fn': "ADD",'opcode': "0000"}
sub = {'fn': "SUB",'opcode': "0001"}
And = {'fn': "AND",'opcode': "0010"}
Or = {'fn': "OR",'opcode': "0011"}
Ls = {'fn': "LS",'opcode': "0100"}
Rs = {'fn': "RS",'opcode': "0101"}
Dec = {'fn':"DEC",'opcode': "0110"}
Inc = {'fn':"INC",'opcode': "0111"}
Mov = {'fn': "MOV",'opcode': "1100"}
Ld = {'fn': "LD",'opcode': "1010"}
Ldi = {'fn': "LDI",'opcode': "1001"}
Str = {'fn': "STR",'opcode': "1011"}
Cmp = {'fn': "CMP",'opcode': "1101"}
BE = {'fn': "BE",'opcode': "1110"}
BNE = {'fn': "BNE",'opcode': "1111"}
fn_list = [add,sub,And,Or,Ls,Rs,Dec,Inc,Mov,Ld,Ldi,Str,Cmp,BE,BNE]

program = np.loadtxt('Program.txt', dtype='S100',delimiter='\n') 

instr =[]
instructions = []

for i in range(len(program)):
    
    instr = program[i].strip().split(' ')
    func = instr[0]
    if(func.lower() != 'end'):
        for j in range(len(fn_list)):
            if(func.lower() == fn_list[j]['fn'].lower()):
                instructions.append(fn_list[j]['opcode'])

        print instructions[i][0:3]+"FEF"
        if(int(instructions[i][0:3])!=format(3,'03b')):
            args = instr[1].strip().split(',')
            for k in range(len(args)):
                if(args[k][0].lower()=='r'):
                    for index in range(6):
                        if(int(args[k][1]) == index):
                            instructions[i] = instructions[i]+format(index,'03b')
                elif(args[k][0].lower()=='@'):                      #for giving address as argument (give in decimal)
                    instructions[i]+=format(int(args[k][1:]), '07b')
                elif(args[k][0].lower()=='$'):                      #for giving direct values as argument (give in decimal)
                    instructions[i]+=format(int(args[k][1:]),'08b')  

        for h in range(16-len(instructions[i])):
                instructions[i]+='0'

        print instructions[i]        

    elif(func.lower() =='end'):
        instructions[i-1] = instructions[i-1][:15] + '1'
     

programfile = open('instructions.dat', 'w')
for instuct in instructions:
    programfile.write("%s\n" % instuct)
    