----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2018 05:34:40 PM
-- Design Name: 
-- Module Name: Execute - Behavioral
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

entity Execute is
    Port ( I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_operands : in STD_LOGIC_VECTOR (22 downto 0);
           I_regA : in STD_LOGIC_VECTOR (31 downto 0);
           I_regB : in STD_LOGIC_VECTOR (31 downto 0);
           O_execute : out STD_LOGIC;
           O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
           O_address : out STD_LOGIC_VECTOR (4 downto 0));
end Execute;

architecture Behavioral of Execute is

begin


end Behavioral;
