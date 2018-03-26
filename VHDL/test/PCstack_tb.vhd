
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PCstack_tb is
end;

architecture bench of PCstack_tb is

  component PCstack
      Port ( I_clk : in STD_LOGIC;
             I_reset : in STD_LOGIC;
             I_push : in STD_LOGIC;
             I_pop : in STD_LOGIC;
             I_data : in STD_LOGIC_VECTOR (31 downto 0);
             O_data : out STD_LOGIC_VECTOR (31 downto 0);
             O_sp : out integer);
  end component;

  signal I_clk: STD_LOGIC;
  signal I_reset: STD_LOGIC;
  signal I_push: STD_LOGIC;
  signal I_pop: STD_LOGIC;
  signal I_data: STD_LOGIC_VECTOR (31 downto 0);
  signal O_data: STD_LOGIC_VECTOR (31 downto 0);
  signal O_sp: integer;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: PCstack port map ( I_clk   => I_clk,
                          I_reset => I_reset,
                          I_push  => I_push,
                          I_pop   => I_pop,
                          I_data  => I_data,
                          O_data  => O_data,
                          O_sp => O_sp);

  stimulus: process
  begin
  
    -- Put initialisation code here
    I_reset <= '0';
    --wait for clock_period/10;
       

    -- Put test bench stimulus code here
    --push data
    I_data<=X"00000001";
    I_push<='1';
    I_pop<='0';
    wait for clock_period;
    
    I_data<=X"00000001";
    I_push<='1';
    I_pop<='0';
    wait for clock_period;
        
    I_data<=X"00000002";
    I_push<='1';
    I_pop<='0';
    wait for clock_period;
            
    I_data<=X"00000003";
    I_push<='1';
    I_pop<='0';
    wait for clock_period;
                
    I_data<=X"00000004";
    I_push<='1';
    I_pop<='0';
    wait for clock_period;
    
    I_push<='0';
    wait for clock_period;
    
    --pop data

    I_pop<='1';
    wait for clock_period*2;
    
    I_pop<='0';
    wait for clock_period*2;
    
    I_pop<='1';
    wait for clock_period*2;
    
    I_pop<='0';
    wait for clock_period*2;
        
    I_pop<='1';
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
  