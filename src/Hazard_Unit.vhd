-- File Name	: Hazard_Unit.vhd 
-- Author		: Sibi Ravichandran
-- Date			: 13-Mar-2019
-- Description	: This unit is used to handle the hazards that occurs in the pipeline. 
-- We use Forwarding technique to resolve read after write hazard. 
-- We implement stalls for handling the load word hazard and control hazard. 

--------------------------------------------------------------------------

-- Declare library files:
library IEEE;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Entity Declaration: 
entity Hazard_Unit is
	port( clk : in STD_LOGIC := '0';
	    RegWriteW,RegWriteM,RegWriteE,MemtoRegM,MemtoRegE	: in STD_LOGIC:= '0';
		  WriteRegM,WriteRegW,WriteRegE_to_Hazard_Unit		: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		  RsE,RtE,RsD,RtD									: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0'); 
		  BranchD_to_Hazard_Unit,JumpD_to_Hazard_Unit		: in STD_LOGIC :='0';
		  FlushE,StallD,StallF				: out STD_LOGIC:='0';
		  ForwardAE,ForwardBE				: out STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		  ForwardAD,ForwardBD				: out STD_LOGIC:='0');
end Hazard_Unit;

-- Architecture Implementation:
architecture Hazard_Unit_arch of Hazard_Unit is

-- Signal Declaration:
signal lwstall, branchstall: STD_LOGIC:= '0';

begin

	process (BranchD_to_Hazard_Unit,JumpD_to_Hazard_Unit,clk)
	
	begin
	
	-- FORWARDING TECHNIQUE:
	-- Data Hazard: Read After Write using Forwarding Technique: 
		-- If the source Register of instruction being executed is same as the write register of instruction that is in Mem stage:
		if ((RsE/="00000") AND (RsE = WriteRegM) AND (RegWriteM='1')) then 
			ForwardAE <= "10"; 
		-- If the source Register of instruction being executed is same as the write register of instruction that is in WB stage:
		elsif ((RsE/="00000") AND (RsE = WriteRegW) AND (RegWriteW='1')) then 
			ForwardAE <= "01";
		else 
			ForwardAE <= "00";
		end if; 
		
		-- If the target Register of instruction being executed is same as the write register of instruction that is in Mem stage:
		if ((RtE/="00000") AND (RtE = WriteRegM) AND (RegWriteM='1')) then
			ForwardBE <= "10";
		-- If the target Register of instruction being executed is same as the write register of instruction that is in WB stage:
		elsif ((RtE/="00000") AND (RtE = WriteRegW) AND (RegWriteW='1')) then 
			ForwardBE <= "01";
		else 
			ForwardBE <= "00";
		end if;

	-- Branch Hazard Data dependency for BEQ insturction is being solved by forwarding data to decode stage:
		if (BranchD_to_Hazard_Unit='1') then 
			if ((RsD/="00000") AND (RsD=WriteRegM) AND (RegWriteM='1')) then 
				ForwardAD <='1';
			else 
				ForwardAD <= '0';
			end if;
			
			if ((RtD/="00000") AND (RtD=WriteRegM) AND (RegWriteM='1')) then 
				ForwardBD <='1';
			else 
				ForwardBD <= '0';
			end if;
		end if;
	
	-- STALL TECHNIQUE:
	-- Branch Stall: BEQ Function or Jump Function: 
		if (BranchD_to_Hazard_Unit='1' or JumpD_to_Hazard_Unit = '1') then
			StallF<='1';
			-- StallD <= '1'; commented out because the IF to ID Buffer will be cleared by PCSrcD
			FlushE<='1';
	-- Data Hazard: Load Word Resolved using Stall Operation: 
		elsif ((((RsD=RtE) OR (RtD=RtE)) and MemtoRegE='1') or (MemtoRegM='1' and ((RsE = WriteRegM) or (RtE = WriteRegM)))) then 
			StallF<='1';
			StallD<='1';
			FlushE<='1';
		else 
			FlushE<='0';
			StallF<='0';
			StallD<='0';
		end if;
	end process;
end Hazard_Unit_arch;

-- end of Hazard_Unit.vhd