library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.cpu_constants.all;

entity Mem_WriteBack is Port ( 
		I_clk : in STD_LOGIC;
		I_enable : in STD_LOGIC;
		I_reset : in STD_LOGIC;
		I_execute : in STD_LOGIC;
		I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
		I_address : in STD_LOGIC_VECTOR (4 downto 0);
		I_data : in STD_LOGIC_VECTOR (31 downto 0);
		I_memData : in STD_LOGIC_VECTOR (31 downto 0);

		O_address : out STD_LOGIC_VECTOR (4 downto 0);
		O_data : out STD_LOGIC_VECTOR (31 downto 0);
		O_store : out STD_LOGIC
		);
end Mem_WriteBack;

architecture Behavioral of Mem_WriteBack is

signal R_opcode: std_logic_vector(4 downto 0);
signal R_store: std_logic;
signal R_address: std_logic_vector(4 downto 0);
signal R_data: std_logic_vector(31 downto 0);

begin
process(all)
begin
	if(rising_edge(I_clk)) then
		R_opcode<=I_opcode;
		R_store<=I_execute;
		R_address<=I_address;
		R_data<=I_data;
	end if;
end process;

process(all)
begin
	if(I_enable='1') then
		O_store<=R_store;
		O_address<=R_address;
		if(R_opcode = OPCODE_LDR) then
			O_data <= I_memData;
		else
			O_data <= R_data;
		end if;
	end if;
end process;

end Behavioral;