----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:48 11/24/2016 
-- Design Name: 
-- Module Name:    storage_test - Behavioral 
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

entity storage_test is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  output: out STD_LOGIC_VECTOR (15 downto 0);
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
           ram1_control : out ram_control;
           ram2_control : out ram_control;
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram1_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0));
end storage_test;

architecture Behavioral of storage_test is
	
	COMPONENT Ram1_adapter
	Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  MEMControl_i : in  mem_control;
			  ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  ALUinputB_i : in  STD_LOGIC_VECTOR (15 downto 0);
			--  ram1_adapter_data_i : in STD_LOGIC_VECTOR (15 downto 0);
           
			  ram1_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
			  has_ram_conflict : out STD_LOGIC;
           mem_addr_o : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
			  ram2_control_o : out  ram_control;
           ram1_control_o : out  ram_control);
	END COMPONENT;
	
	COMPONENT ram2_adapter
	Port ( rst : in STD_LOGIC;
			  pc : in  STD_LOGIC_VECTOR (15 downto 0);
           pc_ram2_control_i : in  ram_control;
           has_ram_conflict : in  STD_LOGIC;
           mem_addr_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_ram2_control_i : in  ram_control;
		--	  ram2_adapter_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  ram2_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_control_o : out  ram_control);
	END COMPONENT;
	
	COMPONENT storage_state
	Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  input : in STD_LOGIC_VECTOR (15 downto 0);
			  
           mem_MEMControl : out  mem_control;
           mem_ALUAns : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_ALUinputB : out  STD_LOGIC_VECTOR (15 downto 0);
           pc : out  STD_LOGIC_VECTOR (15 downto 0);
           pc_ram2_control : out  ram_control);
	END COMPONENT;
	
	--ram1_adapter输出
	signal ram1_adapter_data_o : STD_LOGIC_VECTOR (15 downto 0); 
	signal mem_addr_o : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_data_o : STD_LOGIC_VECTOR (15 downto 0);
	signal ram2_control_o : ram_control;
	signal ram1_control_o : ram_control;
	signal has_ram_conflict : STD_LOGIC;
	--ram2_adapter输出
	signal ram2_adapter_data_o : STD_LOGIC_VECTOR (15 downto 0); 
	--状态机输出
	signal pc : std_logic_vector(15 downto 0);
	signal pc_ram2_control : ram_control;
	signal mem_MEMControl_i : mem_control;
	signal mem_ALUAns_i : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_ALUinputB_i : STD_LOGIC_VECTOR (15 downto 0);
begin
	
	storage_state_INSTANCE : storage_state PORT MAP (
			rst => rst,
			clk => clk,
			input => input,
			mem_MEMControl => mem_MEMControl_i,
			mem_ALUAns => mem_ALUAns_i,
			mem_ALUinputB => mem_ALUinputB_i,
			pc => pc, 
		   pc_ram2_control => pc_ram2_control
	);
	
	ram1_adapter_INSTANCE: Ram1_adapter PORT MAP (
			--in
			rst => rst,
			clk => clk,
			MEMControl_i => mem_MEMControl_i,    --
			ALUAns_i => mem_ALUAns_i,            --
			ALUinputB_i => mem_ALUinputB_i,      --
		--	ram1_adapter_data_i => ram1_data_i,
			--out
			ram1_adapter_data_o => ram1_adapter_data_o,
			mem_addr_o => mem_addr_o,
			mem_data_o => mem_data_o,
			ram1_data_io => ram1_data_io,
			ram1_control_o => ram1_control_o,
			ram2_control_o => ram2_control_o,
			has_ram_conflict => has_ram_conflict,
			wrn => wrn,
			rdn => rdn
	);
	
	process(mem_addr_o, mem_data_o, ram1_control_o)
	begin
		ram1_addr_o(17 downto 0) <= ("00" & mem_addr_o);
		ram1_control <= ram1_control_o;
	end process;
	
	ram2_adapter_INSTANCE: ram2_adapter PORT MAP (
			--in
			rst => rst,
			pc => pc,                                 --
			pc_ram2_control_i => pc_ram2_control,     --
			has_ram_conflict => has_ram_conflict,
			mem_addr_i => mem_addr_o,
			mem_data_i => mem_data_o,
			mem_ram2_control_i => ram2_control_o,
		--	ram2_adapter_data_i => ram2_data_i,

			ram2_adapter_data_o => ram2_adapter_data_o,
			ram2_addr_o => ram2_addr_o,
			ram2_data_io => ram2_data_io,
			ram2_control_o => ram2_control
	);
	
	process(ram2_adapter_data_o, ram1_adapter_data_o)
	begin
		output(15 downto 8) <= ram2_adapter_data_o(7 downto 0);
		output(7 downto 0) <= ram1_adapter_data_o(7 downto 0);
	end process;

end Behavioral;

