-- Project		: COEN6741
-- File Name	: ID_stage_main.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This module acts as the main file for the Instruction Decode Stage. 
-- All the components of the ID stage are called in this file. This file performs the entire 
-- Instruction Decode.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity ID_stage_main is
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

end ID_stage_main; 

-- Architecture Implementation:
architecture ID_stage_main_arch of ID_stage_main is

-- Component Declarations:

-- CONTROL UNIT:
Component Control_Unit is
	port( InstrD		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 	-- 16-bit instruction acts as the input.
			RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUsrcD,RegDstD,JumpD,PCSrcD_2: out STD_LOGIC:='0';
			ALUControlID: out STD_LOGIC_VECTOR (2 downto 0):= (others => '1')); 	-- we are considering 3 bits as we have only 6 ALU functions.		
end Component;

-- MUX_ID_1:
Component MUX_ID_1 is
	port(read_data_1, ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						ForwardAD	: in STD_LOGIC:='0';
					MUX_1_ID_Output	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- MUX_ID_2:
Component MUX_ID_2 is
	port(read_data_2, ALUOutM_in	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						ForwardBD	: in STD_LOGIC:='0';
					MUX_2_ID_Output	: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end Component;

-- Equality_Checker:
Component Equality_Checker is
	port(BranchD							: in STD_LOGIC;
		MUX_1_ID_Output, MUX_2_ID_Output	: in STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
						EqualID				: out STD_LOGIC:='0');
end Component;

-- and_gate_D:
Component and_gate_D is
	port( 	BranchD				: in STD_LOGIC:='0';
			EqualID				: in STD_LOGIC:='0';
			and_gate_ID_output	: out STD_LOGIC:='0';
			PCSrcD_1			: out STD_LOGIC:='0');
end Component; 

-- or_gate_D:
Component or_gate_D is
	port( 	JumpD				: in STD_LOGIC:='0';
			and_gate_ID_output	: in STD_LOGIC:='0';
			PCSrcD				: out STD_LOGIC:='0');
end Component; 

-- shifter_I_ID:
Component shifter_I_ID is
	port( 	SignImmD_I				: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			SignImmD_I_after_shift 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	
end Component; 

-- PCBranch_adder
Component PCBranch_adder is
	port( 	SignImmD_I_after_shift, PCPlus4D	: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			PCBranchD 						: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	
end Component; 

-- sign_extension_I_Type_ID
Component sign_extension_I_Type_ID is
	port( 	InstrD					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 	
			SignImmD_I				: out STD_LOGIC_VECTOR (31 downto 0):= (others=>'0'));			
end Component; 

-- ID_to_EX_Buffer
Component ID_to_EX_Buffer is
	port( 	clk							: in STD_LOGIC:='0';
			FlushE						: in STD_LOGIC:='0';
			RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD: in STD_LOGIC:='0';
			ALUControlID				: in STD_LOGIC_VECTOR (2 downto 0):= (others => '1');
			MUX_1_ID_Output,MUX_2_ID_Output		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			SignImmD_I					: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			InstrD						: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');	
			RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE: out STD_LOGIC:='0';
			ALUControlIE				: out STD_LOGIC_VECTOR (2 downto 0):= (others => '1');
			srcAD,writeDataD			: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			signImmE					: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			RsE,RtE,RdE					: out STD_LOGIC_VECTOR (4 downto 0):= (others => '0'));	
end Component; 

-- Register_file: 
Component Register_file is
	port( 	clk,JumpD	: in STD_LOGIC:='0';
			InstrD		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			RegWriteW	: in STD_LOGIC:='0';
			ResultW		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegW	: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			read_data_1	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			read_data_2	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			PCJumpD 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end Component; 

-- Signal Decarations:

-- Register File: 
signal read_data_1,read_data_2	: STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
-- Control Unit: 
signal RegWriteD,MemtoRegD,MemWriteD,BranchD,JumpD,ALUsrcD,RegDstD: STD_LOGIC:='0';
signal ALUControlID: STD_LOGIC_VECTOR (2 downto 0):= (others => '1');
signal MUX_1_ID_Output: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
-- MUX_2_ID:
signal MUX_2_ID_Output: STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
-- Equality_Checker: 
signal EqualID: STD_LOGIC:='0';
-- AND Gate: 
signal and_gate_ID_output: STD_LOGIC:='0';
-- Sign Extension:
signal SignImmD_I: STD_LOGIC_VECTOR (31 downto 0);
-- Shifter: 
signal SignImmD_I_after_shift: STD_LOGIC_VECTOR (31 downto 0):= (others => '0');


begin

	-- Assign the values of RsD and RtD to send them to Hazard Unit: 
	RsD						<= InstrD (27 downto 23);
	RtD						<= InstrD (22 downto 18);
	
	BranchD_to_Hazard_Unit <= and_gate_ID_output;
	JumpD_to_Hazard_Unit <= JumpD;
	
	
	-- CONTROL UNIT: 
	CU 		: Control_Unit PORT MAP (InstrD,RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUsrcD,RegDstD,JumpD,PCSrcD_2,ALUControlID);
	Regfile : Register_file PORT MAP(clk,JumpD,InstrD,RegWriteW,ResultW,WriteRegW,read_data_1,read_data_2,PCJumpD);
	MUX1	: MUX_ID_1 PORT MAP (read_data_1, ALUOutM_in,ForwardAD,MUX_1_ID_Output);
	MUX2	: MUX_ID_2 PORT MAP (read_data_2, ALUOutM_in,ForwardBD,MUX_2_ID_Output);
	EQ_Check: Equality_Checker PORT MAP (BranchD,MUX_1_ID_Output, MUX_2_ID_Output,EqualID);
	ANDG	: and_gate_D PORT MAP (BranchD,EqualID,and_gate_ID_output,PCSrcD_1); 
	ORG		: or_gate_D PORT MAP (JumpD,and_gate_ID_output,PCSrcD);
	SHIFT_I : shifter_I_ID PORT MAP (SignImmD_I,SignImmD_I_after_shift);
	PCBrAdd	: PCBranch_adder PORT MAP (SignImmD_I_after_shift, PCPlus4D,PCBranchD);
	SgnextI	: sign_extension_I_Type_ID PORT MAP (InstrD,SignImmD_I);
	DtoXBuff: ID_to_EX_Buffer PORT MAP (clk,FlushE, RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD, ALUControlID, MUX_1_ID_Output,MUX_2_ID_Output, SignImmD_I, InstrD, RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE, ALUControlIE, srcAD,writeDataD, signImmE, RsE,RtE,RdE); 
	
end ID_stage_main_arch;

-- end of ID_stage_main.vhd