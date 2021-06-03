# 32Bit-MIPS_Processor

Designed a 32 bit processor based on design from the book "Computer Organisation and Design" by Dr.Patterson and Dr.Hennessy. 
Also designed an Assembler to convert my own proposed language into Machine code (Binary) for ease in testing the processor.

The micro architecture and instruction set are inspired from the book but have been modified in order to accommodate a total of 10 instructions that can be run on this processor.
Insturctions are 32 bits long and they are:
1) ADD -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
2) SUB -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
3) AND -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
4) OR  -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
5) LDR -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
6) STR -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
7) LDRI - { Opcode(bits 31:26), Don't-care(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
8) JEQ -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
9) JNE -  { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
10) EXIT - { Opcode(bits 31:26), Don't-care(bits 25:0) }
Opcodes have been parametrised in the code.  
