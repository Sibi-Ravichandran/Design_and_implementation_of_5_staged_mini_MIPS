-- Project		: COEN6741
-- File Name	: and_gate_D.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: The output of this AND Gate plays an important role in setting the 
-- the select line to the MUX in the Instruction Fetch Stage that selects the next Program Counter Value. 
-- This AND Gate is present in the decode stage to avoid the branch hazard that happens during BEQ Operation. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity Declaration: 
entity and_gate_D is
	port( 	BranchD				: in STD_LOGIC:='0';
			EqualID				: in STD_LOGIC:='0';
			and_gate_ID_output	: out STD_LOGIC:='0';
			PCSrcD_1			: out STD_LOGIC:='0');
end and_gate_D; 

-- Architecture Implementation:
architecture and_gate_D_arch of and_gate_D is

begin 
	
	-- If the instruction is a branching then the control unit will set the BranchD to 1 and the Equality checker will set the EqualID to 1 if the two operands are equal.
	and_gate_ID_output <= EqualID and BranchD;
	PCSrcD_1 <= EqualID and BranchD;

end and_gate_D_arch;

-- end of and_gate_D.vhd
