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
	  I_reset : in STD_LOGIC;
	  Debug_status : buffer STD_LOGIC_VECTOR (7 downto 0);
	  Debug_pause: buffer STD_LOGIC;
	  Debug_pc : buffer STD_LOGIC_VECTOR (15 downto 0);
	  Debug_instruction : buffer STD_LOGIC_VECTOR (31 downto 0);
	  Debug_FD_execute : buffer STD_LOGIC;
	  Debug_FD_opcode : buffer STD_LOGIC_VECTOR (4 downto 0);
	  Debug_FD_operands : buffer STD_LOGIC_VECTOR (22 downto 0);
	  Debug_DE_execute : buffer STD_LOGIC;
	  Debug_DE_opcode : buffer STD_LOGIC_VECTOR (4 downto 0);
	  Debug_DE_operands : buffer STD_LOGIC_VECTOR (22 downto 0);
	  Debug_EW_execute : buffer STD_LOGIC;
	  Debug_EW_address : buffer STD_LOGIC_VECTOR (4 downto 0);
	  Debug_EW_data : buffer STD_LOGIC_VECTOR (31 downto 0);
	  Debug_R_store    : buffer STD_LOGIC;
	  Debug_R_data  : buffer  STD_LOGIC_VECTOR (31 downto 0);
	  Debug_R_dataA : buffer STD_LOGIC_VECTOR (31 downto 0);
	  Debug_R_dataB : buffer STD_LOGIC_VECTOR (31 downto 0);
	  Debug_R_storeaddr : buffer STD_LOGIC_VECTOR (4 downto 0);
	  Debug_R_readA : buffer STD_LOGIC_VECTOR (4 downto 0);
	  Debug_R_readB : buffer STD_LOGIC_VECTOR (4 downto 0)
	  );
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal Debug_status: STD_LOGIC_VECTOR (7 downto 0);
  signal Debug_pause: STD_LOGIC;
  signal Debug_pc: STD_LOGIC_VECTOR (15 downto 0);
  signal Debug_instruction: STD_LOGIC_VECTOR (31 downto 0);
  signal Debug_FD_execute: STD_LOGIC;
  signal Debug_FD_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal Debug_FD_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal Debug_DE_execute: STD_LOGIC;
  signal Debug_DE_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal Debug_DE_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal Debug_EW_execute: STD_LOGIC;
  signal Debug_EW_address: STD_LOGIC_VECTOR (4 downto 0);
  signal Debug_EW_data: STD_LOGIC_VECTOR (31 downto 0);
  signal Debug_R_store: STD_LOGIC;
  signal Debug_R_data: STD_LOGIC_VECTOR (31 downto 0);
  signal Debug_R_dataA: STD_LOGIC_VECTOR (31 downto 0);
  signal Debug_R_dataB: STD_LOGIC_VECTOR (31 downto 0);
  signal Debug_R_storeaddr: STD_LOGIC_VECTOR (4 downto 0);
  signal Debug_R_readA: STD_LOGIC_VECTOR (4 downto 0);
  signal Debug_R_readB: STD_LOGIC_VECTOR (4 downto 0) ;


  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: CPU port map ( I_clk             => I_clk,
					  I_enable          => I_enable,
					  I_reset           => I_reset,
					  Debug_status      => Debug_status,
					  Debug_pause       => Debug_pause,
					  Debug_pc          => Debug_pc,
					  Debug_instruction => Debug_instruction,
					  Debug_FD_execute  => Debug_FD_execute,
					  Debug_FD_opcode   => Debug_FD_opcode,
					  Debug_FD_operands => Debug_FD_operands,
					  Debug_DE_execute  => Debug_DE_execute,
					  Debug_DE_opcode   => Debug_DE_opcode,
					  Debug_DE_operands => Debug_DE_operands,
					  Debug_EW_execute  => Debug_EW_execute,
					  Debug_EW_address  => Debug_EW_address,
					  Debug_EW_data     => Debug_EW_data,
					  Debug_R_store     => Debug_R_store,
					  Debug_R_data      => Debug_R_data,
					  Debug_R_dataA     => Debug_R_dataA,
					  Debug_R_dataB     => Debug_R_dataB,
					  Debug_R_storeaddr => Debug_R_storeaddr,
					  Debug_R_readA     => Debug_R_readA,
					  Debug_R_readB     => Debug_R_readB );

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