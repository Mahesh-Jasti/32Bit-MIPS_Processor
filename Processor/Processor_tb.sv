// Code your testbench here
// or browse Examples
module tb;
  reg clk, resetn;
  //reg [31:0] Instruction_Mem[15:0];
  
  Processor X(.clk(clk), .resetn(resetn));
  
  initial begin
    assign clk = 1'b0;
    repeat(100)
      #1 assign clk = ~clk;
  end
  
  initial begin
    $dumpfile("Processor.vcd");
    $dumpvars(0,tb);
  end
  
  /*initial begin
    Instruction_Mem[0] = 32'b10010000000000000000000000001010;
    Instruction_Mem[1] = 32'b10010000000000010000000000000100;
    Instruction_Mem[2] = 32'b00000100000000010001011111111111;
    Instruction_Mem[3] = 32'b11111100000000000000000000000000;
  end*/
  
  initial begin
    resetn = 1'b0;
    #5 resetn = 1'b1;
    #40 resetn = 1'b0;
  end
  
  initial begin
    #50 $finish;
  end
  
endmodule