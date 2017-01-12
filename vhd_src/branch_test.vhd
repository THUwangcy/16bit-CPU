--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:38:38 11/22/2016
-- Design Name:   
-- Module Name:   C:/Users/hexixun0910/Desktop/myCPU/branch_test.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: branch_ctrl
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
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use work.type_lib.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY branch_test IS
END branch_test;
 
ARCHITECTURE behavior OF branch_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT branch_ctrl
    PORT(
         id_pc : IN  std_logic_vector(15 downto 0);
         int_imme : IN  std_logic_vector(15 downto 0);
         int_inputA : IN  std_logic_vector(15 downto 0);
         ctrl_branch : IN  std_logic;
         rst : IN  std_logic;
         ctrl_branch_type : IN  bt;
         ctrl_pc : OUT  std_logic_vector(15 downto 0);
         branch_confirm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal id_pc : std_logic_vector(15 downto 0) := (others => '0');
   signal int_imme : std_logic_vector(15 downto 0) := (others => '0');
   signal int_inputA : std_logic_vector(15 downto 0) := (others => '0');
   signal ctrl_branch : std_logic := '0';
   signal rst : std_logic := '0';
   signal ctrl_branch_type : bt := none;

 	--Outputs
   signal ctrl_pc : std_logic_vector(15 downto 0);
   signal branch_confirm : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: branch_ctrl PORT MAP (
          id_pc => id_pc,
          int_imme => int_imme,
          int_inputA => int_inputA,
          ctrl_branch => ctrl_branch,
          rst => rst,
          ctrl_branch_type => ctrl_branch_type,
          ctrl_pc => ctrl_pc,
          branch_confirm => branch_confirm
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '0';
      wait for 100 ns;	
		rst <= '1';
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '0';
		ctrl_branch_type <= none;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '1';
		ctrl_branch_type <= d;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "1111111111111111";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '1';
		ctrl_branch_type <= d;

		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '1';
		ctrl_branch_type <= ez;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000001";
		ctrl_branch <= '1';
		ctrl_branch_type <= ez;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000001";
		ctrl_branch <= '1';
		ctrl_branch_type <= nez;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '1';
		ctrl_branch_type <= nez;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '0';
		ctrl_branch_type <= nez;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '0';
		ctrl_branch_type <= d;
		
		wait for 100 ns;
		id_pc <= "0000111100001111";
		int_imme <= "0000000000000001";
		int_inputA <= "0000000000000000";
		ctrl_branch <= '0';
		ctrl_branch_type <= d;
		


      -- insert stimulus here 

      wait;
   end process;

END;
