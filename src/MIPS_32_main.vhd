-- Project		: COEN6741
-- File Name	: MIPS_main.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This module acts as the main file for the entire MIPS Processor. 
-- This process calls the main files of all the five stages and performs the functions 
-- of the entire processor.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity MIPS_main is
	port( clk: in std_logic := '0');
end MIPS_main; 

-- Architecture Implementation:
architecture MIPS_main_arch of MIPS_main is

-- Component Declarations:

-- INSTRUCTION FETCH STAGE: 
Component IF_stage_main is
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
	end Component; 
	
-- INSTRUCTION DECODE STAGE:
Component ID_stage_main is
	port( 	clk						: in STD_LOGIC:='0';
			FlushE					: in STD_LOGIC:='0';
			InstrD					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCPlus4D				: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			RegWriteW				: in STD_LOGIC:='0';
			ResultW,ALUOutM_in		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegW				: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			ForwardAD,ForwardBD		: in STD_LOGIC:='0';
			
			-- Outputs from the control unit: 
			RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE: out STD_LOGIC:='0';
			ALUControlIE			: out STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
			-- Outputs from the Control Unit to the Hazard Unit: 
			BranchD_to_Hazard_Unit, JumpD_to_Hazard_Unit: out STD_LOGIC:='0';
			-- Output from Buffer:
			srcAD,writeDataD		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			RsE,RtE,RdE				: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			RsD,RtD					: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			-- Sign Extension Component:
			signImmE				: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			-- PC-Source Select Line: 
			PCSrcD,PCSrcD_1,PCSrcD_2: out STD_LOGIC:='0';
			-- Calculated PC Branch:
			PCBranchD,PCJumpD		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));

end Component;

-- INSTRUCTION EXECUTION STAGE:
Component IE_stage_main is
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
end Component;  

-- DATA MEMORY STAGE:
Component Mem_stage_main is
	port( 	clk											: in STD_LOGIC:='0';
			RegWriteM,MemtoRegM,MemWriteM				: in STD_LOGIC:='0';
			ALUOutM 									: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteDataM					 				: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegM									: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			RegWriteW,MemtoRegW							: out STD_LOGIC:='0';
			ALUOutW,ReadDataW               			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			WriteRegW	                      			: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			ALUOutM_in									: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'));
end Component; 

-- WRITE BACK STAGE:
Component mux_WB is
	port( 	ReaddataW	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			ALUOutW		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			MemtoRegW 	: in STD_LOGIC:='0';
			ResultW		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end Component;

-- HAZARD UNIT:
Component Hazard_Unit is
	port( clk : in STD_LOGIC := '0';
	    RegWriteW,RegWriteM,RegWriteE,MemtoRegM,MemtoRegE	: in STD_LOGIC:= '0';
		  WriteRegM,WriteRegW,WriteRegE_to_Hazard_Unit		: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		  RsE,RtE,RsD,RtD									: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0'); 
		  BranchD_to_Hazard_Unit,JumpD_to_Hazard_Unit		: in STD_LOGIC :='0';
		  FlushE,StallD,StallF				: out STD_LOGIC:='0';
		  ForwardAE,ForwardBE				: out STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		  ForwardAD,ForwardBD				: out STD_LOGIC:='0');
end Component; 

-- Signal Declarations:
-- IF Stage:
signal StallF,StallD,PCSrcD,PCSrcD_1,PCSrcD_2		 : STD_LOGIC := '0';	
signal PCBranchD,PCJumpD,InstrD,PCplus4D : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
-- ID Stage:
signal FlushE,RegWriteW,BranchD_to_Hazard_Unit,JumpD_to_Hazard_Unit: STD_LOGIC :='0';
signal ForwardAD,ForwardBD,RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE: STD_LOGIC :='0';
signal ResultW,ALUOutM_in,srcAD,writeDataD,signImmE: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal WriteRegW,RsE,RtE,RdE,RsD,RtD: STD_LOGIC_VECTOR (4 downto 0)  := (others => '0');
signal ALUControlIE: STD_LOGIC_VECTOR (2 downto 0)  := (others => '0');
-- IE Stage: 
signal ForwardAE,ForwardBE: STD_LOGIC_VECTOR (1 downto 0) := "00";
signal RegWriteM,MemWriteM,MemtoRegM: STD_LOGIC; 
signal ALUOutM,WriteDataM:  STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal WriteRegE_to_Hazard_Unit,WriteRegM: STD_LOGIC_VECTOR (4 downto 0) := "00000";
-- DM STAGE: 
signal MemtoRegW: STD_LOGIC;
signal ALUOutW,ReadDataW: STD_LOGIC_VECTOR (31 downto 0);

begin

-- IF STAGE: 
IF_Main	: IF_stage_main PORT MAP (clk,StallF,StallD,PCSrcD_1,PCSrcD_2,PCBranchD,PCJumpD,PCSrcD,InstrD,PCPlus4D);

-- ID STAGE:
ID_Main : ID_stage_main PORT MAP (clk, FlushE, InstrD, PCPlus4D, RegWriteW, ResultW,ALUOutM_in, WriteRegW, ForwardAD,ForwardBD, RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE, ALUControlIE, BranchD_to_Hazard_Unit, JumpD_to_Hazard_Unit, srcAD,writeDataD, RsE,RtE,RdE, RsD,RtD, signImmE, PCSrcD,PCSrcD_1,PCSrcD_2, PCBranchD,PCJumpD);

-- IE STAGE: 
IE_Main : IE_stage_main PORT MAP (clk, RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE, ALUControlIE, srcAD,WriteDataD,ResultW,ALUOutM_in,signImmE, ForwardAE,ForwardBE, RtE, RdE, RegWriteM,MemtoRegM,MemWriteM, ALUOutM, WriteDataM, WriteRegM, WriteRegE_to_Hazard_Unit);
 
-- DM STAGE: 
DM_Main : Mem_stage_main PORT MAP (clk, RegWriteM,MemtoRegM,MemWriteM, ALUOutM, WriteDataM, WriteRegM, RegWriteW,MemtoRegW, ALUOutW,ReadDataW, WriteRegW, ALUOutM_in);

-- WB STAGE: 
WB_Main : mux_WB PORT MAP (ReaddataW, ALUOutW, MemtoRegW, ResultW); 

-- HAZARD UNIT:
Hazard_main : Hazard_Unit PORT MAP (clk, RegWriteW,RegWriteM,RegWriteE,MemtoRegM,MemtoRegE, WriteRegM,WriteRegW,WriteRegE_to_Hazard_Unit, RsE,RtE,RsD,RtD, BranchD_to_Hazard_Unit,JumpD_to_Hazard_Unit, FlushE,StallD,StallF, ForwardAE,ForwardBE, ForwardAD,ForwardBD);


end MIPS_main_arch;

-- end of MIPS_main.vhd