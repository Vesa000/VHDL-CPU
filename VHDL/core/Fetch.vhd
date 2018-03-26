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
           I_pause : in STD_LOGIC;
           I_reset : in std_logic;
           I_instruction : in STD_LOGIC_VECTOR (31 downto 0);
           I_status : in STD_LOGIC_VECTOR (7 downto 0);
           O_execute : out STD_LOGIC;
           O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
           O_operands : out STD_LOGIC_VECTOR (22 downto 0);
           O_pc : out STD_LOGIC_VECTOR (22 downto 0));
end Fetch;

architecture Behavioral of Fetch is

signal R_opcode : std_logic_vector (4 downto 0);
signal R_condition : std_logic_vector (3 downto 0);
signal R_operands : std_logic_vector (22 downto 0);
signal W_execute : STD_LOGIC:='0';

component ProgramCounter port(
           I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_pause : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_operands : in STD_LOGIC_VECTOR (22 downto 0);
           O_pc : out STD_LOGIC_VECTOR (22 downto 0)
           );
end component;

begin

PC: ProgramCounter port map(
                        I_clk => I_clk,
                        I_enable=> I_enable,
                        I_pause=>I_pause,
                        I_reset=>I_reset,
                        I_execute => W_execute,
                        I_opcode=> R_opcode,
                        I_operands=> R_operands,
                        O_pc=> O_pc);

--register process
process(I_clk)
begin
    if(rising_edge(I_clk) and I_enable='1') then
        R_opcode <= I_instruction(27 downto 23);
        R_condition <= I_instruction(31 downto 28);
        R_operands <= I_instruction(22 downto 0);
    end if;
end process;

--execute check and output
process(all)
begin
    --check execute
    if((R_condition = "0000")                             --alw
    or (R_condition = "0001" and I_status(0) ='1')        --eq
    or (R_condition = "0010" and I_status(0) ='0')        --neq
    or (R_condition = "0011" and I_status(1) ='1')        --gt
    or (R_condition = "0101" and I_status(2) ='1')        --lt
    or((R_condition = "0100" and I_status(1) ='1')        --geq
        or(R_condition = "0100" and I_status(0) ='1'))
    or((R_condition = "0110" and I_status(2) ='1')        --leq
        or(R_condition = "0110" and I_status(0) ='1'))
    ) then 
        W_execute <='1';
    else
        W_execute<='0';
    end if;
    
    -- output
    O_execute  <= W_execute;
    O_opcode   <= R_opcode;
    O_operands <= R_operands;
end process;

end Behavioral;
