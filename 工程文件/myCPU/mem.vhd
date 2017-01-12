----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:24:32 11/20/2016 
-- Design Name: 
-- Module Name:    mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
    Port ( 
			  rst : in  STD_LOGIC;
           MEMControl_i : in  mem_control;
           ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  --load指令加入
			  Ram1Data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  --结构冲突
			  Ram2Data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  stallreq_ram_conflict : out STD_LOGIC;
			  ALUAns_o : out STD_LOGIC_VECTOR (15 downto 0);

           RamData_o : out  STD_LOGIC_VECTOR (15 downto 0));     --输出解决结构冲突的读出来的地址
end mem;

architecture Behavioral of mem is

begin


	process(rst, MEMControl_i, ALUAns_i, Ram1Data_i, Ram2Data_i)
		variable temp_RamData : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ALUAns : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		
	begin 
		if(rst = RstEnable) then
			temp_RamData := Zero_16;
			temp_ALUAns := Zero_16;
		else
			temp_ALUAns := ALUAns_i;
			
			if(MEMControl_i.memRead = ReadEnable) then
				if(ALUAns_i(15) = '1') then   
					temp_RamData := Ram1Data_i;
				else   --有结构冲突
					temp_RamData := Ram2Data_i;
				end if;
			elsif(MEMControl_i.memWrite = WriteEnable) then
				temp_RamData := Zero_16;
			else   --默认为ALU的输出
				temp_RamData := ALUAns_i;
			end if;
			
		end if;
		
		RamData_o <= temp_RamData;
		ALUAns_o <= temp_ALUAns;
		
	end process;
	
	
	process(rst, MEMControl_i, ALUAns_i)
		variable temp_stallreq : STD_LOGIC := NoStop;
	begin
		if(rst = RstEnable) then
			temp_stallreq := NoStop;
		else
			--判断是否需要结构冲突暂停
			if(ALUAns_i(15) = '0' and (MEMControl_i.memRead = ReadEnable or MEMControl_i.memWrite = WriteEnable)) then 
				temp_stallreq := Stop;
			else
				temp_stallreq := NoStop;
			end if;
		end if;
		
		stallreq_ram_conflict <= temp_stallreq;
	end process;
	
end Behavioral;

