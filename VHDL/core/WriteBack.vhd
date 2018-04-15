library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity WriteBack is
	Port ( 
		I_clk : in STD_LOGIC;
		I_enable : in STD_LOGIC;
		I_reset : in STD_LOGIC;
		I_execute : in STD_LOGIC;
		I_address : in STD_LOGIC_VECTOR (4 downto 0);
		I_data : in STD_LOGIC_VECTOR (31 downto 0);

		O_address : out STD_LOGIC_VECTOR (4 downto 0);
		O_data : out STD_LOGIC_VECTOR (31 downto 0);
		O_store : out STD_LOGIC
		);
end WriteBack;

architecture Behavioral of WriteBack is

begin
process(all)
begin
	if(I_enable='1') then
		O_store<=I_execute;
		O_address<=I_address;
		O_data<=I_data;
	end if;

end process;
end Behavioral;