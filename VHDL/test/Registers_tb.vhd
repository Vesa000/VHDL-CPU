----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2018 06:58:46 PM
-- Design Name: 
-- Module Name: Registers_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers_tb is
end Registers_tb;

architecture Behavioral of Registers_tb is
    component registers is
        Port ( 
               I_clk : in STD_LOGIC;
               i_we : in STD_LOGIC;                           -- write enable
               I_data : in  STD_LOGIC_VECTOR (31 downto 0);   -- Data to write to reg
               O_dataA : out STD_LOGIC_VECTOR (31 downto 0);
               O_dataB : out STD_LOGIC_VECTOR (31 downto 0);
               I_store : in STD_LOGIC_VECTOR (4 downto 0);
               I_readA : in STD_LOGIC_VECTOR (4 downto 0);
               I_readB : in STD_LOGIC_VECTOR (4 downto 0));
    end component;
    
    --Inputs
       signal I_clk : std_logic := '0';
       signal I_data : std_logic_vector(31 downto 0) := (others => '0');
       signal I_readA : std_logic_vector(4 downto 0) := (others => '0');
       signal I_readB : std_logic_vector(4 downto 0) := (others => '0');
       signal I_store : std_logic_vector(4 downto 0) := (others => '0');
       signal I_we : std_logic := '0';
    
      --Outputs
       signal O_dataA : std_logic_vector(31 downto 0);
       signal O_dataB : std_logic_vector(31 downto 0);
    
       -- Clock period definitions
       constant I_clk_period : time := 10 ns;
       
begin
-- Instantiate the Unit Under Test (UUT)
   uut: registers PORT MAP (
          I_clk => I_clk,
          I_data => I_data,
          O_dataA => O_dataA,
          O_dataB => O_dataB,
          I_readA => I_readA,
          I_readB => I_readB,
          I_store => I_store,
          I_we => I_we
        );

   -- Clock process definitions
   I_clk_process :process
   begin
    I_clk <= '0';
    wait for I_clk_period/2;
    I_clk <= '1';
    wait for I_clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      
      wait for 1 ns;    

      wait for I_clk_period*10;

      -- insert stimulus here 


    -- test for writing.
    -- r0 = 0xffff ffff
    I_readA <= "00000";
    I_readB <= "00001";
    I_store <= "00000";
    I_data <= X"FFFFFFFF";
    I_we <= '1';
      wait for I_clk_period;

    -- r2 = 0x22222222
    I_readA <= "00000";
    I_readB <= "00001";
    I_store <= "00010";
    I_data <= X"22222222";
    I_we <= '1';
      wait for I_clk_period;

    -- r3 = 0x33333333
    I_readA <= "00000";
    I_readB <= "00001";
    I_store <= "00010";
    I_data <= X"33333333";
    I_we <= '1';
      wait for I_clk_period;

    --test just reading, with no write
    I_readA <= "00000";
    I_readB <= "00001";
    I_store <= "00000";
    I_data <= X"FEEDFEED";
    I_we <= '0';
      wait for I_clk_period;

    --at this point dataA should not be 'feedfeed'

    I_readA <= "00001";
    I_readB <= "00010";
      wait for I_clk_period;

    I_readA <= "00011";
    I_readB <= "00100";
      wait for I_clk_period;

    I_readA <= "00000";
    I_readB <= "00001";
    I_store <= "00100";
    I_data <= X"44444444";
    I_we <= '1';
      wait for I_clk_period;

    I_we <= '0';
      wait for I_clk_period;

    -- nop
      wait for I_clk_period;

    I_readA <= "00100";
    I_readB <= "00100";
      wait for I_clk_period;
      
     I_readA <= "00000";
     I_readB <= "00000";
        wait for I_clk_period;

      wait;
   end process;
end Behavioral;
