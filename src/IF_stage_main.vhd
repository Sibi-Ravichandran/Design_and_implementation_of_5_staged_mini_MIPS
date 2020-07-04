-- Project		: COEN6741
-- File Name	: IF_stage_main.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This module acts as the main file for the Instruction Fetch Stage. 
-- All the components of the IF stage are called in this file. This file performs the entire 
-- Instruction Fetch.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity IF_stage_main is
	port( 	clk						: in STD_LOGIC:='0';
			StallF,StallD			: in STD_LOGIC:='0';
			-- Mux Component:
			PCSrcD_1    			: in STD_LOGIC:='0';
			PCSrcD_2    			: in STD_LOGIC:='0';
			PCBranchD,PCJumpD		: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
			-- Buffer Component:
			PCSrcD					: in STD_LOGIC:='0';
			-- Output from the IF Stage 
			InstrD					:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCPlus4D				:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
	end IF_stage_main; 

-- Architecture Implementation:
architecture IF_stage_main_arch of IF_stage_main is

-- Component Declarations

-- MUX_1_IF
Component MUX_1_IF is
	port(PCPlus4F, PCBranchD			: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
					PCSrcD_1			: in STD_LOGIC:='0';
					MUX_1_IF_out		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- MUX_2_IF
Component MUX_2_IF is
	port(MUX_1_IF_out, PCJumpD	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
					PCSrcD_2	: in STD_LOGIC:='0';
					PC_in		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- Program_Counter_IF
Component Program_Counter_IF is
	port( 	clk 	: in STD_LOGIC:='0';
			StallF	: in STD_LOGIC:='0';
			StallD	: in STD_LOGIC:='0';
			PC_in 	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
			PCF		: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
			PCPlus4F: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component; 

-- Instruction_Memory_IF: 
Component Instruction_Memory_IF is
	port( 	PCF			: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 		-- A in the block diagram: Address- 32-bits
			InstrF		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	-- RD in the block diagram: Instruction size-32-bits
end Component;

-- IF_to_ID_Buffer
Component IF_to_ID_Buffer is
	port( 	clk    			: in STD_LOGIC:='0';	
			PCSrcD,StallD	: in STD_LOGIC:='0';
			InstrF			: 	in STD_LOGIC_VECTOR  (31 downto 0):= (others => '0'); 
			PCPlus4F		:	in STD_LOGIC_VECTOR  (31 downto 0):= (others => '0');
			InstrD			:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCPlus4D		:	out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end Component; 


-- Signal Decarations:
signal MUX_1_IF_out,PC_in,PCF,InstrF: STD_LOGIC_VECTOR (31 downto 0);
signal PCPlus4F: STD_LOGIC_VECTOR(31 downto 0);

begin
  
    -- signal assignments: 
		MUX_1_Inst_Fetch					: MUX_1_IF PORT MAP (PCPlus4F,PCBranchD,PCSrcD_1,MUX_1_IF_out);
		MUX_2_Inst_Fetch					: MUX_2_IF PORT MAP (MUX_1_IF_out,PCJumpD,PCSrcD_2,PC_in);
		Program_Counter_Inst_Fetch			: Program_Counter_IF port map (clk,StallF,StallD,PC_in,PCF,PCPlus4F);
		Instruction_Memory_Inst_Fetch		: Instruction_Memory_IF port map (PCF, InstrF);
		IF_to_ID_Buffer_Inst_Fetch			: IF_to_ID_Buffer port map (clk,PCSrcD,StallD,InstrF,PCPlus4F,InstrD,PCPlus4D);
	
end IF_stage_main_arch;

-- end of IF_stage_main.vhd