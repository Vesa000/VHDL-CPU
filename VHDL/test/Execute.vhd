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
use IEEE.NUMERIC_STD.ALL;
library work;
use work.cpu_constants.all;
   
  

entity Execute is
    Port ( I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_operands : in STD_LOGIC_VECTOR (22 downto 0);
           I_regA : in STD_LOGIC_VECTOR (31 downto 0);
           I_regB : in STD_LOGIC_VECTOR (31 downto 0);
           O_pausePrevious : out STD_LOGIC;
           O_execute : out STD_LOGIC;
           O_address : out STD_LOGIC_VECTOR (4 downto 0);
           O_data : out STD_LOGIC_VECTOR (31 downto 0);
           O_status:out STD_LOGIC_VECTOR (7 downto 0));

end Execute;

architecture Behavioral of Execute is

signal R_status: STD_LOGIC_VECTOR (7 downto 0):="00000000";

signal R_execute: std_logic:='0';
signal R_oldDataValid: std_logic:='0';
signal R_olderDataValid: std_logic:='0';

signal R_opcode: std_logic_vector(4 downto 0);
signal R_operands: std_logic_vector(22 downto 0);
signal R_halt: std_logic:='0';

signal R_regDataA: std_logic_vector(31 downto 0);
signal R_regDataB: std_logic_vector(31 downto 0);

signal R_regDataOld: std_logic_vector(31 downto 0);
signal R_regAddrOld: std_logic_vector(4 downto 0);

signal R_regDataOlder: std_logic_vector(31 downto 0);
signal R_regAddrOlder: std_logic_vector(4 downto 0);

signal W_dataA: std_logic_vector(31 downto 0);
signal W_dataB: std_logic_vector(31 downto 0);


begin

regProcess :process(all)
begin
    if(rising_edge(I_clk) and I_enable='1' and R_halt='0') then
        --update status
        O_status<=R_status;
        
        --set values from last instruction to old and older
        
        R_regDataOlder<=R_regDataOld;
        R_regAddrOlder<=R_regAddrOld;
        R_olderDataValid<=R_oldDataValid;
        R_regDataOld<= O_data;
        R_regAddrOld<= O_address;
        R_oldDataValid<=O_execute;
        
        --get new instruction
        R_execute<=I_execute;
        R_opcode<=I_opcode;
        R_operands<=I_operands;
        R_regDataA<=I_regA;
        R_regDataB<=I_regB;
    end if;
end process;

ExecuteProcess :process(all)
begin



    if(R_operands(IFO_REGA_BEGIN downto IFO_REGA_END)=R_regAddrOld and R_oldDataValid='1') then
        W_dataA<=R_regDataOld;
    elsif(R_operands(IFO_REGA_BEGIN downto IFO_REGA_END)=R_regAddrOlder and R_olderDataValid='1') then
        W_dataA<=R_regDataOlder;
    else
        W_dataA<=R_regDataA;
    end if;
    
    if(R_operands(IFO_REGB_BEGIN downto IFO_REGB_END)=R_regAddrOld) then
        W_dataB<=R_regDataOld;
    elsif(R_operands(IFO_REGB_BEGIN downto IFO_REGB_END)=R_regAddrOlder and R_olderDataValid='1') then
        W_dataB<=R_regDataOlder;
    else
        W_dataB<=R_regDataB;
    end if;


    case R_opcode is
    
        --load value
        when OPCODE_LDV =>
            O_data(17 downto 0)<= R_operands(IFO_VAL_BEGIN downto IFO_VAL_END);
            O_data(22 downto 18)<="00000";
            O_address<= R_operands(IFO_REGA_BEGIN downto IFO_REGA_END);
            O_execute<= '1';
            O_pausePrevious<='0';
            R_halt<= '0';
            
        --load ram    
        --when OPCODE_LDR =>
            --todo: ram stuff
        
        --store reg
        --when OPCODE_STR =>
            --todo: ram stuff
            
        --move reg
        when OPCODE_MOV =>
            O_data<= W_dataA;
            O_address<= R_operands(IFO_REGA_BEGIN downto IFO_REGA_END);
            O_execute<= '1';
            O_pausePrevious<='0';
            R_halt<= '0';
            
        --alu
        when OPCODE_ALU =>
            case R_operands(IFO_ALUINS_BEGIN downto IFO_ALUINS_END) is
            
                when ALUCODE_ADD =>
                    O_data   <= std_logic_vector(unsigned(W_dataA) + unsigned(W_dataB));
                    O_address<= R_operands(IFO_REGQ_BEGIN downto IFO_REGQ_END);
                    O_execute<= '1';
                    O_pausePrevious<='0';
                    R_halt<= '0';
                    
                when ALUCODE_SUB =>
                    O_data   <= std_logic_vector(unsigned(W_dataA) - unsigned(W_dataB));
                    O_address<= R_operands(IFO_REGQ_BEGIN downto IFO_REGQ_END);
                    O_execute<= '1';
                    O_pausePrevious<='0';
                    R_halt<= '0';
                    
                --when ALUCODE_MUL =>
            
                --when ALUCODE_DIV =>
            
                when ALUCODE_CMP =>
                    O_data   <= (others => '0');
                    O_address<= (others => '0');
                    O_execute<= '0';
                    O_pausePrevious<='0';
                    R_halt<= '0';
                    
                    if(W_dataA = W_dataB) then
                        R_status(STATUS_EQ)<= '1';
                    else
                        R_status(STATUS_EQ)<= '0';
                    end if;
                    
                    if(unsigned(W_dataA) > unsigned(W_dataB)) then
                        R_status(STATUS_GT)<= '1';
                    else
                        R_status(STATUS_GT)<= '0'; 
                    end if;
                    
                    if(unsigned(W_dataA) < unsigned(W_dataB)) then
                        R_status(STATUS_LT)<= '1';
                     else   
                        R_status(STATUS_LT)<= '0';
                    end if;
                    
                    --O_status(STATUS_EQ)<= '1' when (W_dataA = W_dataB) else '0';
                    --O_status(STATUS_GT)<= '1' when unsigned(W_dataA) > unsigned(W_dataB) else '0';
                    --O_status(STATUS_LT)<= '1' when unsigned(W_dataA) < unsigned(W_dataB) else '0';
                    
                when others =>
                    O_data   <= (others => '0');
                    O_address<= (others => '0');
                    O_execute<= '0';
                    O_pausePrevious<='0';
                    R_halt<= '0';
            end case;
        
        --nop
        when OPCODE_NOP =>
            O_data   <= (others => '0');
            O_address<= (others => '0');
            O_execute<= '0';
            O_pausePrevious<='0';
            R_halt<= '0';
            
        --halt
        when OPCODE_HLT =>
            O_data   <= (others => '0');
            O_address<= (others => '0');
            O_execute<= '0';
            O_pausePrevious<='1';
            R_halt<= '1';
            
        when others =>
            O_data   <= (others => '0');
            O_address<= (others => '0');
            O_execute<= '0';
            O_pausePrevious<='0';
            R_halt<= '0';
                        
        end case;
end process;
end Behavioral;
