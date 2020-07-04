-- Project		: COEN6741
-- File Name	: MUX_4_IE.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: This 3:1 Mux is used to select the First Operand to be sent to the ALU. 
-- This MUX enables the data forwarding to handle Read After Write hazards using Data Forwarding. 
-- Input_1= writeDataD	Input_2=ResultW		Input_3=ALUOutM_in Select_Line=ForwardBE Output=writeDataE

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_4_IE is
	port(writeDataD,ResultW,ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
		ForwardBE						: in STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
		writeDataE						: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_4_IE;

-- Architecture Implementation:
architecture MUX_4_IE_arch of MUX_4_IE is

begin
	process (ForwardBE,writeDataD,ResultW,ALUOutM_in)
	begin	
		case ForwardBE is 
			when "00" => 	writeDataE <= writeDataD;
			when "01" =>	writeDataE <= ResultW;
			when "10" =>	writeDataE <= ALUOutM_in;
			when others=> 	writeDataE <= x"00000000";
		end case;
	end process;
end MUX_4_IE_arch;

-- end of MUX_4_IE.vhd