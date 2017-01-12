----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:56 11/19/2016 
-- Design Name: 
-- Module Name:    interpreter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

use work.type_lib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- ÌØÊâ¼Ä´æÆ÷ "1000": sp, "1001": pc, "1010": ra, "1011": t, "1100", IH

entity interpreter is
    Port ( id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  id_pc : in std_logic_vector (15 downto 0);
		
			  rst : in std_logic;
	 
			  read_reg1 : out STD_LOGIC_VECTOR (3 downto 0);
			  read_reg2 : out STD_LOGIC_VECTOR (3 downto 0);
			  
			  imme : out STD_LOGIC_VECTOR(15 downto 0);
			  
			  write_reg : out STD_LOGIC_VECTOR (3 downto 0)
			  );
end interpreter;

architecture Behavioral of interpreter is
--	signal op : std_logic_vector(4 downto 0) ;
--	signal rx : std_logic_vector(2 downto 0) ;
--	signal ry : std_logic_vector(2 downto 0) ;
--	signal rz : std_logic_vector(2 downto 0) ;
--	signal last : std_logic_vector(1 downto 0);
--	
--	signal im_3: std_logic_vector(2 downto 0);
--	signal im_4: std_logic_vector(3 downto 0);
--	signal im_5: std_logic_vector(4 downto 0);
--	signal im_8: std_logic_vector(7 downto 0);
--	signal im_11: std_logic_vector(10 downto 0);

begin
	
	process(id_inst, rst, id_pc)
		variable op : std_logic_vector(4 downto 0);
		variable rx : std_logic_vector(2 downto 0);
		variable ry : std_logic_vector(2 downto 0);
		variable rz : std_logic_vector(2 downto 0); 
		variable last : std_logic_vector(1 downto 0);
		
		variable im_3 : std_logic_vector(2 downto 0);
		variable im_4 : std_logic_vector(3 downto 0);
		variable im_5 : std_logic_vector(4 downto 0);
		variable im_8 : std_logic_vector(7 downto 0);
		variable im_11 : std_logic_vector(10 downto 0);
		
	begin
		
		op := id_inst(15 downto 11);
		rx := id_inst(10 downto 8);
		ry := id_inst(7  downto 5);
		rz := id_inst(4  downto 2);
		last := id_inst(1 downto 0);
		
		im_3 := id_inst(4 downto 2);
		im_4 := id_inst(3 downto 0);
		im_5 := id_inst(4 downto 0);
		im_8 := id_inst(7 downto 0);
		im_11 := id_inst(10 downto 0);
		
		if rst = '0' then
			read_reg1 <= "1111";
			read_reg2 <= "1111";
			imme <= zero_16;
			write_reg <= '0' & rx;
			
		else 
			case op is 
				when "01001" => -- ADDIU
					read_reg1 <= '0' & rx;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_8), imme'length));
					write_reg <= '0' & rx;
						
				when "01000" => -- ADDIU3
					read_reg1 <= '0' & rx;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_4), imme'length));
					write_reg <= '0' & ry;
						
				when "01100" => -- ADDSP, BTEQZ, BTNEZ, MTSP, SW_RS
					case rx is
						when "011" => --ADDSP
							read_reg1 <= sp;
							read_reg2 <= "1111";
							imme <= std_logic_vector(resize(signed(im_8), imme'length));
							write_reg <= sp;
						
						when "000" => --BTEQZ Î´Ð´
							read_reg1 <= t;
							read_reg2 <= "1111";
							imme <= std_logic_vector(resize(signed(im_8), imme'length));
							write_reg <= "1111";
						
						when "001" => --BTNEZ Î´Ð´	
							read_reg1 <= t;
							read_reg2 <= "1111";
							imme <= std_logic_vector(resize(signed(im_8), imme'length));
							write_reg <= "1111";
						
						when "100" => --MTSP
							read_reg1 <= '0' & ry;
							read_reg2 <= "1111";
							imme <= zero_16;
							write_reg <= sp;
						
						when "010" => --SW_RS	
							read_reg1 <= sp;
							read_reg2 <= ra;
							imme <= std_logic_vector(resize(signed(im_8), imme'length));
							write_reg <= "1111";
						
						when others =>
							read_reg1 <= "1111";
							read_reg2 <= "1111";
							imme <= zero_16;
							write_reg <= "1111";
							
					end case;
						
				when "11100" => -- ADDU, SUBU
					case last is
						when "01" => --ADDU
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= '0' & rz;
							
						when "11" => --SUBU	
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= '0' & rz;
						
						when others =>
							read_reg1 <= "1111";
							read_reg2 <= "1111";
							imme <= zero_16;
							write_reg <= "1111";
							
					end case;
					
				when "11101" => -- AND, CMP, JR, MFPC, OR, SLLV, SLT, SRLV
					case rz & last is
						when "01100" => --AND
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= '0' & rx;
							
						when "01010" => --CMP
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= t;
						
						when "00000" => --JR or MFPC
							if ry = "000" then -- JR
								read_reg1 <= '0' & rx;
								read_reg2 <= "1111";
								imme <= zero_16;
								write_reg <= "1111";
								
							elsif ry = "010" then --MFPC
								read_reg1 <= "1111";
								read_reg2 <= "1111";
								imme <= id_pc + '1';
								write_reg <= '0' & rx;
							else
								read_reg1 <= "1111";
								read_reg2 <= "1111";
								imme <= zero_16;
								write_reg <= "1111";
							end if;
							
						when "01101" => --OR
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= '0' & rx;
							
						when "00100" => --SLLV
							read_reg2 <= '0' & ry;
							read_reg1 <= '0' & rx;
							imme <= zero_16;
							write_reg <= '0' & ry;
							
						when "00010" => --SLT
							read_reg1 <= '0' & rx;
							read_reg2 <= '0' & ry;
							imme <= zero_16;
							write_reg <= t;
							
						when "00110" => --SRLV
							read_reg1 <= '0' & ry;
							read_reg2 <= '0' & rx;
							imme <= zero_16;
							write_reg <= '0' & ry;
						
						when others =>
							read_reg1 <= "1111";
							read_reg2 <= "1111";
							imme <= zero_16;
							write_reg <= "1111";
					end case;
						
				when "00010" => -- B
					read_reg1 <= "1111";
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_11), imme'length));
					write_reg <= "1111";
					
				when "00100" => -- BEQZ
					read_reg1 <= '0' & rx;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_8), imme'length));
					write_reg <= "1111";
					
				when "00101" => -- BNEZ
					read_reg1 <= '0' & rx;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_8), imme'length));
					write_reg <= "1111";
					
				when "01101" => -- LI
					read_reg1 <= "1111";
					read_reg2 <= "1111";
					imme <= "00000000" & ry & rz & last;
					write_reg <= '0' & rx;
					
				when "10011" => -- LW
					read_reg1 <= '0' & rx;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_5), imme'length));
					write_reg <= '0' & ry;
				
				when "10010" => -- LW_SP
					read_reg1 <= sp;
					read_reg2 <= "1111";
					imme <= std_logic_vector(resize(signed(im_8), imme'length));
					write_reg <= '0' & rx;
				
				when "11110" => -- MFIH, MTIH
					if last = "00" then --MFIH
						read_reg1 <= ih;
						read_reg2 <= "1111";
						imme <= zero_16;
						write_reg <= '0' & rx;
						
					elsif last = "01" then --MTIH
						read_reg1 <= '0' & rx;
						read_reg2 <= "1111";
						imme <= zero_16;
						write_reg <= ih;
					else
						read_reg1 <= "1111";
						read_reg2 <= "1111";
						imme <= zero_16;
						write_reg <= "1111";
					end if;
					
				when "00001" => -- NOP
					read_reg1 <= "1111";
					read_reg2 <= "1111";
					imme <= zero_16;
					write_reg <= "1111";
				
				when "00110" => -- SLL, SRA
					if last = "00" then --SLL
						read_reg1 <= '0' & ry;
						read_reg2 <= "1111";
						imme <= "0000000000000" & rz;
						write_reg <= '0' & rx;
						
					elsif last = "11" then --SRA
						read_reg1 <= '0' & ry;
						read_reg2 <= "1111";
						imme <= "0000000000000" & rz;
						write_reg <= '0' & rx;
					else
						read_reg1 <= "1111";
						read_reg2 <= "1111";
						imme <= zero_16;
						write_reg <= "1111";
					end if;
					
				when "11011" => -- SW
					read_reg1 <= '0' & rx;
					read_reg2 <= '0' & ry;
					imme <= std_logic_vector(resize(signed(im_5), imme'length));
					write_reg <= "1111";
				
				when "11010" => -- SW_SP
					read_reg1 <= sp;
					read_reg2 <= '0' & rx;
					imme <= std_logic_vector(resize(signed(im_8), imme'length));
					write_reg <= "1111";
				
				when others => 
					read_reg1 <= "1111";
					read_reg2 <= "1111";
					imme <= zero_16;
					write_reg <= "1111";
					
			end case;
		end if;
	end process;

end Behavioral;

