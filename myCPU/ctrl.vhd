----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:05:59 11/22/2016 
-- Design Name: 
-- Module Name:    ctrl - Behavioral 
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

entity ctrl is
    Port ( rst : in  STD_LOGIC;
           stallreq_from_id : in  STD_LOGIC;
           stallreq_ram_conflict : in  STD_LOGIC;
           stallreq_branch : in  STD_LOGIC;
			  stallreq_jump : in STD_LOGIC;
           stall : out  STD_LOGIC_VECTOR (4 downto 0));
end ctrl;

architecture Behavioral of ctrl is

begin

	process(rst, stallreq_from_id, stallreq_ram_conflict, stallreq_branch, stallreq_jump)
	begin 
		if(rst = RstEnable) then
			stall <= Zero_5;
		elsif(stallreq_from_id = Stop) then
			stall <= "00111";
		elsif(stallreq_ram_conflict = Stop or stallreq_branch = Stop or stallreq_jump = Stop) then
			stall <= "00011";
		else
			stall <= Zero_5;
		end if;
	end process;

end Behavioral;

