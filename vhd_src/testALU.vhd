--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:19:49 11/20/2016
-- Design Name:   
-- Module Name:   C:/Users/sword/Desktop/myCPU/testALU.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
use IEEE.std_logic_arith.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.type_lib.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testALU IS
END testALU;
 
ARCHITECTURE behavior OF testALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         rst : IN  std_logic;
         inputA : IN  std_logic_vector(15 downto 0);
         inputB : IN  std_logic_vector(15 downto 0);
         inputC : IN  std_logic_vector(15 downto 0);
         EXControl : IN  ex_control;
         MEMControl_I : IN  mem_control;
         WBControl_I : IN  wb_control;
         EX_RegWrite_I : IN  std_logic_vector(3 downto 0);
         MEMControl_O : OUT  mem_control;
         WBControl_O : OUT  wb_control;
         MEM_RegWrite_O : OUT  std_logic_vector(3 downto 0);
         output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal inputA : std_logic_vector(15 downto 0) := (others => '0');
   signal inputB : std_logic_vector(15 downto 0) := (others => '0');
   signal inputC : std_logic_vector(15 downto 0) := (others => '0');
   signal EXControl : ex_control;
   signal MEMControl_I : mem_control;
   signal WBControl_I : wb_control;
   signal EX_RegWrite_I : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal MEMControl_O : mem_control;
   signal WBControl_O : wb_control;
   signal MEM_RegWrite_O : std_logic_vector(3 downto 0);
   signal output : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          rst => rst,
          inputA => inputA,
          inputB => inputB,
          inputC => inputC,
          EXControl => EXControl,
          MEMControl_I => MEMControl_I,
          WBControl_I => WBControl_I,
          EX_RegWrite_I => EX_RegWrite_I,
          MEMControl_O => MEMControl_O,
          WBControl_O => WBControl_O,
          MEM_RegWrite_O => MEM_RegWrite_O,
          output => output
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '0';
      wait for 100 ns;	
		rst <= '1';
      wait for 100 ns;
		inputA <= "0000000000000001";
		inputB <= "0000000000000001";
		inputC <= "0000000000000000";
		EXControl.ALUOp <= ADDU;
		EXControl.ALUSrc <= Reg;
		wait for 100 ns;	
		
		inputA <= "1000000000000111";
		inputB <= "0000000000000010";
		inputC <= "0000000000000000";
		exControl.aluop <= srau;
		exControl.alusrc <= imme;


      -- insert stimulus here 

      wait;
   end process;

END;
