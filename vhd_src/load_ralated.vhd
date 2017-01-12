----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:04:54 11/22/2016 
-- Design Name: 
-- Module Name:    load_ralated - Behavioral 
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
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity load_related is
    Port ( rst : in STD_LOGIC;
			  ex_memRead : in  STD_LOGIC;
           ex_regWrite : in  STD_LOGIC_VECTOR (3 downto 0);
           id_reg1 : in  STD_LOGIC_VECTOR (3 downto 0);
           id_reg2 : in  STD_LOGIC_VECTOR (3 downto 0);
           stallreq_load : out  STD_LOGIC);
end load_related;

architecture Behavioral of load_related is

begin

	process(rst, ex_memRead, ex_regWrite, id_reg1, id_reg2)
		variable temp_stall : STD_LOGIC;
	begin
		if(rst = RstEnable) then
			temp_stall := NoStop;
		else
			if(ex_memRead = ReadEnable and (ex_regWrite = id_reg1 or ex_regWrite = id_reg2)) then
				temp_stall := Stop;
			else
				temp_stall := NoStop;
			end if;
		end if;
		
		stallreq_load <= temp_stall;
	end process;

end Behavioral;

