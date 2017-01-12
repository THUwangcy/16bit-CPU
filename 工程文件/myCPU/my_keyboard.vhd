----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:34 11/25/2016 
-- Design Name: 
-- Module Name:    my_keyboard - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_keyboard is

	port(
		clk : in std_logic;
		rst : in std_logic;
		ps2clk : in std_logic;
		ps2data : in std_logic;
		
--		seg1 : out std_logic_vector(6 downto 0);
--		seg2 : out std_logic_vector(6 downto 0)

		request : out std_logic;
		data : out std_logic_vector(7 downto 0);
		con_clk : out std_logic
	);

end my_keyboard;

architecture Behavioral of my_keyboard is
	signal re : std_logic ;
	signal rdata : std_logic_vector (7 downto 0);

	component key_data 
		port(
			clk : in std_logic;
			
			ps2clk : in std_logic;
			ps2data : in std_logic;
			
			request : out std_logic;
			data : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component convert 
		port(
			rst : in std_logic;
			clk : in std_logic;
			request : in std_logic;
			data : in std_logic_vector (7 downto 0);
			
			con_clk : out std_logic
--			ascii : out std_logic_vector (7 downto 0)
		);
	end component;
	
--	component display
--		port(
--			acsii : in std_logic;
--			clk : in std_logic;
--			
--			seg1 : out std_logic_vector(6 downto 0);
--			seg2 : out std_logic_vector(6 downto 0);
--			l : out std_logic_vector(7 downto 0)
--		);
--	end component;

begin

	key_instance : key_data port map (
		--in
		clk => clk,
		ps2clk => ps2clk,
		ps2data => ps2data,
		--out
		request => re,
		data => rdata
	);
	
	conv_instance : convert port map (
		--in
		clk => clk,
		rst => rst,
		request => re,
		data => rdata,
		--out
		con_clk => con_clk
	);
	
	process (re, rdata)
	begin
		request <= re;
		data <= rdata;
	end process;

end Behavioral;

