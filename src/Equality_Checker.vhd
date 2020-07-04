-- Project		: COEN6741
-- File Name	: Equality_Checker.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: The Equality Checker is to check whether the two operands are equal. 
-- If the two operands are equal then this will set the value of EqualID to '1'. This 
-- is done in the decode stage to handle the branch hazard that arises due to the BEQ 
-- operation. 
-- Input-1:MUX_1_ID_Output 		Input-2:MUX_2_ID_Output		Output: EqualID

----------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Equality_Checker is
	port(BranchD							: in STD_LOGIC;
		MUX_1_ID_Output, MUX_2_ID_Output	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						EqualID				: out STD_LOGIC:='0');
end Equality_Checker;

-- Architecture Implementation:
architecture Equality_Checker_arch of Equality_Checker is

begin
	process (BranchD,MUX_1_ID_Output,MUX_2_ID_Output)
	begin 
		if (BranchD = '1') then 
			if (MUX_1_ID_Output=MUX_2_ID_Output) then
				EqualID  <= '1';
			end if;
		else 
			EqualID  <= '0';
		end if;
	end process; 
end Equality_Checker_arch;

-- end of Equality_Checker.vhd