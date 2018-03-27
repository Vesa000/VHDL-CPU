-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Decode_tb is
end;

architecture bench of Decode_tb is

  component Decode
      Port ( I_clk : in STD_LOGIC;
             I_enable : in STD_LOGIC;
             I_reset : in STD_LOGIC;
             I_pause : in STD_LOGIC;
             I_execute : in STD_LOGIC;
             I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
             I_operands : in STD_LOGIC_VECTOR (22 downto 0);
             O_execute : out STD_LOGIC;
             O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
             O_operands : out STD_LOGIC_VECTOR (22 downto 0);
             O_readA : out STD_LOGIC_VECTOR (4 downto 0);
             O_readB : out STD_LOGIC_VECTOR (4 downto 0));
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal I_pause: STD_LOGIC;
  signal I_execute: STD_LOGIC;
  signal I_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal I_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal O_execute: STD_LOGIC;
  signal O_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal O_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal O_readA: STD_LOGIC_VECTOR (4 downto 0);
  signal O_readB: STD_LOGIC_VECTOR (4 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Decode port map ( I_clk      => I_clk,
                         I_enable   => I_enable,
                         I_reset    => I_reset,
                         I_pause    => I_pause,
                         I_execute  => I_execute,
                         I_opcode   => I_opcode,
                         I_operands => I_operands,
                         O_execute  => O_execute,
                         O_opcode   => O_opcode,
                         O_operands => O_operands,
                         O_readA    => O_readA,
                         O_readB    => O_readB );

  stimulus: process
  begin
  
    -- Put initialisation code here
    I_enable <='1';
    I_reset  <='0';
    I_pause  <='0';
    I_execute<='1';

    -- Put test bench stimulus code here
    I_opcode<="00000";
    I_operands<="00001000100000000000000";
    wait for clock_period*2;
    
    I_opcode<="00011";
    wait for clock_period*2;
    
    I_opcode<="00100";
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