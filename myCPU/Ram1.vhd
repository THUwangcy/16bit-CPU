----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:52:30 11/21/2016 
-- Design Name: 
-- Module Name:    Ram1 - Behavioral 
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
use IEEE.std_logic_arith.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ram1 is
    Port ( --clk : in  STD_LOGIC;
        --   data_i : in  STD_LOGIC_VECTOR (15 downto 0);
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           control : in  ram_control;
			  
           data_io : inout  STD_LOGIC_VECTOR (15 downto 0));
end Ram1;

architecture Behavioral of Ram1 is
	signal data_mem : RAM := (others => (others => '0'));
begin
	
	--Ð´²Ù×÷
	process(data_io, addr, control)
	begin
	--	if(clk'event and clk = '1') then
			if(control.EN = '0' and control.WE = '0') then 
				data_mem(CONV_INTEGER(addr)) <= data_io;
			end if;
	--	end if;
	end process;
	
	--¶Á²Ù×÷
	process(addr, control, data_io)
		variable temp_data : STD_LOGIC_VECTOR (15 downto 0) := HighZ_16;
	begin 
		if(control.EN = '1') then
			temp_data := HighZ_16;
		elsif(control.OE = '0') then
			temp_data := data_mem(CONV_INTEGER(addr));
		else
			temp_data := HighZ_16;
		end if;
		
		data_io <= temp_data;
	end process;

end Behavioral;

