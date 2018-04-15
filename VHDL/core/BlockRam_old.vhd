--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Thu Mar 29 00:04:05 2018
--Host        : DESKTOP-82RUIP1 running 64-bit major release  (build 9200)
--Command     : generate_target BramBlock_wrapper.bd
--Design      : BramBlock_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.cpu_constants.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity BlockRamOLD is
  port (
	BRAM_PORTA_0_addr : in STD_LOGIC_VECTOR ( 15 downto 0 );
	BRAM_PORTA_0_clk : in STD_LOGIC;
	BRAM_PORTA_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTA_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTA_0_we : in STD_LOGIC_VECTOR ( 0 to 0 );
	I_MemAddress : in STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTB_0_clk : in STD_LOGIC;
	BRAM_PORTB_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTB_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTB_0_we : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end BlockRamOLD;

architecture STRUCTURE of BlockRamOLD is

	signal BRAM_PORTB_0_addr : STD_LOGIC_VECTOR(31 downto 0);
  
  component BramBlock_wrapper is
  port (
	BRAM_PORTA_0_addr : in STD_LOGIC_VECTOR ( 15 downto 0 );
	BRAM_PORTA_0_clk : in STD_LOGIC;
	BRAM_PORTA_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTA_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTA_0_we : in STD_LOGIC_VECTOR ( 0 to 0 );
	BRAM_PORTB_0_addr : in STD_LOGIC_VECTOR ( 15 downto 0 );
	BRAM_PORTB_0_clk : in STD_LOGIC;
	BRAM_PORTB_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTB_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
	BRAM_PORTB_0_we : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component BramBlock_wrapper;
begin
BramBlock_wrap: component BramBlock_wrapper
	 port map (
	  BRAM_PORTA_0_addr(15 downto 0) => BRAM_PORTA_0_addr(15 downto 0),
	  BRAM_PORTA_0_clk => BRAM_PORTA_0_clk,
	  BRAM_PORTA_0_din(31 downto 0) => BRAM_PORTA_0_din(31 downto 0),
	  BRAM_PORTA_0_dout(31 downto 0) => BRAM_PORTA_0_dout(31 downto 0),
	  BRAM_PORTA_0_we(0) => BRAM_PORTA_0_we(0),
	  BRAM_PORTB_0_addr(15 downto 0) => BRAM_PORTB_0_addr(15 downto 0),
	  BRAM_PORTB_0_clk => BRAM_PORTB_0_clk,
	  BRAM_PORTB_0_din(31 downto 0) => BRAM_PORTB_0_din(31 downto 0),
	  BRAM_PORTB_0_dout(31 downto 0) => BRAM_PORTB_0_dout(31 downto 0),
	  BRAM_PORTB_0_we(0) => BRAM_PORTB_0_we(0)
	);


process(all)
begin
	if(unsigned(I_MemAddress)>to_unsigned(MEM_RAM_START,32)) then
		BRAM_PORTB_0_addr <= STD_LOGIC_VECTOR(unsigned(I_MemAddress) + to_unsigned(MEM_RAM_START,32));
	else
		BRAM_PORTB_0_addr<= (others => '0');
	
end if;
end process;
end STRUCTURE;
