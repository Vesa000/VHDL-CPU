library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity BlockRam_tb is
end;

architecture bench of BlockRam_tb is

  component BlockRam
      generic(
          width     : integer:=32;
          highAddr  : integer:=255
      );
      Port ( 
             I_clk : in STD_LOGIC;
             I_Aaddr : in STD_LOGIC_VECTOR (width-1 downto 0)     := (others => '0');
             I_ADI : in STD_LOGIC_VECTOR (width-1 downto 0)       := (others => '0');
             O_ADO : out STD_LOGIC_VECTOR (width-1 downto 0)      := (others => '0');
             I_AWE : in STD_LOGIC                                 := '0';
             I_Baddr : in STD_LOGIC_VECTOR (width-1 downto 0)     := (others => '0');
             I_BDI : in STD_LOGIC_VECTOR (width-1 downto 0)       := (others => '0');
             O_BDO : out STD_LOGIC_VECTOR (width-1 downto 0)      := (others => '0');
             I_BWE : in STD_LOGIC                                 := '0'
             );
  end component;
  
  signal I_clk: STD_LOGIC;
  signal I_Aaddr: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal I_ADI: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal O_ADO: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal I_AWE: STD_LOGIC := '0';
  signal I_Baddr: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal I_BDI: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal O_BDO: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
  signal I_BWE: STD_LOGIC := '0' ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: BlockRam generic map ( width    => 32,
                              highAddr => 255 )
                   port map ( I_clk    => I_clk,
                              I_Aaddr  => I_Aaddr,
                              I_ADI    => I_ADI,
                              O_ADO    => O_ADO,
                              I_AWE    => I_AWE,
                              I_Baddr  => I_Baddr,
                              I_BDI    => I_BDI,
                              O_BDO    => O_BDO,
                              I_BWE    => I_BWE );

  stimulus: process
  begin
  
    -- Put initialisation code here


    -- Put test bench stimulus code here

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

  