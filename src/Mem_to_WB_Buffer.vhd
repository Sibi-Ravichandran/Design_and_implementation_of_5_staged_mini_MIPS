-- Project		: COEN6741
-- File Name	: Mem_to_WB_Buffer.vhd 
-- Author		: Vivek
-- Date			: 13-Mar-2019
-- Description	: This module acts as the buffer between the Memory Stage and 
-- Write Back Stage. This buffer stores all the outputs of the Mem Stage and  pass them 
-- as input to the WB Stage. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Mem_to_WB_Buffer is
	port( 	clk							: in STD_LOGIC:='0';
			RegWriteM,MemtoRegM			: in STD_LOGIC:='0';
			ALUOutM						: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			ReadDataM					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM					: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			RegWriteW,MemtoRegW			: out STD_LOGIC:='0';
			ALUOutW, ReadDataW			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegW					: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'));	
end Mem_to_WB_Buffer; 

-- Architecture Implementation:
architecture Mem_to_WB_Buffer_arch of Mem_to_WB_Buffer is

begin
  process(Clk)
  begin
	-- We are choosing falling_edge of the clock because the buffer passes the output only after some time from receiving the input. Since we receive the inputs at the raising edge of the clock we are passing the output at the falling edge.
		if falling_edge(Clk) then 
			RegWriteW<= RegWriteM;	
			MemtoRegW<= MemtoRegM;
			ALUOutW	<= ALUOutM;
			WriteRegW<= WriteRegM;
			ReadDataW<= ReadDataM;
		end if;
  end process;
end Mem_to_WB_Buffer_arch;

-- end of Mem_to_WB_Buffer.vhd