-- Project		: COEN6741
-- File Name	: sign_extension_I_Type_ID.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This unit is used to extend the sign bit of the immediate value. 
-- The immediate value is of 14-bits but the ALU performs operations on 32-bit values so 
-- we are converting the 14-bit value to 32-bit value.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity sign_extension_I_Type_ID is
	port( 	InstrD					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 	
			SignImmD_I				: out STD_LOGIC_VECTOR (31 downto 0):= (others=>'0'));			
end sign_extension_I_Type_ID; 

-- Architecture Implementation:
architecture sign_extension_I_Type_ID_arch of sign_extension_I_Type_ID is

-- Signal Declaration 
signal sign_ext_in_I: STD_LOGIC_VECTOR (17 downto 0);

begin

	sign_ext_in_I <= InstrD (17 downto 0);
	-- Convert 18-bit input to 32-bit output depening on the value of MSB Bit:
	SignImmD_I(17 downto 0)	<= sign_ext_in_I;
	SignImmD_I(31 downto 18)	<= "11111111111111" when  sign_ext_in_I(17)='1' else "00000000000000";

end sign_extension_I_Type_ID_arch;

-- end of sign_extension_I_Type_ID.vhd
