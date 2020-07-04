-- Project		: COEN6741
-- File Name	: MUX_2_IF.vhd 
-- Author		: Nishanth
-- Date			: 13-Mar-2019
-- Description	: This Mux is used to select the next instruction between PCJump and the output of the MUX_1_IF_out. 
-- Input_1= MUX_1_IF_out	Input_2= PCJumpD 	Select_line= PCSrcD_2 	Output=PC_in

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MUX_2_IF is
	port(MUX_1_IF_out, PCJumpD	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
					PCSrcD_2	: in STD_LOGIC:='0';
					PC_in		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end MUX_2_IF;

-- Architecture Implementation:
architecture MUX_2_IF_arch of MUX_2_IF is

begin
	PC_in <= PCJumpD when PCSrcD_2='1'else MUX_1_IF_out;
end MUX_2_IF_arch;

-- end of MUX_2_IF.vhd