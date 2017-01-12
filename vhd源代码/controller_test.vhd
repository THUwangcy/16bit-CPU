--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:02:32 11/20/2016
-- Design Name:   
-- Module Name:   C:/Users/hexixun0910/Desktop/myCPU/myCPU/controller_test.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
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
use work.type_lib.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY controller_test IS
END controller_test;
 
ARCHITECTURE behavior OF controller_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
         id_inst : IN  std_logic_vector(15 downto 0);
         all_zero : IN  std_logic;
			rst : in std_logic;
         control_id : OUT  id_control;
         control_ex : OUT  ex_control;
         control_mem : OUT  mem_control;
         control_wb : OUT  wb_control;
         control_flush : OUT  flush_control
        );
    END COMPONENT;
    

   --Inputs
   signal id_inst : std_logic_vector(15 downto 0);
   signal all_zero : std_logic ;
	signal rst : std_logic;
 	--Outputs
   signal control_id : id_control;
   signal control_ex : ex_control;
   signal control_mem : mem_control;
   signal control_wb : wb_control;
   signal control_flush : flush_control;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          id_inst => id_inst,
          all_zero => all_zero,
			 rst => rst,
          control_id => control_id,
          control_ex => control_ex,
          control_mem => control_mem,
          control_wb => control_wb,
          control_flush => control_flush
        );

   -- Clock process definitions
	
		stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		all_zero <= '0';
      rst <= '0';
      wait for 100 ns;	
		rst <= '1';
      wait for 100 ns; --addiu
		id_inst <= "0100101101111111";
		
		wait for 100 ns;	--addiu3
		id_inst <= "0100001101101011";
		
		wait for 100 ns;	--addsp
		id_inst <= "0110001101111111";
		
		wait for 100 ns;	--addu
		id_inst <= "1110001101101101";
		
		wait for 100 ns;	--and
		id_inst <= "1110101101101100";
		
		wait for 100 ns;	--B
		id_inst <= "0001001111111111";
		
		wait for 100 ns;	--BEQZ
		id_inst <= "0010001101111111";
		
		wait for 100 ns;	--BNEZ
		id_inst <= "0010101101111111";
		
		wait for 100 ns;	--BTEQZ
		id_inst <= "0110000001111111";
		
		wait for 100 ns;	--BTNEZ
		id_inst <= "0110000101111111";
		
		wait for 100 ns;	--CMP
		id_inst <= "1110101101101010";
		
		wait for 100 ns;	--JR
		id_inst <= "1110101100000000";
		
		wait for 100 ns;	--LI
		id_inst <= "0110101101111111";
		
		wait for 100 ns;	--LW
		id_inst <= "1001101101101111";
		
		wait for 100 ns;	--LW_SP
		id_inst <= "1001001101111111";
		
		wait for 100 ns;	--MFIH
		id_inst <= "1111001100000000";
		
		wait for 100 ns;	--MFPC
		id_inst <= "1110101101000000";
		
		wait for 100 ns;	--MTIH
		id_inst <= "1111001100000001";
		
		wait for 100 ns;	--MTSP
		id_inst <= "0110010001100000";
		
		wait for 100 ns;	--NOP
		id_inst <= "0000100000000000";
		
		wait for 100 ns;	--OR
		id_inst <= "1110101101101101";

		wait for 100 ns;	--SLL
		id_inst <= "0011001101101100";
		
		wait for 100 ns;	--SLLV
		id_inst <= "1110101101100100";
		
		wait for 100 ns;	--SLT
		id_inst <= "1110101101100010";
		
		wait for 100 ns;	--SRA
		id_inst <= "0011001101101111";
		
		wait for 100 ns;	--SRLV
		id_inst <= "1110101101100110";
		
		wait for 100 ns;	--SUBU
		id_inst <= "1110001101101111";
		
		wait for 100 ns;	--SW
		id_inst <= "1101101101101111";
		
		wait for 100 ns;	--SW_RS
		id_inst <= "0110001001111111";
		
		wait for 100 ns;	--SW_SP
		id_inst <= "1101001101111111";

      -- insert stimulus here 

      wait;
   end process;
END;
