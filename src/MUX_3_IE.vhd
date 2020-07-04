-- Project		: COEN6741
-- File Name	: MUX_3_IE.vhd 
-- Author		: Amulya 
-- Date			: 13-Mar-2019
-- Description	: This 3:1 Mux is used to select the First Operand to be sent to the ALU. 
-- This MUX enables the data forwarding to handle Read After Write hazards using Data Forwarding. 
-- Input_1= srcAD	Input_2=ResultW		Input_3=ALUOutM_in	Select_Line=ForwardAE Output=srcAE

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_3_IE is
	port(srcAD,ResultW,ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
		ForwardAE					: in STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
		srcAE						: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_3_IE;

-- Architecture Implementation:
architecture MUX_3_IE_arch of MUX_3_IE is

begin
	process (ForwardAE,srcAD,ResultW,ALUOutM_in)
	begin	
		case ForwardAE is 
			when "00" => 	srcAE <= srcAD;
			when "01" =>	srcAE <= ResultW;
			when "10" =>	srcAE <= ALUOutM_in;
			when others=> 	srcAE <= x"00000000";
		end case;
	end process;
end MUX_3_IE_arch;

-- end of MUX_3_IE.vhd