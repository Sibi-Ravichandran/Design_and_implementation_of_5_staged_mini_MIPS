-- Project		: COEN6741
-- File Name	: MUX_ID_1.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This 2:1 MUX is a part of the Instruction Decode Stage. This MUX is 
-- used to handle data dependencies for branch instructions.
-- Input_1= read_data_1	Input_2= ALUOutM_in Select_line= ForwardAD	Output=MUX_1_ID_Output.

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_ID_1 is
	port(read_data_1, ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						ForwardAD	: in STD_LOGIC:='0';
					MUX_1_ID_Output	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_ID_1;

-- Architecture Implementation:
architecture MUX_ID_1_arch of MUX_ID_1 is

begin
	MUX_1_ID_Output <= read_data_1 when ForwardAD='0' else ALUOutM_in;
end MUX_ID_1_arch;

-- end of MUX_ID_1.vhd