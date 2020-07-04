-- Project		: COEN6741
-- File Name	: Register_file.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This module acts as the Register_file for the MIPS Architecture
-- with 32-Registers each of size 32-bits. We have alloted 7-bits to the Register field. 
-- But we are using only 5 because just 32 Registers are enough for our operation. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;		-- used to perform arithmetic operations for vectors.

-- Entity Declaration: 
entity Register_file is
	port( 	clk,JumpD	: in STD_LOGIC:='0';
			InstrD		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0'); 
			RegWriteW	: in STD_LOGIC:='0';
			ResultW		: in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			WriteRegW	: in STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
			read_data_1	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			read_data_2	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			PCJumpD 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0'));
end Register_file; 	
	
-- Architecture Implementation:
architecture Register_file_arch of Register_file is

-- Declaration of register array with 32 registers each of 32 bits.
-- signal R indicates the element of the array
type reg_array is array (0 to 31) of std_logic_vector (31 downto 0);
signal R: reg_array := (others=>(others=>'0'));

-- Signal Declarations:
signal write_enable_3:STD_LOGIC; -- WE3 (Enable pin used to write the data back to the register)			
signal address_1: STD_LOGIC_VECTOR (4 downto 0); 	-- A1 (Reg address for first operand)
signal address_2: STD_LOGIC_VECTOR (4 downto 0); 	-- A2 (Reg address for second operand)
signal address_3: STD_LOGIC_VECTOR (4 downto 0); 	-- A3 (Reg address for target reg/ Write back reg)
signal write_data_3: STD_LOGIC_VECTOR (31 downto 0);--WD3 (Data pin carrying the data to be written into reg)
signal reset: STD_LOGIC:= '1'; -- Reset - an internal signal used to set the registers to intialize to default values at the begining of the execution.

begin

	-- Assign values to the signals:
	write_enable_3 <= RegWriteW;
	address_1 <= InstrD (27 downto 23);
	address_2 <= InstrD (22 downto 18);
	address_3 <= WriteRegW;
	write_data_3<= ResultW;	
	
	-- Output the data for two operands from the desired registers:
	read_data_1 <= R(to_integer(unsigned(address_1)));
	read_data_2 <= R(to_integer(unsigned(address_2)));

  process(clk,JumpD)
	begin 
	
		-- In MIPS the Register R(0) will always be set to '0'
		R(0) <= x"00000000"; -- Decimal: 00
		R(1) <= x"0000000F"; -- Decimal: 15
		R(2) <= x"0000000E"; -- Decimal: 15
		R(15) <= x"00000034"; -- Decimal: 52
		
		if (JumpD='1') then 
			PCJumpD <= R(to_integer(unsigned(address_1)));
		end if;
		
		-- Write the write back data into the register:	
		if(rising_edge(clk)) then
			if write_enable_3='1' then
				R(to_integer(unsigned(address_3))) <= write_data_3;
			end if;
		end if;
	end process;
	
end Register_file_arch;

-- end of Register_file.vhd