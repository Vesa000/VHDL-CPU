----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2018 04:40:23 PM
-- Design Name: 
-- Module Name: ProgramCounter - Behavioral
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ProgramCounter is
    Port ( I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_pause : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_operands : in STD_LOGIC_VECTOR (22 downto 0);
           O_pc : out STD_LOGIC_VECTOR (22 downto 0));
           
end ProgramCounter;

architecture Behavioral of ProgramCounter is

signal R_oldPC: STD_LOGIC_VECTOR (22 downto 0):="11111111111111111111111";
signal w_curPC: STD_LOGIC_VECTOR (22 downto 0);
signal w_isjump: STD_LOGIC := '0';
signal w_shouldjump: STD_LOGIC := '0';

signal w_pushStack: STD_LOGIC := '0';
signal w_popStack: STD_LOGIC := '0';
signal w_ReadStack: STD_LOGIC_VECTOR (22 downto 0);
signal w_WriteStack: STD_LOGIC_VECTOR (22 downto 0);

component PCstack port(
           I_clk : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_push : in STD_LOGIC;
           I_pop : in STD_LOGIC;
           I_data : in STD_LOGIC_VECTOR (22 downto 0);
           O_data : out STD_LOGIC_VECTOR (22 downto 0);
           O_sp : out integer
           );
end component;

begin

stack: PCstack port map(I_clk => I_clk,
                        I_reset=>I_reset,
                        I_push=>w_pushStack,
                        I_pop=>w_popStack,
                        I_data=>w_WriteStack,
                        O_data=>w_ReadStack,
                        O_sp=>open);

--capture old pc on rising edge
process(I_clk)
begin
    if(rising_edge(I_clk)and I_enable = '1' and I_pause = '0') then
    R_oldPC <= w_curPC;
    end if;
end process;

--do stuff
process(all)
begin
    if(i_opcode="00111" or i_opcode="01000" or i_opcode="01001") then -- JMP,BRA,RET
        w_isjump <= '1';
    else
        w_isjump<= '0';
    end if;
    
    --should jump
    if((i_condition = "0000")                     --alw
    or (i_condition = "0001" and I_status(0) ='1')--eq
    or (i_condition = "0010" and I_status(0) ='0')--neq
    or (i_condition = "0011" and I_status(1) ='1')--gt
    --or (i_condition = "0100" and I_status(1) ='1')--geq
    or (i_condition = "0101" and I_status(2) ='1')--lt
    --or (i_condition = "0110" and I_status(1) ='1')--leq
    ) then 
        w_shouldjump <='1';
    else
        w_shouldjump<='0';
    end if;
    
    w_WriteStack <= R_oldPC;
    
    if(w_shouldjump='1' and w_isjump='1') then
        if(i_opcode="01001") then--Return
            --pop stack
            w_curPC <= w_ReadStack;
            w_popStack <= '1';
        else
            w_popStack <= '0';
            w_curPC <= I_operands(22 downto 0);
            if(i_opcode="01000") then--Branch
                --push stack
                w_pushStack <= '1';
            else
                w_pushStack <= '0';
            end if;
        end if;
    else
        w_curPC <= std_logic_vector(to_unsigned(to_integer(unsigned( R_oldPC )) + 1, 23));
        --w_curPC <= R_oldPC + X"00000001";
        --w_curPC <= R_oldPC + 1;
    end if;
    
    O_pc <= w_curPC;
    
end process;

end Behavioral;
