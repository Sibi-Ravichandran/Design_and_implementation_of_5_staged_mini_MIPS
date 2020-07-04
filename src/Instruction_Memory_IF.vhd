-- Project		: COEN6741
-- File Name	: Instruction_Memory_IF.vhd 
-- Author		: Nishanth
-- Date			: 13-Mar-2019
-- Description	: This module is a memory which holds 32-bit instructions. 
-- The instruction memory will give the 32-bit instruction as output depending
-- on the address pointed by Program Counter.

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Instruction_Memory_IF is
	port( 	PCF			: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 		-- A in the block diagram: Address- 32-bits
			InstrF		: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));	-- RD in the block diagram: Instruction size-32-bits
end Instruction_Memory_IF; 

-- Architecture Implementation:
architecture Instruction_Memory_IF_arch of Instruction_Memory_IF is

-- Declaration of instruction memory of 1024 rows and each row is of 8-bits. 
-- As the size of one instruction is 32-bits PC+4 will point to the next instruction.

type Inst_mem is array (0 to 1023) of std_logic_vector (7 downto 0); 
signal IM: Inst_mem;
signal address: STD_LOGIC_VECTOR (9 downto 0); -- Number of rows in the memory is 1023 which will be indicated by 10 bits only.
begin

	-- Assign the address with the lower 10-bits of PCF as the maximum value of address is 1023:
	address <= PCF(9 downto 0);

	-- Loaded the following instructions in the instruction memory 
	-- BEQ OPERATION: 
	-- BEQ 	R1 R2 #3	-	0101	00001		00010		100000000000000000			= 5088 0003
	-- AND 	R1 R2 R3    -	0000	00001		00010		00011 		00000000000	00 	= 0088 6000
	-- SUB 	R1 R2 R4    -	0000	00001		00010		00100		00000000000	01 	= 0088 8001
	-- ADD 	R1 R2 R5    -	0000	00001		00010		00101		00000000000	11 	= 0088 A003
	-- ---------------
	-- ALU Operation R-TYPE and SW operation with RAW Hazard:
	-- AND 	R1 R2 R3 	-	0000	00001		00010		00011		00000000000	00 	= 0088 6000	
	-- SW	R0 R3 #1 	-	0100 	00000		00011		000000000000000001			= 400C 0001
	-- ADD 	R3 R2 R4    -	0000	00011		00010		00100		00000000000	11	= 0188 8003
	-- SUB 	R4 R1 R5    -	0000	00100		00011		00101		00000000000	01	= 0204 A001
	-- XOR	R5 R4 R6    -	0000	00101		00100		00110		00000000000	10	= 0290 C002
	-- -----------------
	-- JR OPERATION: 
	-- JR 	#48 		-	0110	01111		0000000000000000000000000000			= 6780 0000
	-- ANDI R1 R7 #25   -	0001	00001		00111	 ‭	000000000000011001‬			= 109C 0019
	-- AND 	R1 R2 R3    -	0000	00001		00010		00011		00000000000	00	= 0088 6000
	-- ----------------
	-- LW Operation: 
	-- LW 	R0 R7 #0 	-	0011	00000		00111		000000000000000000			= 301C 0000
	-- ------------------
	-- ALU Operation I-TYPE with RAW Hazard from LW Instruction: 
	-- ANDI R7 R1 #23	-	0001	00111		00001		000000000000010111			= 1384 0017	
  -- SUBI R7 R3 #7    -   0010  00111   00011   000000000000000111      = 238C 0007
	
	-- Store the instructions here:
	IM(0) 		<=X"07" ; 	IM(1)  	<= 	X"84";  IM(2)  	<= X"60"; 	IM(3)  	<= X"00"; -- AND 	R1 R15 R3   = 0784 6000
	IM(4)		<=X"50" ; 	IM(5) 	<= 	X"88";  IM(6) 	<= X"00"; 	IM(7) 	<= X"03"; -- BEQ 	R1 R2 #3	= 5088 0003
	IM(8) 		<=X"00" ; 	IM(9) 	<= 	X"88";  IM(10)	<= X"60"; 	IM(11)	<= X"00"; -- AND 	R1 R2 R3    = 0088 6000
	IM(12) 		<=X"00" ; 	IM(13)	<= 	X"88";  IM(14) 	<= X"80"; 	IM(15) 	<= X"01"; -- SUB 	R1 R2 R4    = 0088 8001
	IM(16)		<=X"00" ; 	IM(17) 	<= 	X"88"; 	IM(18) 	<= X"A0"; 	IM(19) 	<= X"03"; -- ADD 	R1 R2 R5    = 0088 A003
	IM(20)		<=X"00" ; 	IM(21) 	<= 	X"88"; 	IM(22) 	<= X"60"; 	IM(23) 	<= X"00"; -- AND 	R1 R2 R3 	= 0088 6000	
	IM(24)		<=X"40" ; 	IM(25) 	<= 	X"0C"; 	IM(26) 	<= X"00"; 	IM(27) 	<= X"01"; -- SW		R0 R3 #1 	= 400C 0001
	IM(28)		<=X"01" ; 	IM(29) 	<= 	X"88"; 	IM(30) 	<= X"80"; 	IM(31) 	<= X"03"; -- ADD 	R3 R2 R4    = 0188 8003
	IM(32)		<=X"02" ; 	IM(33) 	<= 	X"0C"; 	IM(34) 	<= X"A0"; 	IM(35) 	<= X"01"; -- SUB 	R4 R1 R5    = 0204 A001
	IM(36)		<=X"02" ; 	IM(37) 	<= 	X"90"; 	IM(38) 	<= X"C0"; 	IM(39) 	<= X"02"; -- XOR	R5 R4 R6    = 0290 C002
	IM(40)		<=X"67" ; 	IM(41) 	<= 	X"80"; 	IM(42) 	<= X"00"; 	IM(43) 	<= X"00"; -- JR 	#48 		= 6780 0000
	IM(44)		<=X"10" ; 	IM(45) 	<= 	X"9C"; 	IM(46) 	<= X"00"; 	IM(47) 	<= X"19"; -- ANDI 	R1 R7 #25   = 109C 0019
	IM(48)		<=X"00" ; 	IM(49) 	<= 	X"88"; 	IM(50) 	<= X"60"; 	IM(51) 	<= X"00"; -- AND 	R1 R2 R3    = 0088 6000
	IM(52)		<=X"30" ; 	IM(53) 	<= 	X"1C"; 	IM(54) 	<= X"00"; 	IM(55) 	<= X"00"; -- LW 	R0 R7 #0 	= 301C 0000
	IM(56)		<=X"13" ; 	IM(57) 	<= 	X"84"; 	IM(58) 	<= X"00"; 	IM(59) 	<= X"17"; -- ANDI  	R7 R1 #23	= 1384 0017	
	IM(60)		<=X"23" ; 	IM(61) 	<= 	X"8C"; 	IM(62) 	<= X"00"; 	IM(63) 	<= X"07"; -- SUBI   R7 R3 #7    = 238C 0007

	
	-- Combining four bytes to form a single 32-bit instruction.
	InstrF<=IM(to_integer(unsigned(address))) & IM(to_integer(unsigned(address))+1) & IM(to_integer(unsigned(address)) +  2) & IM(to_integer(unsigned(address)) +3);

end Instruction_Memory_IF_arch;

-- end of Instruction_Memory_IF.vhd