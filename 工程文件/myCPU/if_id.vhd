----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:56:32 11/18/2016 
-- Design Name: 
-- Module Name:    if_id - Behavioral 
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

entity if_id is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
           if_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           if_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           stall : in  STD_LOGIC_VECTOR (4 downto 0);
			  
			  --硬件中断
			  hard_int : in STD_LOGIC;
			  
           id_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           id_inst : out  STD_LOGIC_VECTOR (15 downto 0));
end if_id;

architecture Behavioral of if_id is
	signal int_state : STD_LOGIC_VECTOR(3 downto 0) := Zero_4;
begin

	process(clk, rst, hard_int)
		variable temp_id_pc : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
		variable temp_id_inst : STD_LOGIC_VECTOR (15 downto 0) := Zero_16; 
		variable last_int : STD_LOGIC := '1';
		variable int_num : STD_LOGIC_VECTOR (7 downto 0) := "00010000";
	begin 
		if(rst = RstEnable) then
			temp_id_pc := Zero_16;
			temp_id_inst := Zero_16;
			int_state <= Zero_4;
			last_int := '1';
		elsif(rising_edge(clk)) then
			 
			if(stall(1) = Stop and stall(2) = NoStop) then
				temp_id_pc := Zero_16;
				temp_id_inst := Zero_16;
				last_int := hard_int;
			elsif(stall(1) = NoStop) then
				--指令中断
				if(if_inst(15 downto 11) = "11111") then
					temp_id_pc := Zero_16;
					temp_id_inst := Zero_16;
					int_num := (Zero_4 & if_inst(3 downto 0));
					int_state <= "0001";
				else
					case int_state is
					when "0000" =>                              --正常状态
						temp_id_pc := if_pc;
						temp_id_inst := if_inst;
						--硬件中断
						if(hard_int = '0' and last_int = '1') then
							int_num := "00010000";
							int_state <= "0001";
						end if;
						last_int := hard_int;
					--中断处理程序
					when "0001" => 
						temp_id_pc := if_pc + "1111111111111111";
						temp_id_inst := "1110111001000000";      --mfpc R6
						int_state <= "0010";
					when "0010" => 
						temp_id_pc := if_pc;
						temp_id_inst := "0110001111111111";      --addsp FF
						int_state <= "0011";
					when "0011" => 
						temp_id_pc := if_pc;
						temp_id_inst := "1101011000000000";      --sw_sp R6 0
						int_state <= "0100";
					when "0100" => 
						temp_id_pc := if_pc;
						temp_id_inst := ("01101110" & int_num);      --li R6 10   0x10为时钟中断号
						int_state <= "0101";
					when "0101" => 
						temp_id_pc := if_pc;
						temp_id_inst := "0110001111111111";      --addsp FF  
						int_state <= "0110";
					when "0110" => 
						temp_id_pc := if_pc;
						temp_id_inst := "1101011000000000";      --sw_sp R6 0  
						int_state <= "0111";
					when "0111" => 
						temp_id_pc := if_pc;
						temp_id_inst := "0110111000000101";      --li R6 5  
						int_state <= "1000";
					when "1000" => 
						temp_id_pc := if_pc;
						temp_id_inst := "0000100000000000";      --nop  
						int_state <= "1001";
					when "1001" => 
						temp_id_pc := if_pc;
						temp_id_inst := "1110111000000000";      --jr R6  
						int_state <= "1011";
					when "1010" => 
						temp_id_pc := if_pc;
						temp_id_inst := "0000100000000000";      --nop  
						int_state <= "0000";
					when others => 
						temp_id_pc := if_pc;
						temp_id_inst := if_inst;
						int_state <= "0000";
						last_int := hard_int;
					end case;
				end if;
			end if;
			
			
		end if;
		
		id_pc <= temp_id_pc;
		id_inst <= temp_id_inst;
	end process;

end Behavioral;

