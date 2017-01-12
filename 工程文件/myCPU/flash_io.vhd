----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:19:42 10/29/2011 
-- Design Name: 
-- Module Name:    flash_byte - Behavioral 
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

entity flash_io is
    Port ( 
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  addr_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  booting : out STD_LOGIC;
			  clk : in std_logic;--随便什么时钟
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
end flash_io;

architecture Behavioral of flash_io is
	type flash_state is (
		waiting,
		read1, read2, read3, read4,
		done
	);
	signal state : flash_state := waiting;
	
begin

	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';
	
	process (clk, reset)
		variable temp_addr : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable next_addr : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
	begin
		if (reset = '0') then
			flash_oe <= '1';
			flash_we <= '1';
			state <= waiting;
			flash_data <= (others => 'Z');
			data_out <= Zero_16;
			temp_addr := Zero_16;
			next_addr := Zero_16;
			booting <= '0';
		elsif(temp_addr(10) = '0') then
			booting <= '0';
			if (clk'event and clk = '1') then
				case state is
					when waiting =>
						flash_we <= '0';
						state <= read1;
						
					when read1 =>
						temp_addr := Zero_16;
						flash_data <= x"00FF";
						state <= read2;
					when read2 =>
						temp_addr := Zero_16;
						flash_we <= '1';
						state <= read3;
					when read3 =>
						flash_oe <= '0';
						flash_addr <= "000000" & next_addr;
						flash_data <= (others => 'Z');
						state <= read4;
					when read4 =>
						
						temp_addr := next_addr;
						--0的位置有时会读出神秘的东西，特判一下
						if(temp_addr = Zero_16) then
							data_out <= Zero_16;
						else
							data_out <= flash_data;
						end if;
						next_addr := temp_addr + '1';
						state <= read3;
						
					when others =>
						flash_oe <= '1';
						flash_we <= '1';
						flash_data <= (others => 'Z');
						state <= waiting;
				end case;
			end if;
		else
			booting <= '1';
		end if;
		
		addr_out <= temp_addr;
		
	end process;
	

end Behavioral;

