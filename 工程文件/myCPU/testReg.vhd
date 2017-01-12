--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:00:50 11/18/2016
-- Design Name:   
-- Module Name:   F:/myCPU/testReg.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Regfile
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
 
ENTITY testReg IS
END testReg;
 
ARCHITECTURE behavior OF testReg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Regfile
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         writeAddr : IN  std_logic_vector(3 downto 0);
         writeData : IN  std_logic_vector(15 downto 0);
         we : IN  std_logic;
         readAddr1 : IN  std_logic_vector(3 downto 0);
         re1 : IN  std_logic;
         readData1 : OUT  std_logic_vector(15 downto 0);
         readAddr2 : IN  std_logic_vector(3 downto 0);
         re2 : IN  std_logic;
         readData2 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal writeAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal writeData : std_logic_vector(15 downto 0) := (others => '0');
   signal we : std_logic := '0';
   signal readAddr1 : std_logic_vector(3 downto 0) := (others => '0');
   signal re1 : std_logic := '0';
   signal readAddr2 : std_logic_vector(3 downto 0) := (others => '0');
   signal re2 : std_logic := '0';

 	--Outputs
   signal readData1 : std_logic_vector(15 downto 0);
   signal readData2 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Regfile PORT MAP (
          rst => rst,
          clk => clk,
          writeAddr => writeAddr,
          writeData => writeData,
          we => we,
          readAddr1 => readAddr1,
          re1 => re1,
          readData1 => readData1,
          readAddr2 => readAddr2,
          re2 => re2,
          readData2 => readData2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '0';
		writeAddr <= "0001";
		writeData <= "0000000000000010";
      wait for 100 ns;	
		rst <= '1';
		we <= '1';
      wait for clk_period;
		we <= '0';
		readAddr1 <= "0001";
		re1 <= '1';
		wait for clk_period;
		we <= '0';
		re1 <= '0';
		readAddr2 <= "0001";
		re2 <= '1';
		wait for clk_period;
		writeAddr <= "0010";
		writeData <= "0000000000000011";
		we <= '1';
		readAddr1 <= "0010";
		re1 <= '1';
		readAddr2 <= "0010";
		re2 <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
