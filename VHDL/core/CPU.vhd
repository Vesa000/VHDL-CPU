----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2018 06:29:06 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( 
           I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           
           
           Debug_status : buffer STD_LOGIC_VECTOR (7 downto 0);
           Debug_pause: buffer STD_LOGIC;
           Debug_pc : buffer STD_LOGIC_VECTOR (22 downto 0);
           
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
           
end CPU;

architecture Behavioral of CPU is

signal W_status : STD_LOGIC_VECTOR (7 downto 0);
signal W_pause: STD_LOGIC;
signal W_pc : STD_LOGIC_VECTOR (22 downto 0);

signal W_instruction : STD_LOGIC_VECTOR (31 downto 0);
           
signal W_FD_execute : STD_LOGIC;
signal W_FD_opcode : STD_LOGIC_VECTOR (4 downto 0);
signal W_FD_operands : STD_LOGIC_VECTOR (22 downto 0);
           
signal W_DE_execute : STD_LOGIC;
signal W_DE_opcode : STD_LOGIC_VECTOR (4 downto 0);
signal W_DE_operands : STD_LOGIC_VECTOR (22 downto 0);
           
signal W_EW_execute : STD_LOGIC;
signal W_EW_address : STD_LOGIC_VECTOR (4 downto 0);
signal W_EW_data : STD_LOGIC_VECTOR (31 downto 0);

--Registers           
signal W_R_store    : STD_LOGIC;
signal W_R_data  :  STD_LOGIC_VECTOR (31 downto 0);
signal W_R_dataA : STD_LOGIC_VECTOR (31 downto 0);
signal W_R_dataB : STD_LOGIC_VECTOR (31 downto 0);
signal W_R_storeaddr : STD_LOGIC_VECTOR (4 downto 0);
signal W_R_readA : STD_LOGIC_VECTOR (4 downto 0);
signal W_R_readB : STD_LOGIC_VECTOR (4 downto 0);

--Block Ram
signal W_BR_Aaddr: STD_LOGIC_VECTOR ( 12 downto 0 );
signal W_BR_Ain: STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_BR_Aout:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_BR_Awe:STD_LOGIC_VECTOR ( 0 downto 0 ):="0";
signal W_BR_Baddr:STD_LOGIC_VECTOR ( 12 downto 0 );
signal W_BR_Bin:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_BR_Bout:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_BR_Bwe:STD_LOGIC_VECTOR ( 0 downto 0 ):="0";

component Fetch port(
           I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_pause : in STD_LOGIC;
           I_reset : in std_logic;
           I_instruction : in STD_LOGIC_VECTOR (31 downto 0);
           I_status : in STD_LOGIC_VECTOR (7 downto 0);
           O_execute : out STD_LOGIC;
           O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
           O_operands : out STD_LOGIC_VECTOR (22 downto 0);
           O_pc : out STD_LOGIC_VECTOR (22 downto 0));
end component;

component Decode port(
           I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_pause : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
           I_operands : in STD_LOGIC_VECTOR (22 downto 0);
           O_execute : out STD_LOGIC;
           O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
           O_operands : out STD_LOGIC_VECTOR (22 downto 0);
           O_readA : out STD_LOGIC_VECTOR (4 downto 0);
           O_readB : out STD_LOGIC_VECTOR (4 downto 0));
end component;

component Execute port(
           I_clk : in STD_LOGIC;
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

component WriteBack port(
           I_clk : in STD_LOGIC;
           I_enable : in STD_LOGIC;
           I_reset : in STD_LOGIC;
           I_execute : in STD_LOGIC;
           I_address : in STD_LOGIC_VECTOR (4 downto 0);
           I_data : in STD_LOGIC_VECTOR (31 downto 0);
           O_address : out STD_LOGIC_VECTOR (4 downto 0);
           O_data : out STD_LOGIC_VECTOR (31 downto 0);
           O_store : out STD_LOGIC);
end component;

component Registers port(
           I_clk   : in STD_LOGIC;
           i_we    : in STD_LOGIC;
           I_data  : in  STD_LOGIC_VECTOR (31 downto 0);
           O_dataA : out STD_LOGIC_VECTOR (31 downto 0);
           O_dataB : out STD_LOGIC_VECTOR (31 downto 0);
           I_store : in STD_LOGIC_VECTOR (4 downto 0);
           I_readA : in STD_LOGIC_VECTOR (4 downto 0);
           I_readB : in STD_LOGIC_VECTOR (4 downto 0));
end component;

component BlockRam port(
           BRAM_PORTA_0_addr : in STD_LOGIC_VECTOR ( 12 downto 0 );
           BRAM_PORTA_0_clk : in STD_LOGIC;
           BRAM_PORTA_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
           BRAM_PORTA_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
           BRAM_PORTA_0_we : in STD_LOGIC_VECTOR ( 0 to 0 );
           BRAM_PORTB_0_addr : in STD_LOGIC_VECTOR ( 12 downto 0 );
           BRAM_PORTB_0_clk : in STD_LOGIC;
           BRAM_PORTB_0_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
           BRAM_PORTB_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
           BRAM_PORTB_0_we : in STD_LOGIC_VECTOR ( 0 to 0 ));
end component;

begin

FetchStage: Fetch port map(
                        I_clk => I_clk,
                        I_enable=> I_enable,
                        I_pause=>W_pause,
                        I_reset=>I_reset,
                        I_instruction=>W_instruction,
                        I_status=>W_status,
                        O_execute => W_FD_execute,
                        O_opcode=>W_FD_opcode,
                        O_operands=>W_FD_operands,
                        O_pc=> W_pc);
                        
DecodeStage: Decode port map(
                        I_clk => I_clk,
                        I_enable=> I_enable,
                        I_reset=>I_reset,
                        I_pause=>W_pause,
                        I_execute=>W_FD_execute,
                        I_opcode=>W_FD_opcode,
                        I_operands=>W_FD_operands,
                        O_execute=>W_DE_execute,
                        O_opcode=>W_DE_opcode,
                        O_operands=>W_DE_operands,
                        O_readA=>W_R_readA,
                        O_readB=>W_R_readB);

ExecuteStage: Execute port map(
                        I_clk => I_clk,
                        I_enable=> I_enable,
                        I_reset=>I_reset,
                        I_execute=>W_DE_execute,
                        I_opcode=>W_DE_opcode,
                        I_operands=>W_DE_operands,
                        I_regA=>W_R_dataA,
                        I_regB=>W_R_dataB,
                        O_pausePrevious=>W_pause,
                        O_execute=>W_EW_execute,
                        O_address=>W_EW_address,
                        O_data=>W_EW_data,
                        O_status=>W_status);

WriteBackStage: WriteBack port map(
                        I_clk => I_clk,
                        I_enable=> I_enable,
                        I_reset=>I_reset,
                        I_execute=>W_EW_execute,
                        I_address=>W_EW_address,
                        I_data=>W_EW_data,
                        O_address=>W_R_storeaddr,
                        O_data=>W_R_data,
                        O_store=>W_R_store);

Registers32: Registers port map(
                        I_clk => I_clk,
                        i_we=> W_R_store,
                        I_data=>W_R_data,
                        O_dataA=>W_R_dataA,
                        O_dataB=>W_R_dataB,
                        I_store=>W_R_storeaddr,
                        I_readA=>W_R_readA,
                        I_readB=>W_R_readB);
 
 Bram: BlockRam port map(
                        BRAM_PORTA_0_addr => W_pc,
                        BRAM_PORTA_0_clk=> I_clk,
                        BRAM_PORTA_0_din=> W_BR_Ain, 
                        BRAM_PORTA_0_dout=> W_instruction, 
                        BRAM_PORTA_0_we=> W_BR_Awe, 
                        BRAM_PORTB_0_addr=> W_BR_Baddr, 
                        BRAM_PORTB_0_clk=> I_clk, 
                        BRAM_PORTB_0_din=> W_BR_Bin, 
                        BRAM_PORTB_0_dout=> W_BR_Bout,
                        BRAM_PORTB_0_we=> W_BR_Bwe);                       
 
 DEBUGPROCESS: process(all)
 begin
               
 Debug_status<=W_status;
 Debug_pause<=W_pause;
 Debug_pc<=W_pc;
 
 W_instruction<=Debug_instruction;
 
 Debug_FD_execute<=W_FD_execute;
 Debug_FD_opcode<=W_FD_opcode;
 Debug_FD_operands<=W_FD_operands;
 
 Debug_DE_execute<=W_DE_execute;
 Debug_DE_opcode<=W_DE_opcode;
 Debug_DE_operands<=W_DE_operands;
 
 Debug_EW_execute<=W_EW_execute;
 Debug_EW_address<=W_EW_address;
 Debug_EW_data<=W_EW_data;
 
 Debug_R_store<=W_R_store;
 Debug_R_data<=W_R_data;
 Debug_R_dataA<=W_R_dataA;
 Debug_R_dataB<=W_R_dataB;
 Debug_R_storeaddr<=W_R_storeaddr;
 Debug_R_readA<=W_R_readA;
 Debug_R_readB<=W_R_readB;

 end process;


end Behavioral;
