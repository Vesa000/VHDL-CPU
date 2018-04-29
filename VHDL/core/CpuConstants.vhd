----------------------------------------------------------------------------------
-- Project Name: 
-- Description: Constants for instruction forms, opcodes, conditional flags, etc.
-- 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package cpu_constants is

--constant ADDR_RESET:    std_logic_vector(15 downto 0) :=  X"0000";
--constant ADDR_INTVEC:   std_logic_vector(15 downto 0) :=  X"0008";

-- Opcodes
constant OPCODE_LDV:    std_logic_vector(4 downto 0)    :=  "00001";	-- Load value
constant OPCODE_LDR:    std_logic_vector(4 downto 0)    :=  "00010";	-- Load ram
constant OPCODE_STR:    std_logic_vector(4 downto 0)    :=  "00011";	-- Store register
constant OPCODE_MOV:    std_logic_vector(4 downto 0)    :=  "00100";	-- Move register
constant OPCODE_JMP:    std_logic_vector(4 downto 0)    :=  "00111";	-- Jump
constant OPCODE_BRA:    std_logic_vector(4 downto 0)    :=  "01000";	-- Branch
constant OPCODE_RET:    std_logic_vector(4 downto 0)    :=  "01001";	-- Return
constant OPCODE_ALU:    std_logic_vector(4 downto 0)    :=  "01010";	-- Alu
constant OPCODE_NOP:    std_logic_vector(4 downto 0)    :=  "00000";    -- No operation
constant OPCODE_HLT:    std_logic_vector(4 downto 0)    :=  "11111";	-- halt 

constant ALUCODE_ADD: std_logic_vector(3 downto 0) := "0000";
constant ALUCODE_SUB: std_logic_vector(3 downto 0) := "0001";
constant ALUCODE_DIV: std_logic_vector(3 downto 0) := "0010";
constant ALUCODE_MUL: std_logic_vector(3 downto 0) := "0011";
constant ALUCODE_CMP: std_logic_vector(3 downto 0) := "0100";

-- Instruction Form Offsets
constant IFO_OPCODE_BEGIN: integer := 27;
constant IFO_OPCODE_END:   integer := 23;

constant IFO_COND_BEGIN: integer := 31;
constant IFO_COND_END:   integer := 28;

constant IFO_REGA_BEGIN: integer := 22;
constant IFO_REGA_END:   integer := 18;

constant IFO_REGB_BEGIN: integer := 17;
constant IFO_REGB_END:   integer := 13;

constant IFO_REGQ_BEGIN: integer := 12;
constant IFO_REGQ_END:   integer := 8;

constant IFO_ALUINS_BEGIN: integer := 3;
constant IFO_ALUINS_END:   integer := 0;

constant IFO_PC_BEGIN: integer := 22;
constant IFO_PC_END:   integer := 0;

constant IFO_ADDR_BEGIN: integer := 17;
constant IFO_ADDR_END:   integer := 0;

constant IFO_VAL_BEGIN: integer := 17;
constant IFO_VAL_END:   integer := 0;

-- Condition flags
constant COND_ALW: std_logic_vector(3 downto 0):= "0000";
constant COND_EQ : std_logic_vector(3 downto 0):= "0001";
constant COND_NEQ: std_logic_vector(3 downto 0):= "0010";
constant COND_GT : std_logic_vector(3 downto 0):= "0011";
constant COND_GEQ: std_logic_vector(3 downto 0):= "0100";
constant COND_LT : std_logic_vector(3 downto 0):= "0101";
constant COND_LEQ: std_logic_vector(3 downto 0):= "1010";

-- Status bits
constant STATUS_EQ: integer := 0;
constant STATUS_GT: integer := 1;
constant STATUS_LT: integer := 2;


-- Memory mappings
constant MEM_RAM_END: integer := 65535;
constant MEM_PROGRAM_START: integer := 0;

constant MEM_UART_DATA: integer := 65536;
constant MEM_UART_STATUS: integer := 65537;
constant UART_AVAILABLE_BIT: integer := 1;
constant UART_TXRDY_BIT: integer := 0;

end cpu_constants;
package body cpu_constants is
end cpu_constants;