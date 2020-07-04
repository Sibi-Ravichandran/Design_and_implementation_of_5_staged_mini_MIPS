-- Project		: COEN6741
-- File Name	: IE_stage_main.vhd 
-- Author		: Amulya
-- Date			: 13-Mar-2019
-- Description	: This module acts as the main file for the Instruction Execution Stage. 
-- All the components of the IE stage are called in this file. This file performs the entire 
-- Instruction Execution.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity IE_stage_main is
	port(	clk							: in STD_LOGIC:='0'; 
			-- Input Control Signals sent out from Control Unit: 
			RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE: in STD_LOGIC:='0';
			ALUControlIE				: in STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
			-- MUX-1,MUX-3,MUX-4:
			srcAD,WriteDataD,ResultW,ALUOutM_in,signImmE: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			ForwardAE,ForwardBE 		: in STD_LOGIC_VECTOR (1 downto 0):="00";
			-- MUX-2:
			RtE, RdE 					: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			-- Output for the entire IE Stage:
			RegWriteM,MemtoRegM,MemWriteM	: out STD_LOGIC:='0';
			ALUOutM							: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteDataM						: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM						: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'); 
			WriteRegE_to_Hazard_Unit		: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'));	
end IE_stage_main; 

-- Architecture Implementation:
architecture IE_stage_main_arch of IE_stage_main is

-- Component Declarations:

-- MUX_3_IE:
Component MUX_3_IE is
	port(srcAD,ResultW,ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
		ForwardAE					: in STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
		srcAE						: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- MUX_4_IE:
Component MUX_4_IE is
	port(writeDataD,ResultW,ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
		ForwardBE						: in STD_LOGIC_VECTOR(1 downto 0):= (others => '0');
		writeDataE						: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- MUX_1_IE:
Component MUX_1_IE is
	port(WriteDataE, SignImmE		: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
							ALUsrcE	: in STD_LOGIC:='0';
							srcBE	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- MUX_2_IE:
Component MUX_2_IE is
	port(RtE, RdE	: in STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
		RegDstE		: in STD_LOGIC:='0';
		writeRegE	: out STD_LOGIC_VECTOR(4 downto 0):= (others => '0'));
end Component;

-- ALU:
Component ALU_IE is
	port( 	ALUControlIE	: in STD_LOGIC_VECTOR (2 downto 0):= (others => '0'); 	-- Control Signal for ALU from Control Unit.
			srcAE,srcBE 	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');	-- 32-bit inputs for the ALU
			ALUoutE			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));-- Set to one if the instruction is branching or jump.
end Component;

-- Buffer:
Component EX_to_Mem_Buffer is
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
end Component;  


-- Signal Declarations: 
signal srcAE,writeDataE,srcBE,ALUoutE : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal writeRegE: STD_LOGIC_VECTOR (4 downto 0) := "00000";


begin
	
	MUX_3: MUX_3_IE PORT MAP (srcAD,ResultW,ALUOutM_in,ForwardAE,srcAE);
	MUX_4: MUX_4_IE PORT MAP (writeDataD,ResultW,ALUOutM_in,ForwardBE,writeDataE);				
	MUX_1: MUX_1_IE PORT MAP (WriteDataE,SignImmE,ALUsrcE,srcBE);
	ALU  : ALU_IE	PORT MAP (ALUControlIE,srcAE,srcBE,ALUoutE);
	MUX_2: MUX_2_IE PORT MAP (RtE,RdE,RegDstE,writeRegE);
	Ex_Buffer: EX_to_Mem_Buffer PORT MAP (clk,RegWriteE,MemtoRegE,MemWriteE,ALUOutE,WriteDataE,WriteRegE,RegWriteM,MemtoRegM,MemWriteM,ALUOutM,WriteDataM,WriteRegM	);	
	
	-- Assign the value of WriteRegE_to_Hazard_Unit
	WriteRegE_to_Hazard_Unit <= WriteRegE; 
	
end IE_stage_main_arch; 

-- end of IE_stage_main.vhd
