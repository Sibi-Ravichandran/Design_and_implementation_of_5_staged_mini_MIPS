-- Project		: COEN6741
-- File Name	: shifter_I_ID.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This unit is used to left shift the Immediate value (i.e offset) 
-- by two bits. Offset will be used in BEQ instructions. Here we will give the 
-- number of instructions to be jumped as the offset value. So when we multiply the number 
-- of instructions by 4 we will get the value that has to be added to the PC to get the PC Branch address.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity shifter_I_ID is
	port( 	SignImmD_I				: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			SignImmD_I_after_shift 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	
end shifter_I_ID; 

-- Architecture Implementation:
architecture shifter_I_ID_arch of shifter_I_ID is

begin
	
	SignImmD_I_after_shift <= STD_LOGIC_VECTOR(shift_left(unsigned(SignImmD_I), 2));

end shifter_I_ID_arch;

-- end of shifter_I_ID.vhd