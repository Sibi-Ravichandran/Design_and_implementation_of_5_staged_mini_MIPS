-- Project		: COEN6741
-- File Name	: MUX_1_IF.vhd 
-- Author		: Nishanth
-- Date			: 13-Mar-2019
-- Description	: This Mux is used to select the next instruction between PCPlus4F and PCBranchD. 
-- Input_1= PCPlus4F	Input_2= PCBranchD 	Select_line= PCSrcD_1 	Output=MUX_1_IF_out

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_1_IF is
	port(PCPlus4F, PCBranchD			: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
					PCSrcD_1			: in STD_LOGIC:='0';
					MUX_1_IF_out		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_1_IF;

-- Architecture Implementation:
architecture MUX_1_IF_arch of MUX_1_IF is

begin
	MUX_1_IF_out <= PCBranchD when PCSrcD_1='1'else PCPlus4F;
end MUX_1_IF_arch;

-- end of MUX_1_IF.vhd