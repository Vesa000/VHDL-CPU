----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2018 05:55:11 PM
-- Design Name: 
-- Module Name: Registers - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
    Port ( 
           I_clk : in STD_LOGIC;
           i_we : in STD_LOGIC;                           -- write enable
           I_data : in  STD_LOGIC_VECTOR (31 downto 0);   -- Data to write to reg
           O_dataA : out STD_LOGIC_VECTOR (31 downto 0);
           O_dataB : out STD_LOGIC_VECTOR (31 downto 0);
           I_store : in STD_LOGIC_VECTOR (4 downto 0);
           I_readA : in STD_LOGIC_VECTOR (4 downto 0);
           I_readB : in STD_LOGIC_VECTOR (4 downto 0));
end Registers;

architecture Behavioral of Registers is
    type store_t is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs: store_t := (others => X"00000000");
begin
    process(all)
    begin
        if rising_edge(I_clk) then               
            if(I_we = '1') then
                regs(to_integer(unsigned(I_store))) <= I_data;
            end if;
        end if;
        
            --Write reg to O_dataA
            if(i_readA = "00000") then
                o_dataA <= X"00000000"; --reg 0 is 00000000
            else
                O_dataA <= regs(to_integer(unsigned(I_readA)));
            end if;
            
            --Write reg to O_dataB
            if(i_readB="00000") then
                o_dataB <= X"00000000"; --reg 0 is 00000000
            else
                O_dataB <= regs(to_integer(unsigned(I_readB)));
            end if;

    end process;
end Behavioral;
