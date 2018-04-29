library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CPU_tb is
end;

architecture bench of CPU_tb is

  component CPU
	Port ( 
	  I_clk : in STD_LOGIC;
	  I_enable : in STD_LOGIC;
	  I_reset : in STD_LOGIC
	  );
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_reset: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: CPU port map (
  		I_clk => I_clk,
		I_enable => I_enable,
		I_reset => I_reset
		);

  stimulus: process
  begin
  	
  	I_enable<= '1';
  	I_reset<= '0';

  	
	wait for clock_period*100;

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