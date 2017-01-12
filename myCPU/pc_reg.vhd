----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:59:16 11/18/2016 
-- Design Name: 
-- Module Name:    pc_reg - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.type_lib.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_reg is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  stall : in STD_LOGIC_VECTOR (4 downto 0);
			  
			  branchAddr: in STD_LOGIC_VECTOR (15 downto 0);
			  jumpAddr: in STD_LOGIC_VECTOR (15 downto 0);
			  
			  PCBranchSrc: in STD_LOGIC;
			  PCJumpSrc: in STD_LOGIC;
	--		  PCErrorSrc: in STD_LOGIC;
			  
           pc : out  STD_LOGIC_VECTOR (15 downto 0));
end pc_reg;

architecture Behavioral of pc_reg is

begin

	process(clk, rst)
		variable temp_pc : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable next_pc : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
	begin
		if (rst = RstEnable) then
			temp_pc := Zero_16;
			next_pc := Zero_16;
		elsif(rising_edge(clk)) then
			if(PCBranchSrc = Branch) then
				temp_pc := branchAddr;
			elsif(PCJumpSrc = Branch) then
				temp_pc := jumpAddr;
			elsif(stall(0) = NoStop) then
				temp_pc := next_pc;
			end if;			
			next_pc := temp_pc + '1';
		end if;
		
		pc <= temp_pc;
	end process;

end Behavioral;

