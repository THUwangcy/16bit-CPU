----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:13 11/30/2016 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		
		h_counter : out STD_LOGIC_VECTOR(9 downto 0); --行计数信号
		v_counter : out STD_LOGIC_VECTOR(9 downto 0); 
		hs : out STD_LOGIC; --行同步信号
		vs : out STD_LOGIC --场同步信号
		
	);
	
end vga;

architecture Behavioral of vga is

begin
	process(clk,rst)
		variable temp_hc : INTEGER RANGE 0 to 799;
		variable temp_vc : INTEGER RANGE 0 to 524;
	begin
		if (rst='0') then
			temp_hc := 0;
			temp_vc := 0;
		elsif(rising_edge(clk)) then
			if(temp_hc = 799)then
				temp_hc := 0;
				if(temp_vc = 524)then
					temp_vc := 0;
				else
					temp_vc := temp_vc + 1;
				end if;
			else
				temp_hc := temp_hc + 1;
			end if;
			
			--设置同步信号
			if(temp_hc < 752 and temp_hc > 655)then
				hs <= '0';
			else
				hs <= '1';
			end if;
			
			if(temp_vc < 492 and temp_vc > 490)then
				vs <= '0';
			else
				vs <= '1';
			end if;

		end if;
		--if(temp_hc < 640 and temp_vc < 480)then
			h_counter <= CONV_STD_LOGIC_VECTOR(temp_hc,10);
			v_counter <= CONV_STD_LOGIC_VECTOR(temp_vc,10);
		--end if;
	end process;
end Behavioral;

