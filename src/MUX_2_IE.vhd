-- Project		: COEN6741
-- File Name	: MUX_2_IE.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: This Mux is used to select the value of write register
-- Input_1= RtE	Input_2= RdE 	Select_line= RegDstE 	Output=writeRegE

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_2_IE is
	port(RtE, RdE	: in STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
		RegDstE		: in STD_LOGIC:='0';
		writeRegE	: out STD_LOGIC_VECTOR(4 downto 0):= (others => '0'));
end MUX_2_IE;

-- Architecture Implementation:
architecture MUX_2_IE_arch of MUX_2_IE is

begin
	writeRegE <= RtE when RegDstE='0' else RdE;
end MUX_2_IE_arch;

-- end of MUX_2_IE.vhd