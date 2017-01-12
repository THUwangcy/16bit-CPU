----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:53 11/30/2016 
-- Design Name: 
-- Module Name:    mymips_with_keyboard - Behavioral 
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

entity mymips_with_keyboard is
	Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
       --    int_i : in  STD_LOGIC;
			  
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  data_ready : in STD_LOGIC;
			  
			  --分频控制
		--	  clk_ctr : in STD_LOGIC;
		--	  clk_50 : in STD_LOGIC;
			  
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
			  is_booting : out STD_LOGIC;
			  
           ram1_control : out ram_control;
           ram2_control : out ram_control;
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram1_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
			  
			  --键盘
			  ps2clk : in std_logic;
			  ps2data : in std_logic;
			  
			  int_signal : out std_logic;
			  data_display : out std_logic_vector(7 downto 0));
end mymips_with_keyboard;

architecture Behavioral of mymips_with_keyboard is
	COMPONENT mymips
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
       --    int_i : in  STD_LOGIC;
			  
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  data_ready : in STD_LOGIC;
			  
			  --硬件中断
			  hard_int : in STD_LOGIC;
			  
			  --分频控制
		--	  clk_ctr : in STD_LOGIC;
		--	  clk_50 : in STD_LOGIC;
			  
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
			  is_booting : out STD_LOGIC;
			  
           ram1_control : out ram_control;
           ram2_control : out ram_control;
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram1_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0));
    END COMPONENT;
	 
	 COMPONENT my_keyboard
		port(
			clk : in std_logic;
			rst : in std_logic;
			ps2clk : in std_logic;
			ps2data : in std_logic;

			request : out std_logic;
			data : out std_logic_vector(7 downto 0);
			con_clk : out std_logic
		);
	 END COMPONENT;
	 
	 --键盘输出中断信号
	 signal int_keyboard : STD_LOGIC;
	 signal request_keyboard : STD_LOGIC;
	 signal data_keyboard : STD_LOGIC_VECTOR(7 downto 0);
begin
	
	mymips_INSTANCE : mymips PORT MAP (
		  rst => rst,
		  clk => clk,
		  
		  tsre => tsre,
		  tbre => tbre,
		  data_ready => data_ready,
		  
		  --硬件中断
		  hard_int => int_keyboard,
		  
		  --<wcy串口加入
		  rdn => rdn,
		  wrn => wrn,
		  --wcy>
		  
		  flash_byte => flash_byte,
		  flash_vpen => flash_vpen,
		  flash_ce => flash_ce,
		  flash_oe => flash_oe,
		  flash_we => flash_we,
		  flash_rp => flash_rp,
		  flash_addr => flash_addr,
		  flash_data => flash_data,
		  
		  is_booting => is_booting,
		  
		  ram1_control => ram1_control,
		  ram2_control => ram2_control,
		  ram1_data_io => ram1_data_io,
		  ram2_data_io => ram2_data_io,
		  ram1_addr_o => ram1_addr_o,
		  ram2_addr_o => ram2_addr_o
	);
	
	keyboard_INSTANCE : my_keyboard PORT MAP (
			clk => clk,
			rst => rst,
			ps2clk => ps2clk,
			ps2data => ps2data,

			request => request_keyboard,
			data => data_keyboard,
			con_clk => int_keyboard
	);
	
	process(data_keyboard, int_keyboard)
	begin
		data_display <= data_keyboard;
		int_signal <= int_keyboard;
	end process;

end Behavioral;

