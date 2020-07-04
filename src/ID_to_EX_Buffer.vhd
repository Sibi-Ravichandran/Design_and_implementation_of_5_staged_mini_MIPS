-- Project		: COEN6741
-- File Name	: ID_to_EX_Buffer.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This module acts as the buffer between the Instruction Decode and 
-- Instruction Execution Stage. This buffer stores all the outputs of the ID Stage and 
-- pass them as input to the EX Stage. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity ID_to_EX_Buffer is
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
end ID_to_EX_Buffer; 

-- Architecture Implementation:
architecture ID_to_EX_Buffer_arch of ID_to_EX_Buffer is

-- signal declarations:
signal clr : STD_LOGIC:='0';

begin
  process(clk)
  begin
	
	-- Assign value to clr signal: 
	clr <= FlushE;
	
	-- We are choosing falling_edge of the clock because the buffer passes the output only after some time from receiving the input. Since we receive the inputs at the raising edge of the clock we are passing the output at the falling edge.
		if falling_edge(clk) then 
			if (clr='1') then 
				RegWriteE				<= '0';
				MemtoRegE				<= '0';
				MemWriteE				<= '0';
				ALUSrcE					<= '0';
				RegDstE					<= '0';
				ALUControlIE			<= "111";
				srcAD       			<= X"00000000";
				writeDataD				<= X"00000000";
				signImmE				<= X"00000000";
				RsE    					<= "00000";	
				RtE    					<= "00000";	
				RdE						<= "00000";	
			else 
				RegWriteE				<= RegWriteD;
			    MemtoRegE				<= MemtoRegD;
			    MemWriteE				<= MemWriteD;
			    ALUSrcE					<= ALUSrcD;
			    RegDstE					<= RegDstD;
			    ALUControlIE			<= ALUControlID;
			    srcAD					<= MUX_1_ID_Output;
				writeDataD				<= MUX_2_ID_Output;
			    signImmE				<= SignImmD_I;
			    RsE						<= InstrD (27 downto 23);
				RtE						<= InstrD (22 downto 18);
				RdE						<= InstrD (17 downto 13);
			end if;
		end if;
  end process;
end ID_to_EX_Buffer_arch;

-- end of ID_to_EX_Buffer.vhd