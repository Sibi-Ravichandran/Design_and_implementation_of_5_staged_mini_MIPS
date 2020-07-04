-- Project		: COEN6741
-- File Name	: Mem_stage_main.vhd 
-- Author		: Vivek
-- Date			: 13-Mar-2019
-- Description	: This module acts as the main file for the Memory Stage. 
-- All the components of the Memory stage are called in this file. This file performs the entire 
-- Data Memory stage.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Mem_stage_main is
	port( 	clk											: in STD_LOGIC:='0';
			RegWriteM,MemtoRegM,MemWriteM				: in STD_LOGIC:='0';
			ALUOutM 									: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteDataM					 				: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM									: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			RegWriteW,MemtoRegW							: out STD_LOGIC:='0';
			ALUOutW,ReadDataW               			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			WriteRegW	                      			: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			ALUOutM_in									: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end Mem_stage_main; 

-- Architecture Implementation:
architecture Mem_stage_main_arch of Mem_stage_main is

-- Component Declarations:

-- DATA MEMORY:
Component Data_memory_M is
	port( 	clk				: in STD_LOGIC:='1';
			MemWriteM		: in STD_LOGIC:='0';
			ALUOutM 		: in STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0');
			WriteDataM	 	: in STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0');
			ReadDataM		: out STD_LOGIC_VECTOR 	(31 downto 0):= (others => '0'));
end Component; 

-- Memory to Write Back Buffer
Component Mem_to_WB_Buffer is
	port( 	clk							: in STD_LOGIC:='0';
			RegWriteM,MemtoRegM			: in STD_LOGIC:='0';
			ALUOutM						: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			ReadDataM					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM					: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			RegWriteW,MemtoRegW			: out STD_LOGIC:='0';
			ALUOutW, ReadDataW			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegW					: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'));	
end Component; 

-- Signal Declaration: 
signal ReadDataM : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');

begin
	
	-- Assign the value of ALUOutM_in:
	ALUOutM_in <= ALUOutM; 
	
	
	data_mem		: Data_memory_M 	port map (clk, MemWriteM, ALUOutM, WriteDataM,ReadDataM); 
	Mem_to_WB_Buff	: Mem_to_WB_Buffer 	port map (clk,RegWriteM,MemtoRegM,ALUOutM,ReadDataM,WriteRegM,RegWriteW,MemtoRegW,ALUOutW,ReadDataW,WriteRegW);

end Mem_stage_main_arch;

-- end of Mem_stage_main.vhd