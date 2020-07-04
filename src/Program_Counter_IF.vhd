-- Project		: COEN6741
-- File Name	: Program_Counter_IF.vhd 
-- Author		: Nishanth
-- Date			: 13-Mar-2019
-- Description	: This module acts as the Program Counter register which is used to store the 32-bit 
-- Program Counter value and pass it to the Instruction Memory. This module adds the current PC value with 
-- four to get the PC of the next instruction (i.e. PCPlus4F). Incase if a hazard happens and the StallF is 
-- set to '1' then the PC vale will be retained it will not be incremented to get the next instruction. 

-----------------------------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Program_Counter_IF is
	port( 	clk 	: in STD_LOGIC:='0';
			StallF	: in STD_LOGIC:='0';
			StallD	: in STD_LOGIC:='0';
			PC_in 	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
			PCF		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
			PCPlus4F: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Program_Counter_IF; 

-- Architecture Implementation:
architecture Program_Counter_IF_arch of Program_Counter_IF is

-- signal decarations:
signal enable: STD_LOGIC :='1';
signal four: STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000100";

begin
 process(clk)
 begin
	
	-- Set the value of the enable signal: 
	enable <= not(StallF);
	
	-- when there is a rising edge set the value of PCF to PC_in and pass it to the instruction memory: 
	if (rising_edge(clk)) then
		-- When StallF=0, Move the PC to the next instruction and when StallF=1 retain the PC value.
		if (enable='1') then
			PCF <= PC_in;
			PCPlus4F <=	STD_LOGIC_VECTOR((unsigned(PC_in))+(unsigned(four)));
		elsif (StallD='1') then 
			PCPlus4F <=	STD_LOGIC_VECTOR((unsigned(PC_in))-(unsigned(four)));
		end if; 
	end if;	
 end process;
end Program_Counter_IF_arch;

-- end of Program_Counter_IF.vhd