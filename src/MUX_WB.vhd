-- File Name	: mux_WB.vhd 
-- Author		: Vivek
-- Date			: 20-Feb-2019
-- Description	: This unit is used to select whether the ALU output or the Data from 
-- memory has to be written back to registers
-- Input_1= ReaddataW	Input_2= ALUOutW 	Select_line= MemtoRegW 	Output=ResultW

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity Declaration: 
entity mux_WB is
	port( 	ReaddataW	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			ALUOutW		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			MemtoRegW 	: in STD_LOGIC:='0';
			ResultW		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end mux_WB; 

-- Architecture Implementation:
architecture mux_WB_arch of mux_WB is

begin
	ResultW <= ReaddataW when MemtoRegW='1' else ALUOutW;
end mux_WB_arch;

-- end of mux_WB.vhd
