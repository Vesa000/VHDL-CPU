-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ProgramCounter_tb is
end;

architecture bench of ProgramCounter_tb is

  component ProgramCounter
      Port ( I_clk : in STD_LOGIC;
             I_enable : in STD_LOGIC;
             I_pause : in STD_LOGIC;
             I_reset : in STD_LOGIC;
             I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
             I_condition : in STD_LOGIC_VECTOR (3 downto 0);
             I_status : in STD_LOGIC_VECTOR (7 downto 0);
             I_operands : in STD_LOGIC_VECTOR (22 downto 0);
             O_pc : out STD_LOGIC_VECTOR (22 downto 0));
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_pause: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal I_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal I_condition: STD_LOGIC_VECTOR (3 downto 0);
  signal I_status: STD_LOGIC_VECTOR (7 downto 0);
  signal I_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal O_pc: STD_LOGIC_VECTOR (22 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: ProgramCounter port map ( I_clk       => I_clk,
                                 I_enable    => I_enable,
                                 I_pause     => I_pause,
                                 I_reset     => I_reset,
                                 I_opcode    => I_opcode,
                                 I_condition => I_condition,
                                 I_status    => I_status,
                                 I_operands  => I_operands,
                                 O_pc        => O_pc );

  stimulus: process
  begin
  
    -- Put initialisation code here
    i_enable <= '0';
    i_pause <= '0';
    i_reset <= '0';
    i_status <= "00000001";--EQ = 1
    I_condition<= "0000";
    I_opcode<="00000";--nop
    I_operands<="00000000000000000000000";
    wait for clock_period*2;
    wait for clock_period*0.6;
    
    -- Put test bench stimulus code here
    i_enable <= '1';
    wait for clock_period*2;
    
    --jmp  255
    I_opcode<="00111";
    I_operands<="00000000000000011111111";
    wait for clock_period;
    
    I_opcode<="00000";
    I_operands<="00000000000000000000000";
    wait for clock_period;
    
    --bra  255
    I_opcode<="01000";
    I_operands<="00000000000000000001111";
    wait for clock_period;
    
    I_opcode<="00000";
    I_operands<="00000000000000000000000";
    wait for clock_period;
    
    --ret
    I_opcode<="01001";
    I_operands<="00000000000000000000000";
    wait for clock_period;
    
    I_opcode<="00000";
    I_operands<="00000000000000000000000";
    wait for clock_period*2;
    
    --jmp  0 if false
    I_opcode<="00111";
    I_operands<="00000000000000000000000";
    I_condition<= "0010";
    wait for clock_period;
    
    --jmp  255 if true
    I_opcode<="00111";
    I_operands<="00000000000000000001111";
    I_condition<= "0001";
    wait for clock_period;
    
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
  