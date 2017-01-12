----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:01:47 11/22/2016 
-- Design Name: 
-- Module Name:    branch_ctrl - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_signed.all;
use work.type_lib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch_ctrl is
    Port ( id_pc : in  STD_LOGIC_VECTOR (15 downto 0); 
           int_imme : in  STD_LOGIC_VECTOR (15 downto 0); 
			  int_inputA : in std_logic_vector (15 downto 0);
			  
           ctrl_branch : in  STD_LOGIC;
			  stallreq_load : in std_logic;
			  rst : in std_logic;
			  ctrl_branch_type : in bt;
			  
			  ctrl_pc : out std_logic_vector (15 downto 0);
			  branch_confirm : out std_logic
			  );
end branch_ctrl;

architecture Behavioral of branch_ctrl is
	
begin
	
	process(id_pc, int_imme, int_inputA, ctrl_branch, rst, ctrl_branch_type, stallreq_load)
	begin
	
		if rst = '0' then
			ctrl_pc <= zero_16;
			branch_confirm <= '0';
		elsif stallreq_load = '1' then
			ctrl_pc <= id_pc + '1';
			branch_confirm <= '0';
		elsif ctrl_branch = '0' then
			ctrl_pc <= id_pc + '1';
			branch_confirm <= '0';
		elsif ctrl_branch = '1' then
			
			if ctrl_branch_type = d then
				ctrl_pc <= id_pc + int_imme + '1'; 
				branch_confirm <= '1';
				
			elsif ctrl_branch_type = ez then
				if int_inputA = zero_16 then
					ctrl_pc <= id_pc + int_imme + '1';
					branch_confirm <= '1';
				else
					ctrl_pc <= id_pc + '1';
					branch_confirm <= '0';
				end if;
				
			elsif ctrl_branch_type = nez then
				if int_inputA /= zero_16 then
					ctrl_pc <= id_pc + int_imme + '1';
					branch_confirm <= '1' ;
				else
					ctrl_pc <= id_pc + '1';
					branch_confirm <= '0';
				end if;
				
			else
				ctrl_pc <= id_pc + '1';
				branch_confirm <= '0';
			
			end if;
		else
			ctrl_pc <= id_pc + '1';
			branch_confirm <= '0'; 
			
			
		end if;
	
	end process;

end Behavioral;

