The micro architecture and instruction set are inspired from the book but have been modified in order to accommodate a total of 10 instructions that can be run on this processor. Insturctions are 32 bits long and they are:

ADD - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
SUB - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
AND - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
OR - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Rd(bits 15:11), Don't-care(bits 10:0) }
LDR - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
STR - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
LDRI - { Opcode(bits 31:26), Don't-care(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
JEQ - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
JNE - { Opcode(bits 31:26), Rs(bits 25:21), Rt(bits 20:16), Offset(bits 15:0) }
EXIT - { Opcode(bits 31:26), Don't-care(bits 25:0) } Opcodes have been parametrised in the code.
