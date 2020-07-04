-- Project		: COEN6741
-- File Name	: IF_to_ID_Buffer.vhd 
-- Author		: Nishanth
-- Date			: 13-Mar-2019
-- Description	: This module acts as the buffer between the Instruction Fetch and 
-- Instruction Decode Stage. This buffer stores all the outputs of the IF Stage and 
-- pass them as input to the ID Stage. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity IF_to_ID_Buffer is
	port( 	clk    			: in STD_LOGIC:='0';	
			PCSrcD,StallD	: in STD_LOGIC:='0';
			InstrF			: 	in STD_LOGIC_VECTOR  (31 downto 0):= (others => '0'); 
			PCPlus4F		:	in STD_LOGIC_VECTOR  (31 downto 0):= (others => '0');
			InstrD			:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCPlus4D		:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
	end IF_to_ID_Buffer; 

-- Architecture Implementation:
architecture IF_to_ID_Buffer_arch of IF_to_ID_Buffer is

-- signal declarations: 
signal clr		: STD_LOGIC := '0';
signal enable	: STD_LOGIC := '1';

begin
  process(Clk)
  begin
  
	-- Assign the values of clr and enable signal: 
	clr 	<= PCSrcD;
	enable 	<= not(StallD);
    
	-- We are choosing falling_edge of the clock because the buffer passes the output only after some time from receiving the input. Since we receive the inputs at the raising edge of the clock we are passing the output at the falling edge.
   	if falling_edge(Clk) then 
		if ((clr='0')and(enable='1')) then 
			PCPlus4D <= PCPlus4F;
			InstrD 	 <= InstrF;
		elsif ((clr='1')or(enable='0')) then 
			PCPlus4D <= X"00000000";
			InstrD 	 <= X"00000000";
		end if;
	 end if;
  end process;

end IF_to_ID_Buffer_arch;

-- end of IF_to_ID_Buffer.vhd
