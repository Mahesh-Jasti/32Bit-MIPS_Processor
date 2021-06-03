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

ADD, SUB, AND and OR are operations which take values from Registers Rs and Rt as input, compute and write the result into another register Rd.

LDR will add value(Rs) and Offset to get the value of a data memory address whose value is loaded into the Rt register.
LDRI will load the Offset value into the Rt register.
STR will add value(Rs) and Offset to get the value of data memory address and will store the value(Rs) in that data memory address.

JEQ will update the Program Counter with the Offset value if value(Rs) == value(Rt).
JNE will update the Program Counter with the Offset value if value(Rs) != value(Rt).
