--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:28:04 11/18/2016
-- Design Name:   
-- Module Name:   F:/myCPU/testPC.vhd
-- Project Name:  myCPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pc_reg
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
use work.type_lib.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testPC IS
END testPC;
 
ARCHITECTURE behavior OF testPC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pc_reg
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ce : OUT  std_logic;
         pc : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
	 COMPONENT Ram2
    Port ( if_pc : in  STD_LOGIC_VECTOR (15 downto 0);
     --      mem_addr : in  STD_LOGIC_VECTOR (15 downto 0);
     --      mem_data : in  STD_LOGIC_VECTOR (15 downto 0);
           inst : out  STD_LOGIC_VECTOR (15 downto 0);
     --      clk : in  STD_LOGIC;
           ce : in  STD_LOGIC);
    END COMPONENT;
	 
	 COMPONENT if_id
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           if_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           if_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
  --         flush : in  STD_LOGIC;
  --         stall : in  STD_LOGIC;
			  
           id_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           id_inst : out  STD_LOGIC_VECTOR (15 downto 0));
	 END COMPONENT;
	 
	 COMPONENT interpreter
	 Port ( rst : in STD_LOGIC;
			  id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
	 
			  read_reg1 : out STD_LOGIC_VECTOR (3 downto 0);
			  read_reg2 : out STD_LOGIC_VECTOR (3 downto 0);
			  
			  imme : out STD_LOGIC_VECTOR(15 downto 0);
			  
			  write_reg : out STD_LOGIC_VECTOR (3 downto 0)
			  );
	 END COMPONENT;
	 
	 COMPONENT controller
	 Port ( rst : in STD_LOGIC;
			  id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  all_zero : in std_logic;
	 
			  control_id : out id_control;
			  control_ex : out ex_control;
			  control_mem : out mem_control;
			  control_wb : out wb_control;
			  control_flush: out flush_control
			  );
	 END COMPONENT;
	 
	 COMPONENT branch_ctrl
	 port (id_pc : in  STD_LOGIC_VECTOR (15 downto 0); 
           int_imme : in  STD_LOGIC_VECTOR (15 downto 0); 
			  int_inputA : in std_logic_vector (15 downto 0);
			  
           ctrl_branch : in  STD_LOGIC;
			  rst : in std_logic;
			  ctrl_branch_type : in bt;
			  
			  ctrl_pc : out std_logic_vector (15 downto 0);
			  branch_confirm : out std_logic
			);
	 END COMPONENT;
	 
	 COMPONENT Regfile
	 Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  
			  --写端口
           writeAddr : in  STD_LOGIC_VECTOR (3 downto 0);
           writeData : in  STD_LOGIC_VECTOR (15 downto 0);
           we : in  STD_LOGIC;
			  
			  --读端口1
           readAddr1 : in  STD_LOGIC_VECTOR (3 downto 0);
           re1 : in  STD_LOGIC;
           readData1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --读端口2
           readAddr2 : in  STD_LOGIC_VECTOR (3 downto 0);
           re2 : in  STD_LOGIC;
           readData2 : out  STD_LOGIC_VECTOR (15 downto 0));
	  END COMPONENT;
	 
	 COMPONENT ID_EX
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  ID_EXControl : in ex_control;
			  ID_MEMControl : in mem_control;
			  ID_WBControl : in wb_control;
  --       EX_flush_I : in  STD_LOGIC;
  
			  ID_Reg1 : in STD_LOGIC_VECTOR (15 downto 0);
			  ID_Reg2 : in STD_LOGIC_VECTOR (15 downto 0);
			  ID_Imme : in STD_LOGIC_VECTOR (15 downto 0);
			  
			  ID_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  EX_EXControl : out ex_control;
			  EX_MEMControl : out mem_control;
			  EX_WBControl : out wb_control;
			  
			  EX_Reg1 : out STD_LOGIC_VECTOR (15 downto 0);
			  EX_Reg2 : out STD_LOGIC_VECTOR (15 downto 0);
			  EX_Imme : out STD_LOGIC_VECTOR (15 downto 0);
			  
			  EX_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
	 END COMPONENT;
	 
	 COMPONENT ALU
	 Port ( 
           rst : in  STD_LOGIC;
           inputA : in STD_LOGIC_VECTOR (15 downto 0);--rx
			  inputB : in STD_LOGIC_VECTOR (15 downto 0);--ry
			  inputC : in STD_LOGIC_VECTOR (15 downto 0);--immediate
			  
			  EXControl : in ex_control; --控制信号
			  MEMControl_I : in mem_control;
			  WBControl_I : in wb_control;
  --       EX_flush_I : in  STD_LOGIC;
			  
			  EX_RegWrite_I : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  MEMControl_O : out mem_control;
			  WBControl_O : out wb_control;
			  MEM_RegWrite_O : out STD_LOGIC_VECTOR (3 downto 0);
			  
           output : out  STD_LOGIC_VECTOR (15 downto 0));
	 END COMPONENT;
	 
	 COMPONENT EX_MEM
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  EX_MEMControl : in mem_control;
			  EX_WBControl : in wb_control;
			  
			  EX_ALUAns : in STD_LOGIC_VECTOR (15 downto 0);
			  EX_ALUinputB: in STD_LOGIC_VECTOR (15 downto 0);
			  EX_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  
			  MEM_MEMControl : out mem_control;
			  MEM_WBControl : out wb_control;
			  
			  MEM_ALUAns : out STD_LOGIC_VECTOR (15 downto 0);
			  MEM_ALUinputB : out STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
		END COMPONENT;

	COMPONENT mem
	Port (  clk: in STD_LOGIC;
			  rst : in  STD_LOGIC;
           MEMControl_i : in  mem_control;
           WBControl_i : in  wb_control;
           ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUinputB_i : in  STD_LOGIC_VECTOR (15 downto 0);
           RegWrite_i : in  STD_LOGIC_VECTOR (3 downto 0);
			  
           WBControl_o : out  wb_control;
           RegWrite_o : out  STD_LOGIC_VECTOR (3 downto 0);
			  ALUAns_o : out STD_LOGIC_VECTOR (15 downto 0);
           Ram1Data_o : out  STD_LOGIC_VECTOR (15 downto 0)); 
	END COMPONENT;
	
	COMPONENT MEM_WB
	Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  MEM_WBControl : in wb_control;
			  
			  RAM1_Data : in STD_LOGIC_VECTOR (15 downto 0);
			  RAM2_Data : in STD_LOGIC_VECTOR (15 downto 0);
			  ALUAns : in STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  WB_WBControl : out wb_control;
			  RegWriteData : out STD_LOGIC_VECTOR (15 downto 0);
			  WB_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
	END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
	
	--PC输出
   signal ce : std_logic;
   signal pc : std_logic_vector(15 downto 0);
	--RAM2输出
	signal inst : std_logic_vector(15 downto 0);
	--IF/ID输出
	signal id_pc : std_logic_vector(15 downto 0);
	signal id_inst : std_logic_vector(15 downto 0);
	--译码器输出
	signal read_reg1 : STD_LOGIC_VECTOR (3 downto 0);
	signal read_reg2 : STD_LOGIC_VECTOR (3 downto 0);
	signal imme : STD_LOGIC_VECTOR(15 downto 0);
	signal write_reg : STD_LOGIC_VECTOR (3 downto 0);
	--控制器输出
	signal control_id : id_control;
	signal control_ex : ex_control;
	signal control_mem : mem_control;
	signal control_wb : wb_control;
	signal control_flush: flush_control;
	--分支选择器输出
	signal ctrl_pc : std_logic_vector(15 downto 0);
	signal confirm_branch : std_logic;
	--寄存器堆输出
	signal readData1 : STD_LOGIC_VECTOR (15 downto 0);
	signal readData2 : STD_LOGIC_VECTOR (15 downto 0);
	--ID/EX输出
	signal EX_EXControl_i : ex_control;
	signal EX_MEMControl_i : mem_control;
	signal EX_WBControl_i : wb_control;
	signal EX_Reg1_i : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_Reg2_i : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_Imme_i : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_RegWrite_i : STD_LOGIC_VECTOR (3 downto 0);
	--ALU输出
	signal EX_MEMControl_o : mem_control;
	signal EX_WBControl_o : wb_control;
	signal EX_RegWrite_o : STD_LOGIC_VECTOR (3 downto 0);
	signal ALUoutput : STD_LOGIC_VECTOR (15 downto 0);
	--EX/MEM输出
	signal mem_MEMControl_i : mem_control;
	signal mem_WBControl_i : wb_control;
	signal mem_ALUAns_i : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_ALUinputB_i : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_RegWrite_i : STD_LOGIC_VECTOR (3 downto 0);
	--mem输出
	signal mem_WBControl_o : wb_control;
	signal mem_RegWrite_o : STD_LOGIC_VECTOR (3 downto 0);
	signal mem_ALUAns_o : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_Ram1Data_o : STD_LOGIC_VECTOR (15 downto 0); 
	--MEM/WB输出
	signal wb_WBControl_i : wb_control;
	signal wb_RegWriteData_i : STD_LOGIC_VECTOR (15 downto 0);
	signal wb_RegWrite_i : STD_LOGIC_VECTOR (3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pc_reg PORT MAP (
			--in
          clk => clk,
          rst => rst,
			--out
          ce => ce,
          pc => pc
        );
		  
	uram: Ram2 PORT MAP (
			--in
			if_pc => pc,
			ce => ce,
			--out
			inst => inst
			);
			
	uif_id: if_id PORT MAP (
			--in
			clk => clk, 
			rst => rst, 
			if_pc => pc, 
			if_inst => inst,
			--out
			id_pc => id_pc,
			id_inst => id_inst
			);
			
	uinterpreter: interpreter PORT MAP (
			--in
			rst => rst,
			id_inst => id_inst,
			--out
			read_reg1 => read_reg1,
			read_reg2 => read_reg2,
			imme => imme,
			write_reg => write_reg
	);
	
	ucontroller: controller PORT MAP (
			--in
			rst => rst,
			id_inst => id_inst,
			all_zero => '0',
			--out
			control_id => control_id,
			control_ex => control_ex,
			control_mem => control_mem,
			control_wb => control_wb,
			control_flush => control_flush
	);
	
	ubranch_ctrl: branch_ctrl PORT MAP (
			--in
			rst => rst,
			id_pc => id_pc,
			int_imme => imme,
			int_inputA => readData1,
			ctrl_branch => control_id.branch,
			ctrl_branch => control_id.branchType,
			
			--out
			ctrl_pc => ctrl_pc,
			branch_confirm => branch_confirm
	);
	
	uregfile: Regfile PORT MAP (
			--in
			rst => rst,
         clk => clk, 
			  
			  --写端口
         writeAddr => wb_RegWrite_i,
         writeData => wb_RegWriteData_i,
         we => wb_WBControl_i.regWrite, 
			  
			  --读端口1
         readAddr1 => read_reg1,
         re1 => '1',
         
			  
			  --读端口2
         readAddr2 => read_reg2,
         re2 => '1',
			
			--out
			readData1 => readData1,
         readData2 => readData2
	);
	
	uid_ex: ID_EX PORT MAP (
			--in
			clk => clk,
         rst => rst,
			  
			ID_EXControl => control_ex,
			ID_MEMControl => control_mem,
			ID_WBControl => control_wb,
  --     EX_flush_I => control_flush.ex_flush,
  
			ID_Reg1 => readData1,
			ID_Reg2 => readData2,
			ID_Imme => imme,
			  
			ID_RegWrite => write_reg,
			
			--out
			EX_EXControl => EX_EXControl_i,
			EX_MEMControl => EX_MEMControl_i,
			EX_WBControl => EX_WBControl_i,

			EX_Reg1 => EX_Reg1_i,
			EX_Reg2 => EX_Reg2_i,
			EX_Imme => EX_Imme_i,
			EX_RegWrite => EX_RegWrite_i
	);
	
	ualu: ALU PORT MAP (
			--in
			rst => rst,
			inputA => EX_Reg1_i,--rx
			inputB => EX_Reg2_i,--ry
			inputC => EX_Imme_i,--immediate

			EXControl => EX_EXControl_i, --控制信号
			MEMControl_I => EX_MEMControl_i,
			WBControl_I => EX_WBControl_i,

			EX_RegWrite_I => EX_RegWrite_i,

			--out
			MEMControl_O => EX_MEMControl_o,
			WBControl_O => EX_WBControl_o,
			MEM_RegWrite_O => EX_RegWrite_o,

			output => ALUoutput
	);
	
	uex_mem: EX_MEM PORT MAP (
			--in
			clk => clk,
			rst => rst,

			ex_MEMControl => ex_MEMControl_o,
			ex_WBControl => ex_WBControl_o,

			ex_ALUAns => ALUoutput,
			ex_ALUinputB => EX_Reg2_i,
			ex_RegWrite => EX_RegWrite_o,

			--out
			mem_MEMControl => mem_MEMControl_i,
			mem_WBControl => mem_WBControl_i,

			mem_ALUAns => mem_ALUAns_i,
			mem_ALUinputB => mem_ALUinputB_i,
			mem_RegWrite => mem_RegWrite_i
	);
	
	umem: mem PORT MAP (
			--in
			clk => clk,
			rst => rst,
			MEMControl_i => mem_MEMControl_i,
			WBControl_i => mem_WBControl_i,
			ALUAns_i => mem_ALUAns_i,
			ALUinputB_i => mem_ALUinputB_i,
			RegWrite_i => mem_RegWrite_i,
			--out
			WBControl_o => mem_WBControl_o,
			RegWrite_o => mem_RegWrite_o,
			ALUAns_o => mem_ALUAns_o,
			Ram1Data_o => mem_Ram1Data_o
	);
	
	umem_wb: MEM_WB PORT MAP (
			--in
			clk => clk,
			rst => rst,

			MEM_WBControl => mem_WBControl_o,

			RAM1_Data => mem_Ram1Data_o,
			RAM2_Data => Zero_16,
			ALUAns => mem_ALUAns_o,
			MEM_RegWrite => mem_RegWrite_o,
			--out
			WB_WBControl => wb_WBControl_i,
			RegWriteData => wb_RegWriteData_i,
			WB_RegWrite => wb_RegWrite_i
		
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
		rst <= '0';
      -- insert stimulus here 
		
      wait;
   end process;

END;
