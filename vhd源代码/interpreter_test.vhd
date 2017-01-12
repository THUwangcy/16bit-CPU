--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:59:19 11/19/2016
-- Design Name:   
-- Module Name:   C:/Users/hexixun0910/Desktop/myCPU/myCPU/interpreter_test.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: interpreter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY interpreter_test IS
END interpreter_test;
 
ARCHITECTURE behavior OF interpreter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT interpreter
    PORT(
         id_inst : IN  std_logic_vector(15 downto 0);
			rst : in std_logic;
			
         read_reg1 : OUT  std_logic_vector(3 downto 0);
         read_reg2 : OUT  std_logic_vector(3 downto 0);
         imme : OUT  std_logic_vector(15 downto 0);
         write_reg : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal id_inst : std_logic_vector(15 downto 0) ;
	signal rst : std_logic;
 	--Outputs
   signal read_reg1 : std_logic_vector(3 downto 0);
   signal read_reg2 : std_logic_vector(3 downto 0);
   signal imme : std_logic_vector(15 downto 0);
   signal write_reg : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: interpreter PORT MAP (
          id_inst => id_inst,
			 rst =>rst,
          read_reg1 => read_reg1,
          read_reg2 => read_reg2,
          imme => imme,
          write_reg => write_reg
        );

   -- Clock process definitions
 

   -- Stimulus process
	stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '0';
      wait for 100 ns;	
		rst <= '1';
--      wait for 100 ns; --addiu
--		id_inst <= "0100101101111111";
--		
--		wait for 100 ns;	--addiu3
--		id_inst <= "0100001101101011";
--		
--		wait for 100 ns;	--addsp
--		id_inst <= "0110001101111111";
--		
--		wait for 100 ns;	--addu
--		id_inst <= "1110001101101101";
--		
--		wait for 100 ns;	--and
--		id_inst <= "1110101101101100";
--		
--		wait for 100 ns;	--B
--		id_inst <= "0001001111111111";
--		
--		wait for 100 ns;	--BEQZ
--		id_inst <= "0010001101111111";
--		
--		wait for 100 ns;	--BNEZ
--		id_inst <= "0010101101111111";
--		
--		wait for 100 ns;	--BTEQZ
--		id_inst <= "0110000001111111";
--		
--		wait for 100 ns;	--BTNEZ
--		id_inst <= "0110000101111111";
--		
--		wait for 100 ns;	--CMP
--		id_inst <= "1110101101101010";
--		
--		wait for 100 ns;	--JR
--		id_inst <= "1110101100000000";
--		
--		wait for 100 ns;	--LI
--		id_inst <= "0110101101111111";
--		
--		wait for 100 ns;	--LW
--		id_inst <= "1001101101101111";
--		
--		wait for 100 ns;	--LW_SP
--		id_inst <= "1001001101111111";
--		
--		wait for 100 ns;	--MFIH
--		id_inst <= "1111001100000000";
--		
--		wait for 100 ns;	--MFPC
--		id_inst <= "1110101101000000";
--		
--		wait for 100 ns;	--MTIH
--		id_inst <= "1111001100000001";
--		
--		wait for 100 ns;	--MTSP
--		id_inst <= "0110010001100000";
--		
--		wait for 100 ns;	--NOP
--		id_inst <= "0000100000000000";
--		
--		wait for 100 ns;	--OR
--		id_inst <= "1110101101101101";
--
--		wait for 100 ns;	--SLL
--		id_inst <= "0011001101101100";
--		
--		wait for 100 ns;	--SLLV
--		id_inst <= "1110101101100100";
--		
--		wait for 100 ns;	--SLT
--		id_inst <= "1110101101100010";
--		
--		wait for 100 ns;	--SRA
--		id_inst <= "0011001101101111";
--		
--		wait for 100 ns;	--SRLV
--		id_inst <= "1110101101100110";
--		
--		wait for 100 ns;	--SUBU
--		id_inst <= "1110001101101111";
--		
--		wait for 100 ns;	--SW
--		id_inst <= "1101101101101111";
--		
--		wait for 100 ns;	--SW_RS
--		id_inst <= "0110001001111111";
		
		wait for 100 ns;	--SW_SP
		id_inst <= "1101001101111111";

      -- insert stimulus here 

      wait;
   end process;

END;
