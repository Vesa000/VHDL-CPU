library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.cpu_constants.all;
use IEEE.NUMERIC_STD.ALL;

entity Fetch is
	Port ( I_clk : in STD_LOGIC;
		   I_enable : in STD_LOGIC;
		   I_pause : in STD_LOGIC;
		   I_reset : in std_logic;
		   I_instruction : in STD_LOGIC_VECTOR (31 downto 0);
		   I_status : in STD_LOGIC_VECTOR (7 downto 0);
		   O_execute : out STD_LOGIC;
		   O_opcode : out STD_LOGIC_VECTOR (4 downto 0);
		   O_operands : out STD_LOGIC_VECTOR (22 downto 0);
		   O_pc : out STD_LOGIC_VECTOR (15 downto 0)
		   );
end Fetch;

architecture Behavioral of Fetch is

signal R_opcode : std_logic_vector (4 downto 0);
signal R_condition : std_logic_vector (3 downto 0);
signal R_operands : std_logic_vector (22 downto 0);
signal W_execute : STD_LOGIC:='0';
signal W_pauseClock : STD_LOGIC:='0';

signal R_cntr: std_logic_vector(2 downto 0):="000";
signal R_cmpNotDone : STD_LOGIC:='0';

component ProgramCounter port(
		   I_clk : in STD_LOGIC;
		   I_enable : in STD_LOGIC;
		   I_pause : in STD_LOGIC;
		   I_reset : in STD_LOGIC;
		   I_execute : in STD_LOGIC;
		   I_opcode : in STD_LOGIC_VECTOR (4 downto 0);
		   I_operands : in STD_LOGIC_VECTOR (22 downto 0);
		   O_pc : out STD_LOGIC_VECTOR (15 downto 0)
		   );
end component;

begin

PC: ProgramCounter port map(
						I_clk => I_clk,
						I_enable=> I_enable,
						I_pause=>W_pauseClock,
						I_reset=>I_reset,
						I_execute => W_execute,
						I_opcode=> R_opcode,
						I_operands=> R_operands,
						O_pc=> O_pc);

--register process
process(all)
begin
	if(I_enable='1') then
		R_opcode <= I_instruction(27 downto 23);
		R_condition <= I_instruction(31 downto 28);
		R_operands <= I_instruction(22 downto 0);
		
		--if cmp instruction
		if(I_instruction(IFO_OPCODE_BEGIN downto IFO_OPCODE_END)=OPCODE_ALU and I_instruction(IFO_ALUINS_BEGIN downto IFO_ALUINS_END) = ALUCODE_CMP) then
			R_cntr<="000";
			R_cmpNotDone<='1';
		elsif(R_cntr="011") then
			R_cntr<="011";
			R_cmpNotDone<='0';
		else
			R_cntr <= std_logic_vector(to_unsigned(to_integer(unsigned( R_cntr )) + 1, 3));
		end if;
	end if;
end process;

--execute check and output
process(all)
begin
	--check execute
	if((R_opcode/="00000")                                --not nop
	and((R_condition= "0000")                             --alw
	or (R_condition = "0001" and I_status(0) ='1')        --eq
	or (R_condition = "0010" and I_status(0) ='0')        --neq
	or (R_condition = "0011" and I_status(1) ='1')        --gt
	or (R_condition = "0101" and I_status(2) ='1')        --lt
	or((R_condition = "0100" and I_status(1) ='1')        --geq
		or(R_condition = "0100" and I_status(0) ='1'))
	or((R_condition = "0110" and I_status(2) ='1')        --leq
		or(R_condition = "0110" and I_status(0) ='1')))
	) then 
		W_execute <='1';
	else
		W_execute<='0';
	end if;
	
	-- output
	if(R_cmpNotDone='1' and not ((R_opcode = OPCODE_ALU) and (R_operands(IFO_ALUINS_BEGIN downto IFO_ALUINS_END) = ALUCODE_CMP))) then
		O_execute<='0';
		O_opcode<=(others =>'0');
		O_operands<=(others =>'0');
		W_pauseClock<='1';
	else
		O_execute  <= W_execute;
		O_opcode   <= R_opcode;
		O_operands <= R_operands;
		W_pauseClock<='0';   
	end if;
end process;

end Behavioral;
