----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:05:20 11/23/2016 
-- Design Name: 
-- Module Name:    ram2_adapter - Behavioral 
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
use work.type_lib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram2_adapter is
    Port ( clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  pc : in  STD_LOGIC_VECTOR (15 downto 0);
           has_ram_conflict : in  STD_LOGIC;
			  
			  booting : in STD_LOGIC;
			  flash_addr_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  flash_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           mem_addr_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_ram2_control_i : in  ram_control; 
			  
			  ram2_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);  --从ram2读进来的数据再输出去
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_control_o : out  ram_control);
end ram2_adapter;

architecture Behavioral of ram2_adapter is

begin

	process(clk, rst, pc, has_ram_conflict, mem_addr_i, mem_data_i, mem_ram2_control_i, booting)
		variable temp_ram2_addr : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ram2_data : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ram2_control : ram_control := ram_control_none;
	begin
		if(rst = RstEnable) then
			temp_ram2_addr := Zero_16;
			temp_ram2_data := Zero_16;
			temp_ram2_control := ram_control_none;
		elsif(booting = '0') then
			temp_ram2_addr := flash_addr_i;
			temp_ram2_data := flash_data_i;
			
			temp_ram2_control.EN := clk;
			temp_ram2_control.WE := clk;
			temp_ram2_control.OE := '1';
		else
			if(has_ram_conflict = NoConflict) then
				--pc这边一定是读，数据线直接置高阻
				temp_ram2_addr := pc;
				temp_ram2_data := HighZ_16;
				
				temp_ram2_control.EN := clk;
				temp_ram2_control.OE := clk;
				temp_ram2_control.WE := '1';
			elsif(has_ram_conflict = Conflict) then
				if(mem_ram2_control_i = ram_ReadEnable) then
					temp_ram2_addr := mem_addr_i;
					temp_ram2_data := HighZ_16;
					
					temp_ram2_control.EN := clk;
					temp_ram2_control.OE := clk;
					temp_ram2_control.WE := '1';
				elsif(mem_ram2_control_i = ram_WriteEnable) then
					temp_ram2_addr := mem_addr_i;
					temp_ram2_data := mem_data_i;
					
					temp_ram2_control.EN := clk;
					temp_ram2_control.WE := clk;
					temp_ram2_control.OE := '1';
				else
					temp_ram2_addr := Zero_16;
					temp_ram2_data := Zero_16;
					temp_ram2_control := ram_control_none;
				end if;
			else
				temp_ram2_addr := Zero_16;
				temp_ram2_data := Zero_16;
				temp_ram2_control := ram_control_none;
			end if;
		end if;
		
		ram2_addr_o(15 downto 0) <= temp_ram2_addr;
		ram2_addr_o(17 downto 16) <= "00";
		ram2_data_io <= temp_ram2_data;
		ram2_control_o <= temp_ram2_control;
	end process;
	
	--接收ram2的读出的数据并及时送到输出
	process(ram2_data_io)
	begin
		ram2_adapter_data_o <= ram2_data_io;
	end process;
	

end Behavioral;

