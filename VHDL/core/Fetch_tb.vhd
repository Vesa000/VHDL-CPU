-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Fetch_tb is
end;

architecture bench of Fetch_tb is

  component Fetch
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
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_pause: STD_LOGIC;
  signal I_reset: std_logic;
  signal I_instruction: STD_LOGIC_VECTOR (31 downto 0);
  signal I_status: STD_LOGIC_VECTOR (7 downto 0);
  signal O_execute: STD_LOGIC;
  signal O_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal O_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal O_pc: STD_LOGIC_VECTOR (22 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Fetch port map ( I_clk         => I_clk,
                        I_enable      => I_enable,
                        I_pause       => I_pause,
                        I_reset       => I_reset,
                        I_instruction => I_instruction,
                        I_status      => I_status,
                        O_execute     => O_execute,
                        O_opcode      => O_opcode,
                        O_operands    => O_operands,
                        O_pc          => O_pc );

  stimulus: process
  begin
  
    -- Put initialisation code here
    I_enable<='1';
    I_pause<='0';
    I_reset<='0';
    I_status <= "00000001";--EQ = 1

    -- Put test bench stimulus code here
    
    --nop
    I_instruction<= "00000000000000000000000000000000";
    wait for clock_period*2;
    
    -- jmp should not execute
    I_instruction<= "00100011100000000000000011111111";
    wait for clock_period;
    
    --bra should execute
    I_instruction<= "00010100000000000000000000001111";
    wait for clock_period;
    
    --nop
    I_instruction<= "00000000000000000000000000000000";
    wait for clock_period*2;
    
    --ret
    I_instruction<= "00000100100000000000000000000000";
    wait for clock_period;
    
    --nop
    I_instruction<= "00000000000000000000000000000000";
    wait for clock_period*2;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      I_clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;