-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity WriteBack_tb is
end;

architecture bench of WriteBack_tb is

  component WriteBack
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
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal I_execute: STD_LOGIC;
  signal I_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal I_address: STD_LOGIC_VECTOR (4 downto 0);
  signal I_data: STD_LOGIC_VECTOR (31 downto 0);
  signal O_address: STD_LOGIC_VECTOR (4 downto 0);
  signal O_data: STD_LOGIC_VECTOR (31 downto 0);
  signal O_store: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: WriteBack port map ( I_clk     => I_clk,
                            I_enable  => I_enable,
                            I_reset   => I_reset,
                            I_execute => I_execute,
                            I_opcode  => I_opcode,
                            I_address => I_address,
                            I_data    => I_data,
                            O_address => O_address,
                            O_data    => O_data,
                            O_store   => O_store );

  stimulus: process
  begin
  
    -- Put initialisation code here
    I_enable <='1';
    I_reset  <='0';
    I_execute<='1';
    I_address<= "00011";
    I_data<= X"FFFF0000";
    -- Put test bench stimulus code here
    I_opcode<= "00000";
    wait for clock_period;
    
    I_opcode<= "00001";
    wait for clock_period;
        
    I_opcode<= "00000";
    wait for clock_period;
    
    I_opcode<= "00001";
    wait for clock_period*3;
        
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