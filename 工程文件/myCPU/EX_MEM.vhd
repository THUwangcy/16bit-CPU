----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:02 11/19/2016 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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

entity EX_MEM is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  EX_MEMControl : in mem_control;
			  EX_WBControl : in wb_control;
			  
			  EX_ALUAns : in STD_LOGIC_VECTOR (15 downto 0);
			  EX_ALUinputB: in STD_LOGIC_VECTOR (15 downto 0);
			  EX_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  
			  MEM_MEMControl : out mem_control;
			  MEM_WBControl : out wb_control;
			  
			  MEM_ALUAns : out STD_LOGIC_VECTOR (15 downto 0);
			  MEM_ALUinputB : out STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
end EX_MEM;

architecture Behavioral of EX_MEM is

begin

--	mem_MEMControl.memRead <= ReadDisable;
--	mem_MEMControl.memWrite <= WriteDisable;
--	
--	mem_WBControl.regWrite <= WriteDisable;
--	mem_WBControl.memToReg <= NONE;
--	
--	mem_ALUAns <= Zero_16;
--	mem_ALUinputB <= Zero_16;
--	mem_RegWrite <= Zero_4;
	process(clk, rst)
		variable	temp_MEMControl :  mem_control := mem_control_none;
		variable temp_WBControl :  wb_control := wb_control_none;
		
		variable temp_ALUAns : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ALUinputB : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_RegWrite : STD_LOGIC_VECTOR (3 downto 0) := Zero_4;

	begin 
		if(rst = RstEnable) then
			temp_MEMControl.memRead := ReadDisable;
			temp_MEMControl.memWrite := WriteDisable;
			
			temp_WBControl.regWrite := WriteDisable;
			temp_WBControl.memToReg := NONE;
			
			temp_ALUAns := Zero_16;
			temp_ALUinputB := Zero_16;
			temp_RegWrite := Zero_4;
		elsif(rising_edge(clk)) then
			temp_MEMControl := EX_MEMControl;
			temp_WBControl := EX_WBControl;
			temp_ALUAns := EX_ALUAns;
			temp_ALUinputB := EX_ALUinputB;
			temp_RegWrite := EX_RegWrite;
			
		end if;
		
		MEM_MEMControl <= temp_MEMControl;
		MEM_WBControl <= temp_WBControl;
		MEM_ALUAns <= temp_ALUAns;
		MEM_ALUinputB <= temp_ALUinputB;
		MEM_RegWrite <= temp_RegWrite;	
	end process;

end Behavioral;





