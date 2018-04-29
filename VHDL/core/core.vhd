library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.cpu_constants.all;

entity Core is Port ( 
		I_clk : in STD_LOGIC;
		I_enable : in STD_LOGIC;
		I_reset : in STD_LOGIC;

		--program counter
		O_pc : out STD_LOGIC_VECTOR (15 downto 0);
		I_instruction : in std_logic_vector(31 downto 0);

		--memory
		O_memAddress: out std_logic_vector(31 downto 0);
		O_memStore : out STD_LOGIC;
		O_memRead : out STD_LOGIC;
		O_memStoreData : out std_logic_vector(31 downto 0);
		I_memReadData : in STD_LOGIC_VECTOR (31 downto 0)
		);
end Core;

architecture Behavioral of Core is

signal W_status : STD_LOGIC_VECTOR (7 downto 0);
signal W_pause: STD_LOGIC;
signal W_pc : STD_LOGIC_VECTOR (15 downto 0);
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
signal W_EW_opcode : STD_LOGIC_VECTOR (4 downto 0);

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

signal W_MemAddr:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_MemStoreData:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_MemReadData:STD_LOGIC_VECTOR ( 31 downto 0 );
signal W_MemStore:STD_LOGIC:='0';
signal W_MemRead:STD_LOGIC :='0';

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
		   O_pc : out STD_LOGIC_VECTOR (15 downto 0));
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
		O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
   		O_data : out STD_LOGIC_VECTOR (31 downto 0);
   		O_status:out STD_LOGIC_VECTOR (7 downto 0);

		O_memAddress : out STD_LOGIC_VECTOR (31 downto 0);
		O_memStoreData : out STD_LOGIC_VECTOR (31 downto 0);
		O_memStore : out std_logic;
		O_memRead : out std_logic
		);
end component;

component Mem_WriteBack port(
	   	I_clk : in STD_LOGIC;
	   	I_enable : in STD_LOGIC;
	   	I_reset : in STD_LOGIC;
	   	I_execute : in STD_LOGIC;
	   	I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
	   	I_address : in STD_LOGIC_VECTOR (4 downto 0);
	   	I_data : in STD_LOGIC_VECTOR (31 downto 0);
	   	I_memData : in STD_LOGIC_VECTOR (31 downto 0);
	   	O_address : out STD_LOGIC_VECTOR (4 downto 0);
	   	O_data : out STD_LOGIC_VECTOR (31 downto 0);
	   	O_store : out STD_LOGIC
	   	);
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
						O_pc => W_pc);
						
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
		O_opcode=>W_EW_opcode,
		O_data=>W_EW_data,
		O_status=>W_status,

		O_memAddress=> W_MemAddr,
		O_memStoreData =>W_MemStoreData,
		O_memStore => W_MemStore,
		O_memRead => W_MemRead
		);

WriteBackStage: Mem_WriteBack port map(
		I_clk => I_clk,
		I_enable=> I_enable,
		I_reset=>I_reset,
		I_execute=>W_EW_execute,
		I_opcode=>W_EW_opcode,
		I_address=>W_EW_address,
		I_data=>W_EW_data,
		I_memData=>W_MemReadData,
		O_address=>W_R_storeaddr,
		O_data=>W_R_data,
		O_store=>W_R_store
		);

Registers32: Registers port map(
						I_clk => I_clk,
						i_we=> W_R_store,
						I_data=>W_R_data,
						O_dataA=>W_R_dataA,
						O_dataB=>W_R_dataB,
						I_store=>W_R_storeaddr,
						I_readA=>W_R_readA,
						I_readB=>W_R_readB);
 
process(all)
begin
		O_pc 		<=W_pc;
		W_instruction	<=I_instruction;

		O_memAddress	<=W_MemAddr;
		O_memRead	<=W_MemRead;
		O_memStore	<=W_MemStore;
		O_memStoreData	<=W_MemStoreData;
		W_MemReadData	<=I_memReadData;
end process;

end Behavioral;
