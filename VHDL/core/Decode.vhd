library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.cpu_constants.all;

--use IEEE.NUMERIC_STD.ALL;

entity Decode is
	Port ( 
		I_clk : in STD_LOGIC;
		I_enable : in STD_LOGIC;
		I_reset : in STD_LOGIC;
		I_pause : in STD_LOGIC;
		I_execute : in STD_LOGIC;
		I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
		I_operands : in STD_LOGIC_VECTOR (22 downto 0);
		O_execute : out STD_LOGIC;
		O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
		O_operands : out STD_LOGIC_VECTOR (22 downto 0);
		O_readA : out STD_LOGIC_VECTOR (4 downto 0);
		O_readB : out STD_LOGIC_VECTOR (4 downto 0)
		);
end Decode;

architecture Behavioral of Decode is

signal R_operands: std_logic_vector(22 downto 0):="00000000000000000000000";
signal R_execute: std_logic:='0';
signal R_opcode: STD_LOGIC_VECTOR (4 downto 0):="00000";

begin
process(all)
begin

	if(rising_edge(I_clk) and I_enable='1') then
		R_operands<=I_operands;
		R_execute<= I_execute;
		R_opcode<= I_opcode;
	end if;
end process;

process(all)
begin
	O_execute <= R_execute;
	O_operands<=R_operands;
	O_opcode<=R_opcode;

	if(R_opcode=OPCODE_STR or R_opcode=OPCODE_MOV or R_opcode=OPCODE_ALU) then
		O_readA<=R_operands(22 downto 18);
	else
		O_readA<="00000";
	end if;

	if(R_opcode=OPCODE_MOV or R_opcode=OPCODE_ALU) then
		O_readB<=R_operands(17 downto 13);
	else
		O_readB<="00000";
	end if;

end process;
end Behavioral;
