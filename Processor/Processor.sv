// Code your design here

// Processor module containing instances of Datapath and Controller
module Processor(clk,resetn);
  input clk, resetn;
  wire PCenable, InstrRead, JEQflag, JNEflag, DestReg, RegWrite, RegRead, LdrStr, MemRead, MemWrite, MemtoReg, LDRIflag;
  wire [5:0] opcode, ALUopcode;
  
  Datapath Processor_Datapath(.clk(clk), .resetn(resetn), .PCenable(PCenable), .InstrRead(InstrRead), .JEQflag(JEQflag), .JNEflag(JNEflag), .DestReg(DestReg), .RegWrite(RegWrite), .LdrStr(LdrStr), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .LDRIflag(LDRIflag), .ALUopcode(ALUopcode), .RegRead(RegRead), .opcode(opcode));
  
  Controller Processor_Controller(.clk(clk), .resetn(resetn), .PCenable(PCenable), .InstrRead(InstrRead), .JEQflag(JEQflag), .JNEflag(JNEflag), .DestReg(DestReg), .RegWrite(RegWrite), .LdrStr(LdrStr), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .LDRIflag(LDRIflag), .ALUopcode(ALUopcode), .RegRead(RegRead), .opcode(opcode));
  
endmodule

// Datapath module
module Datapath(clk, resetn, PCenable, InstrRead, JEQflag, JNEflag, DestReg, RegRead, ALUopcode, RegWrite, LdrStr, MemRead, MemWrite, MemtoReg, LDRIflag, opcode);
  
  input clk, resetn;
  input [5:0] ALUopcode;
  input PCenable, InstrRead, JEQflag, JNEflag, RegWrite, DestReg, LdrStr, MemRead, MemWrite, MemtoReg, LDRIflag, RegRead;
  output [5:0] opcode;
  
  wire [5:0] opcode;
  
  ///////// Program Counter ///////////
  wire [31:0] NextPC;
  reg [31:0] PC;
  always@(posedge clk) begin
    if(!resetn) PC <= 32'b00000000000000000000000000000000;
    else if(PCenable) PC <= NextPC;
  end
  
  assign NextPC = ((JNEflag & ~Equal) | (JEQflag & Equal)) ? {{16{Instr[15]}},Instr[15:0]}: PC + 1;
  //////////////////////////////
  
  ////////// Instruction Memory ///////////
  reg [31:0] Instruction_Mem[15:0];
  
  initial begin
    Instruction_Mem[0] = 32'b10010000000000000000000000001010;
    Instruction_Mem[1] = 32'b10010000000000010000000000000100;
    Instruction_Mem[2] = 32'b00000100000000010001011111111111;
    Instruction_Mem[3] = 32'b11111100000000000001000000000000;
  end
  
  reg [31:0] Instr;
  always@(posedge clk) begin
    if(InstrRead) Instr <= Instruction_Mem[PC];
  end
  
  assign opcode[5:0] = Instr[31:26];
  //////////////////////////////
  
  //////////// Register File ////////////
  reg [31:0] Registers[31:0];
  reg [31:0] ReadData1, ReadData2;
  reg [5:0] WriteRegister;
  wire [31:0] MemtoRegData;
  wire [31:0] ReadData2Muxed;
  
  always@(posedge clk) begin
    if(RegRead) begin
      ReadData1 <= Registers[Instr[25:21]];
      ReadData2 <= Registers[Instr[20:16]];
      WriteRegister <= DestReg? Instr[15:11]: Instr[20:16];
    end
    else if(RegWrite) begin
      Registers[WriteRegister] <= LDRIflag ? {{16{Instr[15]}},Instr[15:0]}: MemtoRegData;
    end
  end
  
  assign ReadData2Muxed = LdrStr? {{16{Instr[15]}},Instr[15:0]}: ReadData2; 
  //////////////////////////////
  
  /////////// Arithmetic and Logic Unit /////////////
  reg [31:0] ALUout, AdderOP;
  reg Equal;
  
  parameter ADD=6'b000001, SUB=6'b000010, AND=6'b000100, OR=6'b001000;
  parameter LDR=6'b100001, STR=6'b100010, LDRI=6'b100100;
  parameter JEQ=6'b111110, JNE=6'b111101;
  parameter EXIT=6'b11111;
  always@(ALUopcode or ReadData1 or ReadData2Muxed) begin
    AdderOP = ReadData1 + ReadData2Muxed;
    case(ALUopcode) 
      ADD: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      SUB: begin ALUout = ReadData1 - ReadData2Muxed; Equal = (ReadData1==ReadData2); end
      AND: begin ALUout = ReadData1 & ReadData2Muxed; Equal = (ReadData1==ReadData2); end
      OR: begin ALUout = ReadData1 | ReadData2Muxed; Equal = (ReadData1==ReadData2); end
      LDR: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      STR: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      JEQ: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      JNE: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      EXIT: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      LDRI: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
      default: begin ALUout = AdderOP; Equal = (ReadData1==ReadData2); end
    endcase
  end
  ///////////////////////////////
  
  /////////// Data Memory //////////////
  reg [31:0] DataMemory[31:0];
  reg [31:0] ReadData;
  
  always@(posedge clk) begin
    if(MemRead) begin
      ReadData <= DataMemory[ALUout];
    end
    else if(MemWrite) begin
      DataMemory[ALUout] <= ReadData2;
    end
  end
  
  assign MemtoRegData = MemtoReg ? ReadData: ALUout; 
  ///////////////////////////////
  
endmodule
  
  
  // Controller module
module Controller(opcode, clk, resetn, PCenable, InstrRead, JEQflag, JNEflag, ALUopcode, RegWrite, RegRead, DestReg, LdrStr, MemRead, MemtoReg, MemWrite, LDRIflag);
  
  input clk, resetn;
  input [5:0] opcode;
  output PCenable, InstrRead, JEQflag, JNEflag, RegWrite, RegRead, DestReg, LdrStr, MemRead, MemWrite, MemtoReg, LDRIflag;
  output [5:0] ALUopcode;
  
  reg PCenable, InstrRead, JEQflag, JNEflag, RegWrite, RegRead, DestReg, LdrStr, MemRead, MemWrite, MemtoReg, LDRIflag;
  reg [5:0] ALUopcode;
  
  reg [3:0] CurrentState, NextState;
  
  parameter RESET=4'b0000, S0=4'b0001, S1=4'b0010, S2=4'b0011, S3=4'b0100, S4=4'b0101;
  parameter S5=4'b0110, S6=4'b0111, S7=4'b1000, S8=4'b1001, S9=4'b1010, S10=4'b1011, S11=4'b1100;
  parameter HARDRESET=4'b1101;
  
  /*parameter ADD=6'b000001, SUB=6'b000010, AND=6'b000100, OR=6'b001000;
  parameter LDR=6'b100001, STR=6'b100010, LDRI=6'b100100;
  parameter JEQ=6'b111110, JNE=6'b111101;
  parameter EXIT=6'b11111;*/
  
  always@(CurrentState or opcode) begin
    case(CurrentState)  // Case statement for deciding next state
      RESET: NextState = S0;
      S0: NextState = S1;
      S1: begin
        case(opcode)
          6'b000001: NextState = S2;
          6'b000010: NextState = S2;
          6'b000100: NextState = S2;
          6'b001000: NextState = S2;
          6'b100001: NextState = S4;
          6'b100010: NextState = S4;
          6'b111110: NextState = S8;
          6'b111101: NextState = S8;
          6'b100100: NextState = S10;
          6'b111111: NextState = HARDRESET;
          default: NextState = S1;
        endcase
      end
      S2: NextState = S3;
      S3: NextState = S0;
      S4: NextState = S5;
      S5: begin
        case(opcode)
          6'b100001: NextState = S6;
          6'b100010: NextState = S7;
          default: NextState = HARDRESET;
        endcase
      end
      S6: NextState = S0;
      S7: NextState = S0;
      S8: NextState = S9;
      S9: NextState = S0;
      S10: NextState = S11;
      S11: NextState = S0;
      HARDRESET: NextState = HARDRESET;
      default: NextState = HARDRESET;
    endcase
    
    PCenable = 1'b0;
    InstrRead = 1'b0;
    JEQflag = 1'b0;
    JNEflag = 1'b0;
    ALUopcode = opcode;
    RegWrite = 1'b0;
    RegRead = 1'b0;
    LdrStr = 1'b0;
    MemRead = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
    DestReg = 1'b0;
    LDRIflag = 1'b0;
    
    case(CurrentState)  // Case statement for assigning appropriate signals based on current state
      RESET: begin
      end
      S0: begin
        PCenable = 1'b1;
        InstrRead = 1'b1;
      end
      S1: begin
        //InstrRead = 1'b1;
      end
      S2: begin
        RegRead = 1'b1;
        DestReg = 1'b1;
      end
      S3: begin
        ALUopcode = opcode;
        RegWrite = 1'b1;
        DestReg = 1'b1;
      end
      S4: begin 
        RegRead = 1'b1;
        LdrStr = 1'b1;
      end
      S5: begin
        ALUopcode = opcode;
        LdrStr = 1'b1;
      end
      S6: begin
        MemRead = 1'b1;
        MemtoReg = 1'b1;
        RegWrite = 1'b1;
        LdrStr = 1'b1;
        ALUopcode = opcode;
      end
      S7: begin
        MemWrite = 1'b1;
        LdrStr = 1'b1;
        ALUopcode = opcode;
      end
      S8: begin 
        RegRead = 1'b1;
        if(opcode==6'b111110) JEQflag = 1'b1;
        else JNEflag = 1'b1;
      end
      S9: begin
        ALUopcode = opcode;
        if(opcode==6'b111110) JEQflag = 1'b1;
        else JNEflag = 1'b1;
      end
      S10: begin
        ALUopcode = opcode;
        RegRead = 1'b1;
        LDRIflag = 1'b1;
      end
      S11: begin
        RegWrite = 1'b1;
        LDRIflag = 1'b1;
        ALUopcode = opcode;
      end
      HARDRESET: begin
      end
      default: begin
      end
    endcase
  end
        
  always@(posedge clk) begin
    if(!resetn) CurrentState <= RESET;
    else CurrentState <= NextState;
  end
  
endmodule
      
      
          