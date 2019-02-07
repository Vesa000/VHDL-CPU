# VHDL-Processor
This is a 32bit processor for Arty A7 board.

### Architecture
<p align="center">
<img align="center" src="https://i.imgur.com/kyv1L7P.png">
</p>
The processor has 4 stage pipeline:<br/>
- Fetch - reads the next instruction and passes it to Decode stage and moves PC according to instructions.<br/>
- Decode - reads registers needed for the instruction.<br/>
- Execute - Excecutes all instruction except for the jump instructions.<br/>
- Write Back - Stores the values from Execute or memory into registers according to instruction.<br/>

The processor can excecute 1 instruction per clock cycle except for when conditional instruction comes directly after compare instruction.
This will cause the instruction to wait so that the comparison can reach excecute stage and update compare registers.

### Machine instructions
Instructions follow the format below:
<p align="center">
<img align="center" src="https://i.imgur.com/n77xAZo.png">
</p>
 - Bits 28-31 tell the Execute Under which condition the instruction should be executed<br/>
 - Bits 23-27 tell which instruction should be executed<br/>
 - Bits 0-22 Hold instruction specific data for the execute step.<br/>

#### Conditions
Conditions tell under which condition the instruction should be executed.

|Value|Condition|Behavior|
|------|-----------|--------|
|0|ALW|Always execute|
|1|EQ|Execute when comparison returned equals|
|2|NEQ|Execute when comparison returned not equals|
|3|GT|Execute when comparison returned greater than|
|4|GEQ|Execute when comparison returned greater or equals|
|5|LT|Execute when comparison returned less than|
|6|LEQ|Execute when comparison returned less or equals|
|15|NOP|Do not execute|

#### Memory Map
Ram I/O and Uart are all mapped into memory and can be accessed with Load and Store instructions

|Address|Location|
|------|---------|
|0-65535|Ram|
|0|Program start instruction|
|65536|Uart Data|
|65537|Uart Status|
|65538-65552|I/O|
|65538|Buttons|
|65539|Switches|
|65540|Leds|
|65541-65552|RGB-Leds|

#### ALU Instructions
Alu instructions have Alu instruction field on bits 0-3 that determines which instruction is excecuted.

|Value|Name|Behavior|
|-----|----|--------|
|0000|ADD|Register A + Register B into Register Q|
|0001|SUB|Register A - Register B into Register Q|
|0010|DIV|Register A / Register B into Register Q|
|0011|MUL|Register A * Register B into Register Q|
|0100|CMP|Sets Equals, Greater than and Less than flags for conditional instructions|


### Assembly Instructions
|Instruction|Usage|Behaviour|
|-----------|-----|---------|
|LDV|LDV 1 2|Load value 1 to register 2|
|LDR|LDR 1 2|Load memory address 1 to register 2|
|STR|STR 1 2|Store register 1 to memory address 2|
|MOV|MOV 1 2|Move value from register 1 to register 2|
|JMP|JMP LABEL|Jump to label|
|BRA|BRA LABEL|Jump to label and store Program Counter to stack|
|RET|RET| Load value from stack to PC|
|ADD|ADD 1 2 3|Reg 3 = reg1 + reg 2|
|SUB|SUB 1 2 3|Reg 3 = reg1 - reg 2|
|MUL|MUL 1 2 3|Reg 3 = reg1 * reg 2|
|DIV|DIV 1 2 3|Reg 3 = reg1 / reg 2|
|CMP|CMP 1 2|Compare reg 1 to reg 2|
|NOP|NOP|Do nothing|
|HLT|HLT|Stop|

### Example code
Following code writes Fibonacci sequence to Uart

```
	LDV	0	1		// i
	LDV	1	2		// j

FIBONACCI:
	ADD	1	2	3	//k=i+j
	MOV	2	1		//i=j
	MOV	3	2		//j=k

	MOV	2	10		//Write j
	BRA PRINT
	LDV	10	10		//Write \n
	BRA PRINT
	LDV	13	10		//Write \r
	BRA PRINT
	JMP	FIBONACCI

PRINT:
	LDR	65537	4	// Uart status to reg 4
	LDV	1	5		// Uart Ready value to reg 5
	CMP	4	5
NEQ	JMP	PRINT		// Wait untill uart is ready
	STR	10	65536	// Write reg 10 to uart
	RET
```