library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

library work;
use work.cpu_constants.all;

entity Execute_tb is
end;

architecture bench of Execute_tb is

  component Execute
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
  end component;

  signal I_clk: STD_LOGIC;
  signal I_enable: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal I_execute: STD_LOGIC;
  signal I_opcode: STD_LOGIC_VECTOR (4 downto 0);
  signal I_operands: STD_LOGIC_VECTOR (22 downto 0);
  signal I_regA: STD_LOGIC_VECTOR (31 downto 0);
  signal I_regB: STD_LOGIC_VECTOR (31 downto 0);
  signal O_pausePrevious: STD_LOGIC;
  signal O_execute: STD_LOGIC;
  signal O_address: STD_LOGIC_VECTOR (4 downto 0);
  signal O_data: STD_LOGIC_VECTOR (31 downto 0);
  signal O_status: STD_LOGIC_VECTOR (7 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: Execute port map ( I_clk           => I_clk,
                          I_enable        => I_enable,
                          I_reset         => I_reset,
                          I_execute       => I_execute,
                          I_opcode        => I_opcode,
                          I_operands      => I_operands,
                          I_regA          => I_regA,
                          I_regB          => I_regB,
                          O_pausePrevious => O_pausePrevious,
                          O_execute       => O_execute,
                          O_address       => O_address,
                          O_data          => O_data,
                          O_status        => O_status);

  stimulus: process
  begin
  
    -- Put initialisation code here
    I_enable<='1';
    I_reset<='0';
    I_execute<='1';
    
    -- Put test bench stimulus code here
    
    --cmp FFFF0000 and 0000FFFF
    I_opcode<=OPCODE_ALU;
    I_operands(IFO_REGA_BEGIN downto IFO_REGA_END)<= "00010";
    I_operands(IFO_ALUINS_BEGIN downto IFO_ALUINS_END)<=ALUCODE_CMP;
    I_regA<=x"0000FFFF";
    I_regB<=x"FFFF0000";
    wait for clock_period;
    
    --Load 0FFFF TO 00001
    I_opcode<=OPCODE_LDV;
    I_operands(IFO_REGA_BEGIN downto IFO_REGA_END)<= "00001";
    I_operands(IFO_VAL_BEGIN downto IFO_VAL_END)<= "011111111111111111";
    wait for clock_period;
    
    --ADD FFFF0000 + 0000FFFF TO 00010
    I_opcode<=OPCODE_ALU;
    I_operands(IFO_REGA_BEGIN downto IFO_REGA_END)<= "00010";
    I_operands(IFO_ALUINS_BEGIN downto IFO_ALUINS_END)<=ALUCODE_ADD;
    I_regA<=x"FFFF0000";
    I_regB<=x"0000FFFF";
    wait for clock_period;
    
    --cmp FFFF0000 and 0000FFFF
    I_opcode<=OPCODE_ALU;
    I_operands(IFO_REGA_BEGIN downto IFO_REGA_END)<= "00010";
    I_operands(IFO_ALUINS_BEGIN downto IFO_ALUINS_END)<=ALUCODE_CMP;
    I_regA<=x"FFFF0000";
    I_regB<=x"0000FFFF";
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