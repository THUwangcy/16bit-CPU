----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:02:32 11/22/2016 
-- Design Name: 
-- Module Name:    Ram1_adapter - Behavioral 
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
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ram1_adapter is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  MEMControl_i : in  mem_control;
			  ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  ALUinputB_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  data_ready : in STD_LOGIC;
           
			  ram1_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_addr_o : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  ram2_control_o : out  ram_control;
           ram1_control_o : out  ram_control);
end Ram1_adapter;

architecture Behavioral of Ram1_adapter is

begin

	process(rst, clk, MEMControl_i, ALUAns_i, ALUinputB_i, ram1_data_io)
		variable temp_mem_addr : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_mem_data : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_ram1_control : ram_control := ram_control_none;
		variable temp_ram2_control : ram_control := ram_control_none;
		variable temp_wrn : STD_LOGIC := '1';
		variable temp_rdn : STD_LOGIC := '1';
	begin
		if(rst = RstEnable) then
			temp_mem_addr := Zero_16;
			temp_mem_data := Zero_16;
			temp_ram1_control := ram_control_none;
			temp_ram2_control := ram_control_none;
			
			temp_wrn := '1';
			temp_rdn := '1';
		else
			
			if(MEMControl_i.memRead = ReadEnable) then
				temp_wrn := '1';
				if(ALUAns_i(15) = '1') then
					--特判串口
					if(ALUAns_i = SerialStateAddr) then
						temp_mem_addr := Zero_16;
						temp_mem_data := Zero_16;
						temp_ram1_control := ram_control_none;
						
						temp_rdn := '1';
					elsif(ALUAns_i = SerialAddr) then
						temp_mem_addr := Zero_16;
						temp_mem_data := HighZ_16;
						
						temp_rdn := clk;
		
						temp_ram1_control := ram_control_none;
					else
						temp_mem_addr := ALUAns_i;
						temp_mem_data := HighZ_16;
						
						temp_ram1_control.EN := clk;
						temp_ram1_control.OE := clk;
						temp_ram1_control.WE := '1';
						
						temp_rdn := '1';
					end if;
					
					temp_ram2_control := ram_control_none;
				else   --有结构冲突
					temp_mem_addr := ALUAns_i;
					temp_mem_data := HighZ_16;
					temp_ram2_control := ram_ReadEnable;
					temp_ram1_control := ram_control_none;
					
					temp_rdn := '1';
				end if;
			elsif(MEMControl_i.memWrite = WriteEnable) then
				temp_rdn := '1';
				if(ALUAns_i(15) = '1') then
					--特判串口
					if(ALUAns_i = SerialAddr) then
						temp_mem_addr := Zero_16;
						temp_mem_data := ALUinputB_i;
						temp_ram1_control := ram_control_none;
						
						temp_wrn := clk;
					else
						temp_mem_addr := ALUAns_i;
						temp_mem_data := ALUinputB_i;
					
						temp_ram1_control.EN := clk;
						temp_ram1_control.WE := clk;
						temp_ram1_control.OE := '1';
						
						temp_wrn := '1';
					end if;
				
					temp_ram2_control := ram_control_none;
					
				else --存在结构冲突
					temp_mem_addr := ALUAns_i;
					temp_mem_data := ALUinputB_i;

					temp_ram2_control := ram_WriteEnable;

					temp_ram1_control := ram_control_none;
					
					temp_wrn := '1';
				end if;
			else
				temp_mem_addr := Zero_16;
				temp_mem_data := Zero_16;
				temp_ram1_control := ram_control_none;
				temp_ram2_control := ram_control_none;
			end if;
		end if;
		
		mem_addr_o <= temp_mem_addr;
		mem_data_o <= temp_mem_data;
		ram1_control_o <= temp_ram1_control;
		ram2_control_o <= temp_ram2_control;
		
		ram1_data_io <= temp_mem_data;
		
		wrn <= temp_wrn;
		rdn <= temp_rdn;
	end process;
	
	process(ram1_data_io, ALUAns_i, MEMControl_i, data_ready, tsre, tbre)
	
	begin
		if(MEMControl_i.memRead = ReadEnable and ALUAns_i = SerialStateAddr) then
			ram1_adapter_data_o <= (Zero_14 & data_ready & (tsre and tbre));
		else
			ram1_adapter_data_o <= ram1_data_io;
		end if;
	end process;

end Behavioral;

