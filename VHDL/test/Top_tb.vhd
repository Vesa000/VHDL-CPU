library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Top_tb is
end;

architecture bench of Top_tb is

  component Top Port ( 
		I_clk : in STD_LOGIC;
		O_uart_tx : out STD_LOGIC;
		  I_uart_rx : in STD_LOGIC
		);
  end component;

  signal I_clk: STD_LOGIC;
  signal O_uart_tx: STD_LOGIC;
  signal I_uart_rx: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Top port map ( 
  		I_clk => I_clk,
		O_uart_tx => O_uart_tx,
		I_uart_rx => I_uart_rx
		);

  stimulus: process
  begin
  
	wait for clock_period*1000;

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