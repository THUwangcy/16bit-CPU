----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:20:15 11/19/2016 
-- Design Name: 
-- Module Name:    MEM_WB - Behavioral 
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

entity MEM_WB is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  MEM_WBControl : in wb_control;
			  
			  RAM_Data : in STD_LOGIC_VECTOR (15 downto 0);
			  ALUAns : in STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  WB_WBControl : out wb_control;
			  RegWriteData : out STD_LOGIC_VECTOR (15 downto 0);
			  WB_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
end MEM_WB;

architecture Behavioral of MEM_WB is

begin
	process(clk, rst)
		variable temp_WBControl :  wb_control;
		variable temp_RegWriteData : STD_LOGIC_VECTOR (15 downto 0);
		variable temp_RegWrite : STD_LOGIC_VECTOR (3 downto 0);

	begin 
		if(rst = RstEnable) then
			temp_WBControl.regWrite := WriteDisable;
			temp_WBControl.memToReg := NONE;
			
			temp_RegWriteData := Zero_16;
			temp_RegWrite := no_write;
		elsif(rising_edge(clk)) then
			temp_WBControl := MEM_WBControl;
			temp_RegWrite := MEM_RegWrite;
			if (MEM_WBControl.regWrite = WriteEnable) then
				if	(MEM_WBControl.memToReg = ALU) then
					temp_RegWriteData := ALUAns;
				elsif (MEM_WBControl.memToReg = Mem) then
					temp_RegWriteData := RAM_Data;
					--选择ram1或ram2
					--RAM1_Data_I;
					--RAM2_Data_I;
				else
					temp_RegWriteData := Zero_16;
				end if;
			else
				temp_RegWriteData := Zero_16;
			end if;
		end if;
		WB_WBControl <= temp_WBControl; --是否需要？
		RegWriteData <= temp_RegWriteData;
		WB_RegWrite <= temp_RegWrite;
	end process;


end Behavioral;

