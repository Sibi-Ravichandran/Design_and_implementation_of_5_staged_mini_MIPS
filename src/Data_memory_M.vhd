-- Project		: COEN6741
-- File Name	: Data_memory_M.vhd 
-- Author		: Vivek
-- Date			: 13-Mar-2019
-- Description	: This unit is used to store and retrieve the data used for the instructions.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Data_memory_M is
	port( 	clk				: in STD_LOGIC:='1';
			MemWriteM		: in STD_LOGIC:='0';
			ALUOutM 		: in STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0');
			WriteDataM	 	: in STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0');
			ReadDataM		: out STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0'));
end Data_memory_M; 

-- Architecture Implementation:
architecture Data_memory_M_arch of Data_memory_M is

-- Declaration of data memory of 1023 rows and each row is of 32-bits. 
type data_mem is array (0 to 1023) of std_logic_vector (31 downto 0); 
signal DM: data_mem;

signal address_Data_mem:		STD_LOGIC_VECTOR (9 downto 0):= (others => '0');
signal Write_Enable: STD_LOGIC:='0';

begin

	-- Signal Assignments:
	Write_Enable <= MemWriteM;
	address_Data_mem<=ALUOutM (9 downto 0);
	Write_Enable<=MemWriteM;
	
	process(clk)
	begin
		
		DM (0) <= x"00000032";
		--DM (0) <= x"000F";
		if(rising_edge(clk)) then
			if(Write_Enable = '1') then
				DM(to_integer(unsigned(address_Data_mem)))   <= WriteDataM(31 downto 0);
			end if;
				ReadDataM (31 downto 0) <= DM(to_integer(unsigned(address_Data_mem)));
		end if;
	end process;

end Data_memory_M_arch;

-- end of Data_memory_M.vhd
