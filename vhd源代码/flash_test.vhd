----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:01 11/26/2016 
-- Design Name: 
-- Module Name:    flash_test - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.type_lib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flash_test is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           flash_data_output : out  STD_LOGIC_VECTOR (15 downto 0);
			  flash_addr_output : out  STD_LOGIC_VECTOR (15 downto 0);
			  booting : out STD_LOGIC;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  --flash_sts : in std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0));
end flash_test;

architecture Behavioral of flash_test is
	component flash_io
    Port ( 
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  addr_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  booting : out STD_LOGIC;
			  clk : in std_logic;--Ëæ±ãÊ²Ã´Ê±ÖÓ
			  reset : in std_logic;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  --flash_sts : in std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0)
	);
	end component;
	
--	signal data_output : std_logic_vector(15 downto 0);
	
--	signal addr : std_logic_vector(15 downto 0) := Zero_16;
begin
	
	flash : flash_io PORT MAP (
		data_out => flash_data_output,
		addr_out => flash_addr_output,
		booting => booting,
		clk => clk,
		reset => rst,
		
		flash_byte => flash_byte,
		flash_vpen => flash_vpen,
		flash_ce => flash_ce,
		flash_oe => flash_oe,
		flash_we => flash_we,
		flash_rp => flash_rp,
		--flash_sts => flash_sts,
		flash_addr => flash_addr,
		flash_data => flash_data
	);

end Behavioral;

