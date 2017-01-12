----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:20:47 11/21/2016 
-- Design Name: 
-- Module Name:    mymips_min_sopc - Behavioral 
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

entity mymips_min_sopc is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end mymips_min_sopc;

architecture Behavioral of mymips_min_sopc is
	COMPONENT mymips
	Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           

			tsre : in STD_LOGIC;
			tbre : in STD_LOGIC;
			data_ready : in STD_LOGIC;

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
	END COMPONENT;

	COMPONENT Ram2
	Port (  addr : in  STD_LOGIC_VECTOR (15 downto 0);
    	--	data_i : in  STD_LOGIC_VECTOR (15 downto 0);
     --      mem_addr : in  STD_LOGIC_VECTOR (15 downto 0);
     --      mem_data : in  STD_LOGIC_VECTOR (15 downto 0);
           
     --      clk : in  STD_LOGIC;
           control : in  ram_control;

           inst_io : inout  STD_LOGIC_VECTOR (15 downto 0));
	END COMPONENT;
	
	COMPONENT Ram1
	Port ( --clk : in  STD_LOGIC;
        --   data_i : in  STD_LOGIC_VECTOR (15 downto 0);
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           control : in  ram_control;
			  
           data_io : inout  STD_LOGIC_VECTOR (15 downto 0));
	END COMPONENT;
	
	--cpu输出
	signal ram1_control : ram_control;
	signal ram2_control : ram_control;
	signal mem_data : STD_LOGIC_VECTOR (15 downto 0);
	signal inst_data : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_addr : STD_LOGIC_VECTOR (17 downto 0);
	signal inst_addr : STD_LOGIC_VECTOR (17 downto 0);
	signal rdn : STD_LOGIC;
	signal wrn : STD_LOGIC;
	--ram2输出
	signal inst : STD_LOGIC_VECTOR (15 downto 0);
	--ram1输出
	signal data : STD_LOGIC_VECTOR (15 downto 0);
	
	signal temp : STD_LOGIC_VECTOR (15 downto 0);
	
begin

	mymips_INSTANCE : mymips PORT MAP (
			--in
			rst => rst,
			clk => clk,

			tsre => '1',
			tbre => '1',
			data_ready => '1',

			
			--out
			wrn => wrn,
			rdn => rdn,
			ram1_control => ram1_control,
			ram2_control => ram2_control,
			ram1_data_io => data,
			ram2_data_io => inst,
			ram1_addr_o => mem_addr,
			ram2_addr_o => inst_addr
	);
	
	ram1_INSTANCE : Ram1 PORT MAP (
			--in
		--	data_i => mem_data,
			addr => mem_addr(15 downto 0),
			control => ram1_control,
			--inout
			data_io => data
	);

	ram2_INSTANCE : Ram2 PORT MAP (
			--in 
		--	data_i => inst_data,
			addr => inst_addr(15 downto 0),
			control => ram2_control,
			--inout
			inst_io => inst
	);

end Behavioral;

