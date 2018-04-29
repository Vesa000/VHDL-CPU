library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity BlockRam_tb is
end;

architecture bench of BlockRam_tb is

  component BlockRam
  port (
	clkA : in std_logic;
	clkB : in std_logic;
	enA : in std_logic;
	enB : in std_logic;
	weA : in std_logic;
	weB : in std_logic;
	addrA : in std_logic_vector(15 downto 0);
	I_MemAddress : in std_logic_vector(31 downto 0);
	diA : in std_logic_vector(31 downto 0);
	diB : in std_logic_vector(31 downto 0);
	doA : out std_logic_vector(31 downto 0);
	doB : out std_logic_vector(31 downto 0)
	);
  end component;

  signal clkA: std_logic;
  signal clkB: std_logic;
  signal enA: std_logic;
  signal enB: std_logic;
  signal weA: std_logic;
  signal weB: std_logic;
  signal addrA: std_logic_vector(15 downto 0);
  signal I_MemAddress: std_logic_vector(31 downto 0);
  signal diA: std_logic_vector(31 downto 0);
  signal diB: std_logic_vector(31 downto 0);
  signal doA: std_logic_vector(31 downto 0);
  signal doB: std_logic_vector(31 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: BlockRam port map ( 
  							  clkA		   => clkA,
							  clkB         => clkB,
							  enA          => enA,
							  enB          => enB,
							  weA          => weA,
							  weB          => weB,
							  addrA        => addrA,
							  I_MemAddress => I_MemAddress,
							  diA          => diA,
							  diB          => diB,
							  doA          => doA,
							  doB          => doB);

  stimulus: process
  begin

  	enA <= '1';

  	addrA <= "0000000000000000";
    wait for clock_period*2;

    addrA <= "0000000000000001";
    wait for clock_period*2;

    addrA <= "0000000000000010";
    wait for clock_period*2;

    addrA <= "0000000000000011";
    wait for clock_period*2;

    addrA <= "0000000000000100";
    wait for clock_period*2;

	stop_the_clock <= true;
	wait;
  end process;

  clocking: process
  begin
	while not stop_the_clock loop
	  clkA <= '0', '1' after clock_period / 2;
	  wait for clock_period;
	end loop;
	wait;
  end process;

end;