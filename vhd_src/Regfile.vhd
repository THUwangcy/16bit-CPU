----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:34:53 11/18/2016 
-- Design Name: 
-- Module Name:    Regfile - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Regfile is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  
			  --写端口
           writeAddr : in  STD_LOGIC_VECTOR (3 downto 0);
           writeData : in  STD_LOGIC_VECTOR (15 downto 0);
           we : in  STD_LOGIC;
			  
			  --读端口1
           readAddr1 : in  STD_LOGIC_VECTOR (3 downto 0);
           readData1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --读端口2
           readAddr2 : in  STD_LOGIC_VECTOR (3 downto 0);
           readData2 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --twl 执行阶段数据前推
			  EX_RegWrite_I : in STD_LOGIC_VECTOR (3 downto 0);
			  EX_WriteData_I : in  STD_LOGIC_VECTOR (15 downto 0);
			  EX_RegWriteEnable_I : in STD_LOGIC;
			  
			  --twl 访存阶段数据前推
			  MEM_RegWrite_I : in STD_LOGIC_VECTOR (3 downto 0);
			  MEM_WriteData_I : in  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWriteEnable_I : in STD_LOGIC
			  
			  );
end Regfile;

architecture Behavioral of Regfile is
-- twl
--一： 定义寄存器
	signal regs : RegGroup := (others => (others => '0'));
begin
	
	--二： 写操作
	process(clk, rst)
	begin
	--	addr := CONV_INTEGER(writeAddr);
		if(rst = RstDisable) then
			if(rising_edge(clk)) then
				if(we = WriteEnable and writeAddr /= no_write) then
					regs(CONV_INTEGER(writeAddr)) <= writeData;
				end if;
			end if;
		end if;
	end process;
	
	--三 读端口1
	process(rst, readAddr1, writeAddr, writeData, we, EX_RegWrite_I,EX_WriteData_I,EX_RegWriteEnable_I,MEM_RegWrite_I,MEM_WriteData_I,MEM_RegWriteEnable_I)
		variable temp_readData1 : STD_LOGIC_VECTOR (15 downto 0);
	begin
		if(rst = RstEnable) then
			temp_readData1 := Zero_16;
		elsif(readAddr1 = no_read) then
			temp_readData1 := Zero_16;
		--<twl 前推
		elsif(EX_RegWriteEnable_I = WriteEnable and readAddr1 = EX_RegWrite_I) then
			temp_readData1 := EX_WriteData_I;
		elsif(MEM_RegWriteEnable_I = WriteEnable and readAddr1 = MEM_RegWrite_I) then
			temp_readData1 := MEM_WriteData_I;
		--twl>
		elsif(readAddr1 = writeAddr and we = WriteEnable) then
			temp_readData1 := writeData;
		else
			temp_readData1 := regs(CONV_INTEGER(readAddr1));
		end if;
		
		readData1 <= temp_readData1;
	end process;
	
	--读端口2
	process(rst, readAddr2, writeAddr, writeData, we, EX_RegWrite_I,EX_WriteData_I,EX_RegWriteEnable_I,MEM_RegWrite_I,MEM_WriteData_I,MEM_RegWriteEnable_I)
		variable temp_readData2 : STD_LOGIC_VECTOR (15 downto 0);
	begin
		if(rst = RstEnable) then
			temp_readData2 := Zero_16;
		elsif(readAddr2 = no_read) then
			temp_readData2 := Zero_16;
		--<twl 前推
		elsif(EX_RegWriteEnable_I = WriteEnable and readAddr2 = EX_RegWrite_I) then
			temp_readData2 := EX_WriteData_I;
		elsif(MEM_RegWriteEnable_I = WriteEnable and readAddr2 = MEM_RegWrite_I) then
			temp_readData2 := MEM_WriteData_I;
		--twl>
		elsif(readAddr2 = writeAddr and we = WriteEnable) then
			temp_readData2 := writeData;
		else
			temp_readData2 := regs(CONV_INTEGER(readAddr2));
		end if;
		
		readData2 <= temp_readData2;
	end process;

end Behavioral;

