-- Project		: COEN6741
-- File Name	: Control_Unit.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: The Control unit receives the opcode and function bits and 
-- generate the control signals and pass it to the ALU and other blocks of the architecture
-- Opcode Table followed for the mini-MIPS Architecture.

--  --------------------------------------------------------------------
--	|	S.No|Function 	 |Instruction_Type|Opcode|Function|ALUControlID|
--  |-------|------------|----------------|------|--------|------------|
--  |   1	|AND         |R-TYPE          |0000  |00	  |000         |
--  |   2	|SUB	     |R-TYPE          |0000  |01	  |001         |
--  |   3	|XOR         |R-TYPE          |0000  |10	  |010         |
--  |   4	|ANDI        |I-TYPE          |0001  |N/A	  |000         |
--  |   5	|SUBI        |I-TYPE	      |0010  |N/A	  |001         |
--  |   6	|ADD         |R-TYPE          |0000  |11	  |011         |
--  |   7	|LW	         |I-TYPE          |0011  |N/A	  |011         |
--  |   8	|SW	         |I-TYPE          |0100  |N/A	  |011         |
--  |   9	|BEQ	     |I-TYPE          |0101  |N/A	  |111 `       |
--  |   10	|JR	         |J-TYPE          |0110  |N/A	  |111         |
--  |   	|	         |	              |	     |		  |            |
--  -------------------------------------------------------------------- 

-- For BEQ and JR the operation is being performed by a separate circuitry in the decode stage 
-- and not by the ALU so we assign ALUControlID to "111" which will return NULL for those instructions.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Control_Unit is
	port( InstrD		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 	-- 16-bit instruction acts as the input.
			RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUsrcD,RegDstD,JumpD,PCSrcD_2: out STD_LOGIC:='0';
			ALUControlID: out STD_LOGIC_VECTOR (2 downto 0):= (others => '1')); 	-- we are considering 3 bits as we have only 6 ALU functions.		
end Control_Unit; 

-- Architecture Implementation:
architecture Control_Unit_arch of Control_Unit is

signal opcode		: STD_LOGIC_VECTOR (3 downto 0); 	-- opcode is of 4 bits
signal function_in  : STD_LOGIC_VECTOR (1 downto 0);		-- function is of 2 bits	

begin

	opcode <= InstrD (31 downto 28);
	function_in <= InstrD (1 downto 0);	

	process (opcode,function_in)
	begin
	
		-- Decoding for R-TYPE ALU Instructions:
		
		if opcode="0000" then
			RegWriteD<='1'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='0'; -- Will indicate that the instruction is not a load word
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			ALUsrcD  <='0'; -- Will set the select line of the mux to choose the register as the source for 2nd operand
			RegDstD  <='1'; -- Will set the select line of the mux to choose the destination register as Rd.
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			case function_in is 
			
				-- AND Function
				when "00" =>
					ALUControlID<= "000"; 	
		
				-- SUB Function
				when "01" =>
					ALUControlID<= "001";
					
				-- XOR Function
				when "10" =>
					ALUControlID<= "010"; 	
					
				-- ADD Function	
				when "11" =>
					ALUControlID<= "011"; 	
					
				when others =>
					NULL;
			
			end case;
			
		-- Decoding for I-TYPE ALU Instructions:
		elsif opcode="0001" then 
			RegWriteD<='1'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='0'; -- Will indicate that the instruction is not a load word
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			ALUsrcD  <='1'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='0'; -- Will set the select line of the mux to choose the destination register as Rt.
			ALUControlID<= "000"; -- ANDI Function
			
		elsif opcode="0010" then 
			RegWriteD<='1'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='0'; -- Will indicate that the instruction is not a load word
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			ALUsrcD  <='1'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='0'; -- Will set the select line of the mux to choose the destination register as Rt.
			ALUControlID<= "001"; -- SUBI Function		
			
		-- Decoding for I-TYPE Load and Store Instructions:
		elsif opcode="0011" then 
			RegWriteD<='1'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='1'; -- Will indicate that the instruction is a load word
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			ALUsrcD  <='1'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='0'; -- Will set the select line of the mux to choose the destination register as Rt.
			ALUControlID<= "011"; -- LW Function	
		
		elsif opcode="0100" then 
			RegWriteD<='0'; -- Will indicate that the output of the ALU has not to be written back to register
			MemtoRegD<='X'; -- Will set the select line of the mux as dont care (as we do not need data from Data mem or ALU output).
			MemWriteD<='1'; -- Will indicate that the instruction is a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			ALUsrcD  <='1'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='X'; -- Will set the select line of the mux to choose the destination register as Rt.
			ALUControlID<= "011"; -- SW Function	
	
		-- Decoding for I-TYPE BEQ Instructions:
		elsif opcode="0101" then 
			RegWriteD<='0'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='X'; -- Will set the select line of the mux as dont care (as we do not need data from Data mem or ALU output).
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='1'; -- Will indicate that the instruction is a branch instruction
			JumpD	 <='0'; -- Will indicate that the instruction is not a jump instruction
			PCSrcD_2 <='0'; -- Will indicate that the instruction is not a jump instruction
			ALUsrcD  <='0'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='X'; -- Will set the select line of the mux as dont care (as we are not writing anything into register).
			ALUControlID<= "111"; 

		-- Decoding for J-TYPE INSTRUCTION:
		elsif opcode="0110" then
			RegWriteD<='0'; -- Will indicate that the output of the ALU has to be written back to register
			MemtoRegD<='X'; -- Will set the select line of the mux as dont care (as we do not need data from Data mem or ALU output).
			MemWriteD<='0'; -- Will indicate that the instruction is not a store word
			BranchD  <='0'; -- Will indicate that the instruction is not a branch instruction
			JumpD	 <='1'; -- Will indicate that the instruction is a jump instruction
			PCSrcD_2 <='1'; -- Will indicate that the instruction is a jump instruction
			ALUsrcD  <='1'; -- Will set the select line of the mux to choose the imm value as the 2nd operand
			RegDstD  <='X'; -- Will set the select line of the mux as dont care (as we are not writing anything into register).
			ALUControlID<= "111"; 
		
		else 
			NULL;
			
		end if;
	end process;
end Control_Unit_arch;

-- end of Control_Unit.vhd