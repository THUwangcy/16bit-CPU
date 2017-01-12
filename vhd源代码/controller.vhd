----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:08:03 11/19/2016 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

entity controller is
    Port ( id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  rst : in std_logic;
	 
			  control_id : out id_control;
			  control_ex : out ex_control;
			  control_mem : out mem_control;
			  control_wb : out wb_control
			  );
end controller;

architecture Behavioral of controller is
	
begin

	process(id_inst, rst)
		variable op : std_logic_vector(4 downto 0);
		variable last2: std_logic_vector(1 downto 0);
		variable last5: std_logic_vector(4 downto 0);
		variable rx: std_logic_vector(2 downto 0);
		variable ry: std_logic_vector(2 downto 0);
		
	begin
		
		op := id_inst(15 downto 11);
		rx := id_inst(10 downto 8);
		ry := id_inst(7 downto 5);
		last2 := id_inst(1 downto 0);
		last5 := id_inst(4 downto 0);
		
		if rst = RstEnable then
			control_id.branch <= '0';
			control_id.branchtype <= none;
			control_id.jump <= '0';
			
			control_ex.ALUSrc <= none;
			control_ex.ALUop <= none;
				
			control_mem.memread <= ReadDisable;
			control_mem.memwrite <= WriteDisable;
				
			control_wb.regwrite <= WriteDisable;
			control_wb.memtoreg <= none;
		
		else 
			case op is 
				when "01001" => -- ADDIU
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
					
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu;
					
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
					
					control_wb.regwrite <= '1';
					control_wb.memtoreg <= alu;
					
				when "01000" => -- ADDIU3
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
					
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu;
					
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
					
					control_wb.regwrite <= '1';
					control_wb.memtoreg <= alu;
					
				
						
				when "01100" => -- ADDSP, BTEQZ, BTNEZ, MTSP, SW_RS
					case rx is
						when "011" => --ADDSP
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= imme;
							control_ex.ALUop <= addu;
							
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
							
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
						
						when "000" => --BTEQZ 
							control_id.branch <= '1';
							control_id.branchtype <= EZ;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= none;
							
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
							
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
							
						when "001" => --BTNEZ 	
							control_id.branch <= '1';
							control_id.branchtype <= NEZ;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= none;
							
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
							
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
							
						when "100" => --MTSP
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= equal1 ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when "010" => --SW_RS	
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= imme;
							control_ex.ALUop <= addu ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '1';
								
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
							
						when others =>
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
								
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= none;
									
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
					end case;
						
				when "11100" => -- ADDU, SUBU
					case last2 is
						when "01" => --ADDU
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= addu;
							
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
							
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when "11" => --SUBU	
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= subu;
							
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
							
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
						
						when others =>
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
								
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= none;
									
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
							
					end case;
					
				when "11101" => -- AND, CMP, JR, MFPC, OR, SLLV, SLT, SRLV
					case last5 is
						when "01100" => --AND
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= andu;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;

						when "01010" => --CMP
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= Equal0 ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;

						when "00000" => --JR or MFPC
							if ry = "000" then -- JR
								control_id.branch <= '0';
								control_id.branchtype <= none;
								control_id.jump <= '1';
								
								control_ex.ALUSrc <= none;
								control_ex.ALUop <= none;
									
								control_mem.memread <= '0';
								control_mem.memwrite <= '0';
									
								control_wb.regwrite <= '0';
								control_wb.memtoreg <= none;
										
							elsif ry = "010" then --MFPC
								control_id.branch <= '0';
								control_id.branchtype <= none;
								control_id.jump <= '0';
								
								control_ex.ALUSrc <= imme;
								control_ex.ALUop <= equal2;
									
								control_mem.memread <= '0';
								control_mem.memwrite <= '0';
									
								control_wb.regwrite <= '1';
								control_wb.memtoreg <= alu;
							else
								control_id.branch <= '0';
								control_id.branchtype <= none;
								control_id.jump <= '0';
								
								control_ex.ALUSrc <= none;
								control_ex.ALUop <= none;
									
								control_mem.memread <= '0';
								control_mem.memwrite <= '0';
								
								control_wb.regwrite <= '0';
								control_wb.memtoreg <= none;
					
							end if;
							
						when "01101" => --OR
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= oru ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when "00100" => --SLLV
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= sllu ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when "00010" => --SLT
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= sltu ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when "00110" => --SRLV
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
							
							control_ex.ALUSrc <= reg;
							control_ex.ALUop <= srlu ;
								
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '1';
							control_wb.memtoreg <= alu;
							
						when others =>
							control_id.branch <= '0';
							control_id.branchtype <= none;
							control_id.jump <= '0';
								
							control_ex.ALUSrc <= none;
							control_ex.ALUop <= none;
									
							control_mem.memread <= '0';
							control_mem.memwrite <= '0';
								
							control_wb.regwrite <= '0';
							control_wb.memtoreg <= none;
					end case;
						
				when "00010" => -- B
					control_id.branch <= '1';
					control_id.branchtype <= D;
					control_id.jump <= '0';
					
					control_ex.ALUSrc <= none;
					control_ex.ALUop <= none;
						
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
						
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;
					
				when "00100" => -- BEQZ
					control_id.branch <= '1';
					control_id.branchtype <= EZ;
					control_id.jump <= '0';
					
					control_ex.ALUSrc <= none;
					control_ex.ALUop <= none;
						
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
						
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;

				when "00101" => -- BNEZ
					control_id.branch <= '1';
					control_id.branchtype <= NEZ;
					control_id.jump <= '0';
					
					control_ex.ALUSrc <= none;
					control_ex.ALUop <= none;
						
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
						
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;

				when "01101" => -- LI
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
							
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= equal2 ;
								
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
							
					control_wb.regwrite <= '1';
					control_wb.memtoreg <= alu;
					
				when "10011" => -- LW
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
							
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu ;
								
					control_mem.memread <= '1';
					control_mem.memwrite <= '0';
							
					control_wb.regwrite <= '1';
					control_wb.memtoreg <= Mem;
					
				when "10010" => -- LW_SP
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
							
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu ;
								
					control_mem.memread <= '1';
					control_mem.memwrite <= '0';
							
					control_wb.regwrite <= '1';
					control_wb.memtoreg <= mem;
				
				when "11110" => -- MFIH, MTIH
					if last2 = "00" then --MFIH
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= none;
						control_ex.ALUop <= equal1;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '1';
						control_wb.memtoreg <= alu;
						
					elsif last2 = "01" then --MTIH
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= imme;
						control_ex.ALUop <= equal1 ;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '1';
						control_wb.memtoreg <= alu;
					else
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= none;
						control_ex.ALUop <= none;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '0';
						control_wb.memtoreg <= none;
					end if;
					
				when "00001" => -- NOP
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
								
					control_ex.ALUSrc <= none;
					control_ex.ALUop <= none;
									
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
								
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;
						
				when "00110" => -- SLL, SRA
					if last2 = "00" then --SLL
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= imme;
						control_ex.ALUop <= sllu ;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '1';
						control_wb.memtoreg <= alu;
						
					elsif last2 = "11" then --SRA
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= imme;
						control_ex.ALUop <= srau;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '1';
						control_wb.memtoreg <= alu;
					else
						control_id.branch <= '0';
						control_id.branchtype <= none;
						control_id.jump <= '0';
								
						control_ex.ALUSrc <= none;
						control_ex.ALUop <= none;
									
						control_mem.memread <= '0';
						control_mem.memwrite <= '0';
								
						control_wb.regwrite <= '0';
						control_wb.memtoreg <= none;
					end if;
					
				when "11011" => -- SW
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
								
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu;
									
					control_mem.memread <= '0';
					control_mem.memwrite <= '1';
								
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;
					
				when "11010" => -- SW_SP
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
								
					control_ex.ALUSrc <= imme;
					control_ex.ALUop <= addu;
									
					control_mem.memread <= '0';
					control_mem.memwrite <= '1';
								
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;
					
				when others => 
					control_id.branch <= '0';
					control_id.branchtype <= none;
					control_id.jump <= '0';
								
					control_ex.ALUSrc <= none;
					control_ex.ALUop <= none;
									
					control_mem.memread <= '0';
					control_mem.memwrite <= '0';
								
					control_wb.regwrite <= '0';
					control_wb.memtoreg <= none;
					
			end case;
		end if;
	end process;
	
	
end Behavioral;

