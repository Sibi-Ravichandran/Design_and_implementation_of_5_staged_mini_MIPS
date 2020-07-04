-- Project		: COEN6741
-- File Name	: MUX_ID_2.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This 2:1 MUX is a part of the Instruction Decode Stage. This MUX is 
-- used to handle data dependencies for branch instructions.
-- Input_1= read_data_2	Input_2= ALUOutM_in Select_line= ForwardBD	Output=MUX_2_ID_Output.

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_ID_2 is
	port(read_data_2, ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						ForwardBD	: in STD_LOGIC:='0';
					MUX_2_ID_Output	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_ID_2;

-- Architecture Implementation:
architecture MUX_ID_2_arch of MUX_ID_2 is

begin
	MUX_2_ID_Output <= read_data_2 when ForwardBD='0' else ALUOutM_in;
end MUX_ID_2_arch;

-- end of MUX_ID_2.vhd