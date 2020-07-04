-- Project		: COEN6741
-- File Name	: MUX_1_IE.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: This Mux is used to select the second input to the ALU.  
-- Input_1= WriteDataE	Input_2= SignImmE 	Select_line= ALUsrcE 	Output=srcBE

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_1_IE is
	port(WriteDataE, SignImmE		: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
							ALUsrcE	: in STD_LOGIC:='0';
							srcBE	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_1_IE;

-- Architecture Implementation:
architecture MUX_1_IE_arch of MUX_1_IE is

begin
	srcBE <= WriteDataE when ALUsrcE='0' else SignImmE;
end MUX_1_IE_arch;

-- end of MUX_1_IE.vhd