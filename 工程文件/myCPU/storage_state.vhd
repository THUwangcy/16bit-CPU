----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:13 11/24/2016 
-- Design Name: 
-- Module Name:    storage_state - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity storage_state is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  input : in STD_LOGIC_VECTOR (15 downto 0);
			  
           mem_MEMControl : out  mem_control;
           mem_ALUAns : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_ALUinputB : out  STD_LOGIC_VECTOR (15 downto 0);
           pc : out  STD_LOGIC_VECTOR (15 downto 0);
           pc_ram2_control : out  ram_control);
end storage_state;

architecture Behavioral of storage_state is
	type Step is (inputAddr, inputData, writeData1, writeData2, readData1, readData2, finish);
	signal reg_addr : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
	signal reg_data : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
begin

	process(clk, rst)
		variable state: Step := inputAddr;
		variable temp_memControl : mem_control := mem_control_none;
		variable temp_ALUAns : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ALUinputB : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_pc : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ram2_control : ram_control := ram_control_none;
	begin
		if (rst = '0') then
			state := inputAddr;
			temp_memControl.memWrite := writeDisable;
			temp_memControl.memRead := readDisable;
			temp_pc := Zero_16;
			temp_ram2_control := ram_control_none;
			temp_ALUAns := Zero_16;
				temp_ALUinputB := Zero_16;
		elsif (clk'event and clk = '1') then
			if(state = inputAddr) then
				reg_addr <= input;
				state := inputData;
			elsif(state = inputData) then
				reg_data <= input;
				temp_ALUAns := reg_addr;
				temp_ALUinputB := input;
				temp_memControl.memWrite := writeEnable;
				temp_memControl.memRead := readDisable;
				state := writeData1;
			elsif(state = writeData1) then
				temp_memControl.memWrite := writeEnable;
				temp_memControl.memRead := readDisable;
				temp_pc := reg_addr + '1';
				temp_ram2_control := ram_ReadEnable;
				state := writeData2;
			elsif(state = writeData2) then
				temp_memControl.memWrite := writeEnable;
				temp_memControl.memRead := readDisable;
				temp_ALUAns := reg_addr + '1';
				temp_ALUinputB := reg_data + '1';
				temp_pc := reg_addr + "10";
				temp_ram2_control := ram_ReadEnable;
				state := readData1;
			elsif(state = readData1) then
				temp_memControl.memWrite := writeDisable;
				temp_memControl.memRead := readEnable;
				temp_ALUAns := reg_addr;
				temp_ALUinputB := reg_data;
				temp_pc := reg_addr + "10";
				temp_ram2_control := ram_ReadEnable;
				state := readData2;
			elsif(state = readData2) then
				temp_memControl.memWrite := writeDisable;
				temp_memControl.memRead := readEnable;
				temp_ALUAns := reg_addr + '1';
				temp_ALUinputB := reg_data + '1';
				temp_pc := reg_addr + "10";
				temp_ram2_control := ram_ReadEnable;
				state := inputAddr;
			end if;
		end if;
		
		mem_MEMControl <= temp_memControl;
		mem_ALUAns <= temp_ALUAns;
		mem_ALUinputB <= temp_ALUinputB;
		pc <= temp_pc;
		pc_ram2_control <= temp_ram2_control;
	end process;

end Behavioral;

