----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2018 09:59:35 PM
-- Design Name: 
-- Module Name: Fetch - Behavioral
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

entity Fetch is
    Port ( I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_pause : in STD_LOGIC;
           I_instruction : in STD_LOGIC_VECTOR (31 downto 0);
           I_status : in STD_LOGIC_VECTOR (31 downto 0);
           O_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           O_condition : in STD_LOGIC_VECTOR (3 downto 0);
           O_operands : in STD_LOGIC_VECTOR (22 downto 0));
end Fetch;

architecture Behavioral of Fetch is

begin


end Behavioral;
