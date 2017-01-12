----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:01:01 11/30/2016 
-- Design Name: 
-- Module Name:    convert - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity convert is
    Port ( rst : in std_logic;
			  clk : in std_logic;
			  request : in std_logic;
			  data : in std_logic_vector(7 downto 0);
			  
			  con_clk : out std_logic
			);
end convert;

architecture Behavioral of convert is

signal state : std_logic_vector (1 downto 0);

begin

	process (clk, rst, request)
	begin
	
		if rst = '0' then
			con_clk <= '1';
			state <= "11"; 
	
		elsif clk = '1' and clk'event then
			if state = "00" and request = '1' and data = "01011010" then
				con_clk <= '0';
				state <= "01";
			elsif state = "01" and request = '1' and data = "11110000" then
				state <= "10";
			elsif state = "10" and request = '1' and data = "01011010" then
				con_clk <= '1';
				state <= "11";
			elsif state = "11" and request = '0' then
				state <= "00";
			end if;
		end if;
		
	end process;

end Behavioral;

