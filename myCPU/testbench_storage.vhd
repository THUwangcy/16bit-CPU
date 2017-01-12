--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:22:09 11/24/2016
-- Design Name:   
-- Module Name:   C:/Users/sword/Desktop/myCPU_3/myCPU/testbench_storage.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: storage_test
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
 
ENTITY testbench_storage IS
END testbench_storage;
 
ARCHITECTURE behavior OF testbench_storage IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT storage_test
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         input : IN  std_logic_vector(15 downto 0);
         output : OUT  std_logic_vector(15 downto 0);
         rdn : OUT  std_logic;
         wrn : OUT  std_logic;
         ram1_control : OUT  ram_control;
         ram2_control : OUT  ram_control;
         ram1_data_io : INOUT  std_logic_vector(15 downto 0);
         ram2_data_io : INOUT  std_logic_vector(15 downto 0);
         ram1_addr_o : OUT  std_logic_vector(17 downto 0);
         ram2_addr_o : OUT  std_logic_vector(17 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal input : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal ram1_data_io : std_logic_vector(15 downto 0);
   signal ram2_data_io : std_logic_vector(15 downto 0);

 	--Outputs
   signal output : std_logic_vector(15 downto 0);
   signal rdn : std_logic;
   signal wrn : std_logic;
   signal ram1_control : ram_control;
   signal ram2_control : ram_control;
   signal ram1_addr_o : std_logic_vector(17 downto 0);
   signal ram2_addr_o : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: storage_test PORT MAP (
          clk => clk,
          rst => rst,
          input => input,
          output => output,
          rdn => rdn,
          wrn => wrn,
          ram1_control => ram1_control,
          ram2_control => ram2_control,
          ram1_data_io => ram1_data_io,
          ram2_data_io => ram2_data_io,
          ram1_addr_o => ram1_addr_o,
          ram2_addr_o => ram2_addr_o
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
      wait for 100 ns;	
		rst <= '1';
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
