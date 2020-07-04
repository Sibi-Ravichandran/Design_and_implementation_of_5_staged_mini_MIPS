-- Project		: COEN6741
-- File Name	: ALU_IE.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: Arithmetic and Logic Unit is used to perform the ALU operations 
-- based on the value of the ALUControlIE sent by the control unit

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity ALU_IE is
	port( 	ALUControlIE	: in STD_LOGIC_VECTOR (2 downto 0):= (others => '0'); 	-- Control Signal for ALU from Control Unit.
			srcAE,srcBE 	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');	-- 32-bit inputs for the ALU
			ALUoutE			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));-- Set to one if the instruction is branching or jump.
end ALU_IE; 

-- Architecture Implementation:
architecture ALU_IE_arch of ALU_IE is

begin

--	Initiate the process whenever there are changes in inputs and ALUControlIE:
	process(srcAE,srcBE,ALUControlIE)
	begin
							
		case ALUControlIE is
		
		-- AND & ANDI Function:
		when "000" =>
			-- Performs bitwise AND and return 32-bit output
			ALUoutE<= STD_LOGIC_VECTOR(unsigned(srcAE) AND unsigned(srcBE));
		
		-- SUB and SUBI Function
		when "001" =>
			-- Performs subtraction and return 32-bit output
		    if srcBE(31)='0' then
				ALUoutE<= STD_LOGIC_VECTOR(unsigned(srcAE) - unsigned(srcBE));		-- If srcBE is positive then srcAE - srcBE
			else 
				ALUoutE<= STD_LOGIC_VECTOR(unsigned(srcAE) + unsigned(srcBE));		-- If srcBE is negative then srcAE + srcBE
			end if;
		
		-- XOR Function
		when "010" =>
			-- Performs bitwise XOR and return 32-bit output		
			ALUoutE<= STD_LOGIC_VECTOR(unsigned(srcAE) XOR unsigned(srcBE));
		
		-- ADD LW and SW Function	
		when "011" =>
			-- Performs Addition and return 32-bit output
			ALUoutE<= STD_LOGIC_VECTOR(unsigned(srcAE) + unsigned(srcBE));
		
		when others => 
			ALUoutE <=X"00000000";
			
		end case;
	end process;

end ALU_IE_arch;

-- end of ALU_IE.vhd