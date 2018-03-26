----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2018 06:26:27 PM
-- Design Name: 
-- Module Name: WriteBack - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WriteBack is
    Port ( I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_address : in STD_LOGIC_VECTOR (4 downto 0);
           I_data : in STD_LOGIC_VECTOR (31 downto 0);
           O_address : out STD_LOGIC_VECTOR (4 downto 0);
           O_data : out STD_LOGIC_VECTOR (31 downto 0);
           O_store : out STD_LOGIC);
end WriteBack;

architecture Behavioral of WriteBack is

signal w_store:STD_LOGIC:='0';
signal w_opcode:STD_LOGIC_VECTOR (4 downto 0):="00000";

begin
process(all)
begin
if(rising_edge(I_clk) and I_enable='1') then
    w_store<=I_execute;
    w_opcode<=I_opcode;
    O_address<=I_address;
    O_data<=I_data;
end if;

    --       LDV                  LDR                 MOV                ALU
if(W_opcode="00001" or W_opcode="00010" or W_opcode="00100" or W_opcode="01010") then
    O_store<=W_store;
else
    O_store<='0';
end if;

end process;

end Behavioral;
