-- Project		: COEN6741
-- File Name	: PCBranch_adder.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This unit is used to add the Offset value to the PC+4 to get the 
-- Target branch address.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity PCBranch_adder is
	port( 	SignImmD_I_after_shift, PCPlus4D	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCBranchD 						: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	
end PCBranch_adder; 

-- Architecture Implementation:
architecture PCBranch_adder_arch of PCBranch_adder is

begin
	PCBranchD<=STD_LOGIC_VECTOR(signed(PCPlus4D)+signed(SignImmD_I_after_shift));
end PCBranch_adder_arch;

-- end of PCBranch_adder.vhd