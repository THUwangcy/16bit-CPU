----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:37:40 11/19/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port ( 
           rst : in  STD_LOGIC;
           inputA : in STD_LOGIC_VECTOR (15 downto 0);--rx
			  inputB : in STD_LOGIC_VECTOR (15 downto 0);--ry
			  inputC : in STD_LOGIC_VECTOR (15 downto 0);--immediate
			  
			  EXControl : in ex_control; --控制信号
			  
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
	process(EXControl,inputA,inputB,inputC,rst)
		variable temp_out : STD_LOGIC_VECTOR (15 downto 0):= Zero_16;
	begin
		if (rst = RstEnable) then
			temp_out := Zero_16;
		else
			case EXControl.ALUOp is
				when NONE => 
					temp_out := Zero_16;
				when ADDU => --加
					if(EXControl.ALUSrc = Imme) then
						temp_out := inputA + inputC;
					elsif(EXControl.ALUSrc = Reg) then
						temp_out := inputA + inputB;
					else
						temp_out := Zero_16;
					end if;
					
				when SUBU => --减
					if(EXControl.ALUSrc = Imme) then
						temp_out := inputA - inputC;
					elsif(EXControl.ALUSrc = Reg) then
						temp_out := inputA - inputB;
					else
						temp_out := Zero_16;
					end if;
				when ANDU => --与
					if(EXControl.ALUSrc = Imme) then
						temp_out := inputA AND inputC;
					elsif(EXControl.ALUSrc = Reg) then
						temp_out := inputA AND inputB;
					else
						temp_out := Zero_16;
					end if;
				when ORU =>  --或
					if(EXControl.ALUSrc = Imme) then
						temp_out := inputA OR inputC;
					elsif(EXControl.ALUSrc = Reg) then
						temp_out := inputA OR inputB;
					else
						temp_out := Zero_16;
					end if;
				when XORU => --异或
					if(EXControl.ALUSrc = Imme) then
						temp_out := inputA XOR inputC;
					elsif(EXControl.ALUSrc = Reg) then
						temp_out := inputA XOR inputB;
					else
						temp_out := Zero_16;
					end if;

	--<hxx>
				when SLLU => -- 逻辑左移
					if(EXControl.ALUSrc = Imme) then
						if(inputC /= "000000000000000") then
							temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SLL CONV_INTEGER(inputC));
						else
							temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SLL 8);
						end if;
					elsif(EXControl.ALUSrc = Reg) then 
						temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SLL CONV_INTEGER(inputB));
					else
						temp_out := Zero_16;
					end if;
				when SRAU => --算术右移
					if(excontrol.alusrc = imme) then
						if(inputC /= "000000000000000") then
							temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SRA CONV_INTEGER(inputC));
						else 
							temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SRA 8);
						end if;
					else
						temp_out := zero_16;
					end if;
				when SRLU => --逻辑右移
					if(excontrol.alusrc = reg) then
						temp_out := TO_STDLOGICVECTOR(TO_BITVECTOR(inputA) SRL CONV_INTEGER(inputB));
					else
						temp_out := zero_16;
					end if;
				
				when sltu => --大小比较
					if(excontrol.alusrc = reg) then
						if(inputA >= inputB) then
							temp_out := zero_16;
						else
							temp_out := "0000000000000001";
						end if;
					else
						temp_out := zero_16;
					end if;
							
				when EQUAL1 =>
					temp_out := inputA;
					
				when EQUAL2 =>
					if(exControl.alusrc = imme) then
						temp_out := inputC;
					elsif(exControl.alusrc = reg) then
						temp_out := inputB;
					else
						temp_out := zero_16;
					end if;
					
				when EQUAL0 =>
					if(exControl.alusrc = imme) then
						if inputA = inputC then
							temp_out := zero_16;
						else
							temp_out := "0000000000000001";
						end if;
					elsif (exControl.alusrc = reg) then
						if inputA = inputB then
							temp_out := zero_16;
						else
							temp_out := "0000000000000001";
						end if;
					else
						temp_out := zero_16;
					end if;
					
	--</hxx>
				when others =>
					temp_out := Zero_16;
			end case;
		end if;
		
		output <= temp_out;
		
	end process;


end Behavioral;


