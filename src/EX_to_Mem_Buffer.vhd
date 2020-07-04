-- Project		: COEN6741
-- File Name	: EX_to_Mem_Buffer.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: This module acts as the buffer between the Instruction Execute Stage and 
-- Data Memory Stage. This buffer stores all the outputs of the EX Stage and  pass them 
-- as input to the Mem Stage. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity EX_to_Mem_Buffer is
	port( 	clk								: in STD_LOGIC:='0';
			RegWriteE,MemtoRegE,MemWriteE	: in STD_LOGIC:='0';
			ALUOutE							: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteDataE						: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegE						: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0'); 
			-- Outputs:
			RegWriteM,MemtoRegM,MemWriteM	: out STD_LOGIC:='0';
			ALUOutM							: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteDataM						: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM						: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'));	
end EX_to_Mem_Buffer; 

-- Architecture Implementation:
architecture EX_to_Mem_Buffer_arch of EX_to_Mem_Buffer is

begin
  process(Clk)
  begin
	-- We are choosing falling_edge of the clock because the buffer passes the output only after some time from receiving the input. Since we receive the inputs at the raising edge of the clock we are passing the output at the falling edge.
		if falling_edge(Clk) then 
			RegWriteM<=RegWriteE;
			MemtoRegM<=MemtoRegE;
			MemWriteM<=MemWriteE;
			ALUOutM<=ALUOutE;
			WriteDataM<=WriteDataE;
			WriteRegM<=WriteRegE;
		end if;
  end process;
end EX_to_Mem_Buffer_arch;

-- end of EX_to_Mem_Buffer.vhd