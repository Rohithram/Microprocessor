`timescale 1ns / 1ps
module cpu_test;
//This is the test bench for this whole processor
reg clk;
wire enableCU;

assign enableCU = 1'd1;             //To switch on the CPU
//Control cum Execution unit instantiation.
CU_EU cu_eu_UnitTest(.clk(clk),
                  .enableCU(enableCU));  

initial
    begin
    $dumpfile("cpu_wave.vcd");          //dumpfile is created for simulating in GTKWAVE
    $dumpvars(0,cpu_test);              //simulation have topmodule, so basically everything can be
                                        //viewed in it
    clk = 0;                            //clk generation
    repeat(1000)#10 clk =~clk;          
end

endmodule
