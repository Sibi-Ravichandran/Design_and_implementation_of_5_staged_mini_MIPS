-- Project		: COEN6741
-- File Name	: or_gate_D.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: The output of this OR Gate acts as the select line to the MUX in the 
-- Instruction Fetch Stage that selects the next Program Counter Value. This OR Gate is 
-- present in the decode stage to avoid the branch hazard that happens due to the JR and BEQ 
-- instructions. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity Declaration: 
entity or_gate_D is
	port( 	JumpD				: in STD_LOGIC:='0';
			and_gate_ID_output	: in STD_LOGIC:='0';
			PCSrcD				: out STD_LOGIC:='0');
end or_gate_D; 

-- Architecture Implementation:
architecture or_gate_D_arch of or_gate_D is

begin 
	
	-- If the instruction is a jump instruction then the control unit will set the JumpD to 1. 
	-- If the instruction is a BEQ Instruction then the and_gate_ID will set the value of and_gate_ID_output to 1 if the two operands are equal. 
	-- Now this OR Gate will set the value of PCSrcD depending on the above inputs.
	PCSrcD <= and_gate_ID_output or JumpD;

end or_gate_D_arch;

-- end of or_gate_D.vhd