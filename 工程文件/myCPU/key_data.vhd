----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:19:00 11/25/2016 
-- Design Name: 
-- Module Name:    key_data - Behavioral 
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

entity key_data is
    Port ( clk : in  STD_LOGIC;
--           rst : in  STD_LOGIC;
           ps2clk : in  STD_LOGIC;
           ps2data : in  STD_LOGIC;
			  
           request : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0));
end key_data;

architecture Behavioral of key_data is

signal temp : std_logic_vector(11 downto 0) := "000000000000";
signal now_clk, pre_clk : std_logic := '0';
signal temp_ps2data : std_logic := '1';


signal clk1, clk2, clkin : std_logic;

begin

	process (clk, temp_ps2data)
	begin
		if clk = '1' and clk'event then
			pre_clk <= now_clk;
			now_clk <= clkin;
			
			if(pre_clk > now_clk) then
				if temp(0) = '0' then
					temp <= temp_ps2data & "01111111111";
				else
					temp <= temp_ps2data & temp(11 downto 1);
				end if;
			end if; 
		end if;
	end process;
	
	process (temp)
	begin

		if temp(0) = '0' then
			data <= temp (9 downto 2);
			request <= '1';
		else
			data <= "00000000";
			request <= '0';
		end if;
	end process;
	
	process (ps2data)
	begin
		temp_ps2data <= ps2data;
	end process;
	
	process (clk) 
	begin
		if clk = '1' and clk'event then
			clk1 <= ps2clk;
			clk2 <= clk1;
			clkin <= (not clk1) and clk2;
		end if;
	end process;
	
end Behavioral;

