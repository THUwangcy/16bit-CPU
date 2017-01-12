----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:18:23 11/19/2016 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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

entity ID_EX is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  ID_EXControl : in ex_control;
			  ID_MEMControl : in mem_control;
			  ID_WBControl : in wb_control;
			  stall : in  STD_LOGIC_VECTOR (4 downto 0);
  --       EX_flush : in  STD_LOGIC;
  
			  ID_Reg1 : in STD_LOGIC_VECTOR (15 downto 0);
			  ID_Reg2 : in STD_LOGIC_VECTOR (15 downto 0);
			  ID_Imme : in STD_LOGIC_VECTOR (15 downto 0);
			  
			  ID_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  EX_EXControl : out ex_control;
			  EX_MEMControl : out mem_control;
			  EX_WBControl : out wb_control;
			  
			  EX_Reg1 : out STD_LOGIC_VECTOR (15 downto 0);
			  EX_Reg2 : out STD_LOGIC_VECTOR (15 downto 0);
			  EX_Imme : out STD_LOGIC_VECTOR (15 downto 0);
			  
			  EX_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));

end ID_EX;

architecture Behavioral of ID_EX is

begin
	process(clk, rst)
		variable temp_EXControl :  ex_control := ex_control_none;
		variable	temp_MEMControl :  mem_control := mem_control_none;
		variable temp_WBControl :  wb_control := wb_control_none;
		--  variable EX_flush : STD_LOGIC;
		variable temp_Reg1 : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_Reg2 : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_Imme : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_RegWrite : STD_LOGIC_VECTOR (3 downto 0) := Zero_4;

	begin 
		if(rst = RstEnable) then
			temp_EXControl := ex_control_none;
			temp_MEMControl := mem_control_none;
			temp_WBControl := wb_control_none;
			
			temp_Reg1 := Zero_16;
			temp_Reg2 := Zero_16;
			temp_Imme := Zero_16;
			temp_RegWrite := no_write;
		elsif(rising_edge(clk)) then
			if(stall(2) = Stop and stall(3) = NoStop) then
				temp_EXControl := ex_control_none;
				temp_MEMControl := mem_control_none;
				temp_WBControl := wb_control_none;
				
				temp_Reg1 := Zero_16;
				temp_Reg2 := Zero_16;
				temp_Imme := Zero_16;
				temp_RegWrite := no_write;
			elsif(stall(2) = NoStop) then
				temp_EXControl := ID_EXControl;
				temp_MEMControl := ID_MEMControl;
				temp_WBControl := ID_WBControl;
				-- flush
				temp_Reg1 := ID_Reg1;
				temp_Reg2 := ID_Reg2;
				temp_Imme := ID_Imme;
				temp_RegWrite := ID_RegWrite;
			end if;
			
		end if;
		EX_EXControl <= temp_EXControl;
		EX_MEMControl <= temp_MEMControl;
		EX_WBControl <= temp_WBControl;
		-- flush
		EX_Reg1 <= temp_Reg1;
		EX_Reg2 <= temp_Reg2;
		EX_Imme <= temp_Imme;
		EX_RegWrite <= temp_RegWrite;	
	end process;

end Behavioral;



