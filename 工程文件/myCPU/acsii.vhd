----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:47:27 12/01/2016 
-- Design Name: 
-- Module Name:    acsii - Behavioral 
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

entity acsii is
    port ( rst : in std_logic;
			  clk : in std_logic;
			  request : in std_logic;
			  data : in std_logic_vector (7 downto 0);
			  
			  ascii : out std_logic_vector (7 downto 0);
			  asc_clk : out std_logic
			);
end acsii;

architecture Behavioral of acsii is

signal state : std_logic_vector (1 downto 0);

begin

	process (rst, data, request)
	begin
		if rst = '0' then
			ascii <= "00000000";
		elsif request = '1' then
			if data = "00011100" then  --A
				ascii <= "01000001";
			elsif data = "00110010" then --B
				ascii <= "01000010";
			elsif data = "00100001" then --C
				ascii <= "01000011";
			elsif data = "00100011" then --D
				ascii <= "01000100";
			elsif data = "00100100" then --E
				ascii <= "01000101";
			elsif data = "00101011" then --F
				ascii <= "01000110";
			elsif data = "00110100" then --G
				ascii <= "01000111";
			elsif data = "00110011" then --H
				ascii <= "01001000";
			elsif data = "01000011" then --I
				ascii <= "01001001";
			elsif data = "00111011" then --J
				ascii <= "01001010";
			elsif data = "01000010" then --K
				ascii <= "01001011";
			elsif data = "01001011" then --L
				ascii <= "01001100";
			elsif data = "00111010" then --M
				ascii <= "01001101";
			elsif data = "00110001" then --N
				ascii <= "01001110";
			elsif data = "01000100" then --O
				ascii <= "01001111";
			elsif data = "01001101" then --P
				ascii <= "01010000";
			elsif data = "00010101" then --Q
				ascii <= "01010001";
			elsif data = "00101101" then --R
				ascii <= "01010010";
			elsif data = "00011011" then --S
				ascii <= "01010011";
			elsif data = "00101100" then --T
				ascii <= "01010100";
			elsif data = "00111100" then --U
				ascii <= "01010101";
			elsif data = "00101010" then --V
				ascii <= "01010110";
			elsif data = "00011101" then --W
				ascii <= "01010111";
			elsif data = "00100010" then --X
				ascii <= "01011000";
			elsif data = "00110101" then --Y
				ascii <= "01011001";
			elsif data = "00011010" then --Z
				ascii <= "01011010";
				
			elsif data <= "00101001" then --space
				ascii <= "00100000";
			elsif data <= "01001100" then --;
				ascii <= "00111011";
			elsif data <= "01010010" then --<
				ascii <= "00111100";
			elsif data <= "01011010" then --enter
				ascii <= "00001010";
			end if;
		end if;
	end process;
	
	process (clk, rst, request)
	begin
	
		if rst = '0' then
			asc_clk <= '1';
			state <= "11";
	
		elsif clk = '1' and clk'event then
			if state = "00" and request = '1' and data /= "00000000" then
				asc_clk <= '0';
				state <= "01";
			elsif state = "01" and request = '1' and data = "11110000" then
				state <= "10";
			elsif state = "10" and request = '1' and data /= "00000000" and data /= "11110000" then
				asc_clk <= '1';
				state <= "11";
			elsif state = "11" and request = '0' then
				state <= "00";
			end if;
		end if;
		
	end process;
	
end Behavioral;

