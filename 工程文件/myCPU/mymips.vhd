----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:30:06 11/21/2016 
-- Design Name: 
-- Module Name:    mymips - Behavioral 
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
use work.type_lib.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mymips is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
       --    int_i : in  STD_LOGIC;
			  
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  data_ready : in STD_LOGIC;
			  
			  --硬件中断
			  hard_int : in STD_LOGIC;
			  
			  --分频控制
		--	  clk_ctr : in STD_LOGIC;
		--	  clk_50 : in STD_LOGIC;
			  
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
			  is_booting : out STD_LOGIC;
			  
           ram1_control : out ram_control;
           ram2_control : out ram_control;
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram1_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
			  --键盘
			  ps2clk : in std_logic;
			  ps2data : in std_logic;
			  
			  int_signal : out std_logic;
			  data_display : out std_logic_vector(7 downto 0);
			  
			  --VGA
			   r : out STD_LOGIC_VECTOR(2 downto 0);
				g : out STD_LOGIC_VECTOR(2 downto 0); 
				b : out STD_LOGIC_VECTOR(2 downto 0); 
				
				hs : out STD_LOGIC; --行同步信号
				vs : out STD_LOGIC  --场同步信号
			);
			  
end mymips;

architecture Behavioral of mymips is
	COMPONENT pc_reg
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
			stall : in STD_LOGIC_VECTOR (4 downto 0);
			branchAddr: in STD_LOGIC_VECTOR (15 downto 0);
			jumpAddr: in STD_LOGIC_VECTOR (15 downto 0);
			PCBranchSrc: in STD_LOGIC;
			PCJumpSrc: in STD_LOGIC;

         pc : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT if_id
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           if_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           if_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  stall : in STD_LOGIC_VECTOR (4 downto 0);
			  
			  hard_int : in STD_LOGIC;
			  
           id_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           id_inst : out  STD_LOGIC_VECTOR (15 downto 0));
	 END COMPONENT;
	 
	 COMPONENT interpreter
	 Port ( rst : in STD_LOGIC;
			  id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
			  id_pc : in std_logic_vector(15 downto 0);
	 
			  read_reg1 : out STD_LOGIC_VECTOR (3 downto 0);
			  read_reg2 : out STD_LOGIC_VECTOR (3 downto 0);
			  
			  imme : out STD_LOGIC_VECTOR(15 downto 0);
			  
			  write_reg : out STD_LOGIC_VECTOR (3 downto 0)
			  );
	 END COMPONENT;
	 
	 COMPONENT controller
	 Port ( rst : in STD_LOGIC;
			  id_inst : in  STD_LOGIC_VECTOR (15 downto 0);
	 
			  control_id : out id_control;
			  control_ex : out ex_control;
			  control_mem : out mem_control;
			  control_wb : out wb_control
			  );
	 END COMPONENT;
	 
	 COMPONENT branch_ctrl
	 port (id_pc : in  STD_LOGIC_VECTOR (15 downto 0); 
           int_imme : in  STD_LOGIC_VECTOR (15 downto 0); 
			  int_inputA : in std_logic_vector (15 downto 0);
			  
           ctrl_branch : in  STD_LOGIC;
			  stallreq_load : in std_logic;
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
           readData1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --读端口2
           readAddr2 : in  STD_LOGIC_VECTOR (3 downto 0);
           readData2 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  	--twl 执行阶段数据前推
			  EX_RegWrite_I : in STD_LOGIC_VECTOR (3 downto 0);
			  EX_WriteData_I : in  STD_LOGIC_VECTOR (15 downto 0);
			  EX_RegWriteEnable_I : in STD_LOGIC;
			  
			  --twl 访存阶段数据前推
			  MEM_RegWrite_I : in STD_LOGIC_VECTOR (3 downto 0);
			  MEM_WriteData_I : in  STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWriteEnable_I : in STD_LOGIC
			  
			  );
	  END COMPONENT;
	 
	 COMPONENT ID_EX
	 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  ID_EXControl : in ex_control;
			  ID_MEMControl : in mem_control;
			  ID_WBControl : in wb_control;
			  stall : in STD_LOGIC_VECTOR (4 downto 0);
  
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
	Port ( rst : in  STD_LOGIC;
           MEMControl_i : in  mem_control;
           ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
      --     ALUinputB_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  --load指令加入
			  Ram1Data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  --结构冲突
			  Ram2Data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  stallreq_ram_conflict : out STD_LOGIC;
			  ALUAns_o : out STD_LOGIC_VECTOR (15 downto 0);
           RamData_o : out  STD_LOGIC_VECTOR (15 downto 0));
	END COMPONENT;
	
	COMPONENT MEM_WB
	Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  MEM_WBControl : in wb_control;
			  
			  RAM_Data : in STD_LOGIC_VECTOR (15 downto 0);
			  ALUAns : in STD_LOGIC_VECTOR (15 downto 0);
			  MEM_RegWrite : in STD_LOGIC_VECTOR (3 downto 0);
			  
			  WB_WBControl : out wb_control;
			  RegWriteData : out STD_LOGIC_VECTOR (15 downto 0);
			  WB_RegWrite : out STD_LOGIC_VECTOR (3 downto 0));
	END COMPONENT;
	
	COMPONENT ctrl
	Port ( rst : in  STD_LOGIC;
           stallreq_from_id : in  STD_LOGIC;
           stallreq_ram_conflict : in  STD_LOGIC;
           stallreq_branch : in  STD_LOGIC;
			  stallreq_jump : in STD_LOGIC;
			  
           stall : out  STD_LOGIC_VECTOR (4 downto 0));
	END COMPONENT;
	
	COMPONENT load_related
	Port ( rst : in STD_LOGIC;
			  ex_memRead : in  STD_LOGIC;
           ex_regWrite : in  STD_LOGIC_VECTOR (3 downto 0);
           id_reg1 : in  STD_LOGIC_VECTOR (3 downto 0);
           id_reg2 : in  STD_LOGIC_VECTOR (3 downto 0);
           stallreq_load : out  STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Ram1_adapter
	Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  MEMControl_i : in  mem_control;
			  ALUAns_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  ALUinputB_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  data_ready : in STD_LOGIC;
			--  ram1_adapter_data_i : in STD_LOGIC_VECTOR (15 downto 0);
           
			  ram1_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --<wcy串口加入
			  rdn: out STD_LOGIC;
			  wrn: out STD_LOGIC;
			  --wcy>
			  
           mem_addr_o : out  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
			  ram1_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
			  ram2_control_o : out  ram_control;
           ram1_control_o : out  ram_control);
	END COMPONENT;
	
	COMPONENT ram2_adapter
	Port (  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  pc : in  STD_LOGIC_VECTOR (15 downto 0);
           has_ram_conflict : in  STD_LOGIC;
			  
			  booting : in STD_LOGIC;
			  flash_addr_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  flash_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           mem_addr_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
           mem_ram2_control_i : in  ram_control;
		--	  ram2_adapter_data_i : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  ram2_adapter_data_o : out  STD_LOGIC_VECTOR (15 downto 0);
           ram2_addr_o : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_data_io : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_control_o : out  ram_control);
	END COMPONENT;
	
	component flash_io
    Port ( 
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  addr_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  booting : out STD_LOGIC;
			  clk : in std_logic;--随便什么时钟
			  reset : in std_logic;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  --flash_sts : in std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0)
	);
	end component;
	
	COMPONENT my_keyboard
		port(
			clk : in std_logic;
			rst : in std_logic;
			ps2clk : in std_logic;
			ps2data : in std_logic;

			request : out std_logic;
			data : out std_logic_vector(7 downto 0);
			con_clk : out std_logic
		);
	 END COMPONENT;
	 
	 COMPONENT acsii 
		port ( rst : in std_logic;
				clk : in std_logic;
				request : in std_logic;
				data : in std_logic_vector (7 downto 0);

				ascii : out std_logic_vector (7 downto 0);
				asc_clk : out std_logic
			);
	 END COMPONENT;
	 
	 COMPONENT vga_top
		port(
			clk_out: in std_logic;
			rst: in std_logic;
			char_we: in std_logic:='0';
			char_value: in std_logic_vector(7 downto 0);

			r : out STD_LOGIC_VECTOR(2 downto 0);
			g : out STD_LOGIC_VECTOR(2 downto 0); 
			b : out STD_LOGIC_VECTOR(2 downto 0); 
			
			hs : out STD_LOGIC; --行同步信号
			vs : out STD_LOGIC  --场同步信号
		);
	 END COMPONENT;

 	--Outputs
	
	--PC输出
--   signal ram2_ce : std_logic;
   signal pc : std_logic_vector(15 downto 0);
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
	--分支选择器输出
	signal ctrl_pc : std_logic_vector(15 downto 0);
	signal branch_confirm	: std_logic;
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
	signal ALUoutput : STD_LOGIC_VECTOR (15 downto 0);
	--EX/MEM输出
	signal mem_MEMControl_i : mem_control;
	signal mem_WBControl_i : wb_control;
	signal mem_ALUAns_i : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_ALUinputB_i : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_RegWrite_i : STD_LOGIC_VECTOR (3 downto 0);
	--mem输出
	signal mem_ALUAns_o : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_RamData_o : STD_LOGIC_VECTOR (15 downto 0); 
	signal stallreq_ram_conflict : STD_LOGIC;
	--ram1_adapter输出
	signal ram1_adapter_data_o : STD_LOGIC_VECTOR (15 downto 0); 
	signal mem_addr_o : STD_LOGIC_VECTOR (15 downto 0);
	signal mem_data_o : STD_LOGIC_VECTOR (15 downto 0);
	signal ram2_control_o : ram_control;
	signal ram1_control_o : ram_control;
	--ram2_adapter输出
	signal ram2_adapter_data_o : STD_LOGIC_VECTOR (15 downto 0); 
	--MEM/WB输出
	signal wb_WBControl_i : wb_control;
	signal wb_RegWriteData_i : STD_LOGIC_VECTOR (15 downto 0);
	signal wb_RegWrite_i : STD_LOGIC_VECTOR (3 downto 0);
	--ctrl暂停输出
	signal stall : STD_LOGIC_VECTOR (4 downto 0);
	--load_related输出
	signal stallreq_load : STD_LOGIC;
	--flash输出
	signal flash_data_output : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
	signal flash_addr_output : STD_LOGIC_VECTOR (15 downto 0) := Zero_16;
	signal booting : STD_LOGIC;
	--键盘输出中断信号
	 signal int_keyboard : STD_LOGIC;
	 signal request_keyboard : STD_LOGIC;
	 signal data_keyboard : STD_LOGIC_VECTOR(7 downto 0);
	 signal ascii_keyboard : std_logic_vector (7 downto 0);
	 signal asc_clk_keyboard : std_logic;
	
--	signal clk_2 : STD_LOGIC_VECTOR (1 downto 0);
	signal clk_out : STD_LOGIC;
	signal clk_flash : STD_LOGIC;
	
	signal rst_booting : STD_LOGIC;
	
begin
	-- Instantiate the Unit Under Test (UUT)
	
	process (clk)
		variable clk_2 : STD_LOGIC_VECTOR (0 downto 0) := "0";
		variable clk_4 : STD_LOGIC_VECTOR (1 downto 0) := "00";
		variable clk_16 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
	begin
		if (rising_edge(clk)) then
			clk_2 := clk_2 + '1';
			clk_4 := clk_4 + '1';
			clk_16 := clk_16 + '1';
		end if;
	--	if (clk_50 = '1') then
	--		clk_out <= clk;
	--	else
	--		if (clk_ctr = '0') then
				clk_out <= clk_2(0);
	--		else
	--			clk_out <= clk_4(1);
	--		end if;
	--	end if;
		clk_flash <= clk_16(3);

	end process;
	
	ctrl_INSTANCE: ctrl PORT MAP (
			--in
			rst => rst_booting,
			--这里之后连三个可能请求暂停的模块
			stallreq_from_id => stallreq_load,
		   stallreq_ram_conflict => stallreq_ram_conflict,
		   stallreq_branch => branch_confirm,
			stallreq_jump => control_id.jump,
			--out
			stall => stall
	);
	
	load_related_INSTANCE: load_related PORT MAP (
			--in
			rst => rst_booting,
			ex_memRead => EX_MEMControl_i.memRead,
			ex_regWrite => EX_RegWrite_i,
			id_reg1 => read_reg1,
			id_reg2 => read_reg2,
			--out
			stallreq_load => stallreq_load
	);
	
   pc_INSTANCE: pc_reg PORT MAP (
			--in
          clk => clk_out,
          rst => rst_booting,
			 stall => stall,
			 --这里跳转都给的0，之后要连上分支转移模块
			 branchAddr => ctrl_pc,
			 PCBranchSrc => branch_confirm,
			 --jump
			 jumpAddr => readData1,
			 PCJumpSrc => control_id.jump,
			--out
          pc => pc
        );
		  
	--写结构冲突的时候这里要去掉	  
			
	if_id_INSTANCE: if_id PORT MAP (
			--in
			clk => clk_out, 
			rst => rst_booting, 
			if_pc => pc, 
			if_inst => ram2_adapter_data_o,
			stall => stall,
			hard_int => int_keyboard,
			--out
			id_pc => id_pc,
			id_inst => id_inst
			);
			
	id_INSTANCE: interpreter PORT MAP (
			--in
			rst => rst_booting,
			id_inst => id_inst,
			id_pc => id_pc,
			--out
			read_reg1 => read_reg1,
			read_reg2 => read_reg2,
			imme => imme,
			write_reg => write_reg
	);
	
	control_INSTANCE: controller PORT MAP (
			--in
			rst => rst_booting,
			id_inst => id_inst,
			--out
			control_id => control_id,
			control_ex => control_ex,
			control_mem => control_mem,
			control_wb => control_wb
	);
	
	branch_INSTANCE: branch_ctrl PORT MAP (
			--in
			rst => rst_booting,
			id_pc => id_pc,
			int_imme => imme,
			int_inputA => readData1,
			ctrl_branch => control_id.branch,
			ctrl_branch_type => control_id.branchType,
			stallreq_load => stallreq_load,
			
			--out
			ctrl_pc => ctrl_pc,
			branch_confirm => branch_confirm
	);
	
	regfile_INSTANCE: Regfile PORT MAP (
			--in
			rst => rst_booting,
         clk => clk_out, 
			  
			  --写端口
         writeAddr => wb_RegWrite_i,
         writeData => wb_RegWriteData_i,
         we => wb_WBControl_i.regWrite, 
			  
			  --读端口1
         readAddr1 => read_reg1,
         
			  
			  --读端口2
         readAddr2 => read_reg2,
			
			  --twl 执行阶段数据前推
			EX_RegWrite_I => EX_RegWrite_i,
			EX_WriteData_I => ALUoutput,
			EX_RegWriteEnable_I => EX_WBControl_i.regWrite,

			  --twl 访存阶段数据前推
			MEM_RegWrite_I => mem_RegWrite_i,
			MEM_WriteData_I => mem_RamData_o,
			MEM_RegWriteEnable_I => mem_WBControl_i.regWrite,
				
			--out
			readData1 => readData1,
         readData2 => readData2
	);
	
	id_ex_INSTANCE: ID_EX PORT MAP (
			--in
			clk => clk_out,
         rst => rst_booting,
			stall => stall,
			  
			ID_EXControl => control_ex,
			ID_MEMControl => control_mem,
			ID_WBControl => control_wb,
  
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
	
	alu_INSTANCE: ALU PORT MAP (
			--in
			rst => rst_booting,
			inputA => EX_Reg1_i,--rx
			inputB => EX_Reg2_i,--ry
			inputC => EX_Imme_i,--immediate

			EXControl => EX_EXControl_i, --控制信号

			--out

			output => ALUoutput
	);
	
	ex_mem_INSTANCE: EX_MEM PORT MAP (
			--in
			clk => clk_out,
			rst => rst_booting,

			ex_MEMControl => EX_MEMControl_i,
			ex_WBControl => EX_WBControl_i,

			ex_ALUAns => ALUoutput,
			ex_ALUinputB => EX_Reg2_i,
			ex_RegWrite => EX_RegWrite_i,

			--out
			mem_MEMControl => mem_MEMControl_i,
			mem_WBControl => mem_WBControl_i,

			mem_ALUAns => mem_ALUAns_i,
			mem_ALUinputB => mem_ALUinputB_i,
			mem_RegWrite => mem_RegWrite_i
	);
	
	mem_INSTANCE: mem PORT MAP (
			--in
			rst => rst_booting,
			MEMControl_i => mem_MEMControl_i,
			ALUAns_i => mem_ALUAns_i,
			Ram1Data_i => ram1_adapter_data_o,
			Ram2Data_i => ram2_adapter_data_o,
			--out
			stallreq_ram_conflict => stallreq_ram_conflict,
			ALUAns_o => mem_ALUAns_o,
			RamData_o => mem_RamData_o
	);
	
	ram1_adapter_INSTANCE: Ram1_adapter PORT MAP (
			--in
			rst => rst_booting,
			clk => clk_out,
			MEMControl_i => mem_MEMControl_i,
			ALUAns_i => mem_ALUAns_i,
			ALUinputB_i => mem_ALUinputB_i,
			tsre => tsre,
			tbre => tbre,
			data_ready => data_ready,
		--	ram1_adapter_data_i => ram1_data_i,
			--out
			ram1_adapter_data_o => ram1_adapter_data_o,
			mem_addr_o => mem_addr_o,
			mem_data_o => mem_data_o,
			ram1_data_io => ram1_data_io,
			ram1_control_o => ram1_control_o,
			ram2_control_o => ram2_control_o,
			wrn => wrn,
			rdn => rdn
	);
	
	process(mem_addr_o, ram1_control_o)
	begin
		ram1_addr_o(17 downto 0) <= ("00" & mem_addr_o);
		ram1_control <= ram1_control_o;
	end process;
	
	ram2_adapter_INSTANCE: ram2_adapter PORT MAP (
			--in
			clk => clk_out,
			rst => rst,
			pc => pc,
			has_ram_conflict => stallreq_ram_conflict,
			
			flash_data_i => flash_data_output,
			flash_addr_i => flash_addr_output,
			booting => booting,
			
			mem_addr_i => mem_addr_o,
			mem_data_i => mem_data_o,
			mem_ram2_control_i => ram2_control_o,
		--	ram2_adapter_data_i => ram2_data_i,

			ram2_adapter_data_o => ram2_adapter_data_o,
			ram2_addr_o => ram2_addr_o,
			ram2_data_io => ram2_data_io,
			ram2_control_o => ram2_control
	);

	mem_wb_INSTANCE: MEM_WB PORT MAP (
			--in
			clk => clk_out,
			rst => rst_booting,

			MEM_WBControl => mem_WBControl_i,

			RAM_Data => mem_RamData_o,
			ALUAns => mem_ALUAns_o,
			MEM_RegWrite => mem_RegWrite_i,
			--out
			WB_WBControl => wb_WBControl_i,
			RegWriteData => wb_RegWriteData_i,
			WB_RegWrite => wb_RegWrite_i
		
	);
	
	flash_INSTANCE : flash_io PORT MAP (
		data_out => flash_data_output,
		addr_out => flash_addr_output,
		booting => booting,
		clk => clk_flash,
		reset => rst,
		
		flash_byte => flash_byte,
		flash_vpen => flash_vpen,
		flash_ce => flash_ce,
		flash_oe => flash_oe,
		flash_we => flash_we,
		flash_rp => flash_rp,
		--flash_sts => flash_sts,
		flash_addr => flash_addr,
		flash_data => flash_data
	);
	
	keyboard_INSTANCE : my_keyboard PORT MAP (
			clk => clk,
			rst => rst_booting,
			ps2clk => ps2clk,
			ps2data => ps2data,

			request => request_keyboard,
			data => data_keyboard,
			con_clk => int_keyboard
	);
	
	ascii_INSTANCE : acsii PORT MAP (
			rst => rst_booting,
			clk => clk,
			request => request_keyboard,
			data => data_keyboard,

			ascii => ascii_keyboard,
			asc_clk => asc_clk_keyboard
	);
	
	vga_INSTANCE : vga_top PORT MAP (
		clk_out => clk_out,
		rst => rst_booting,
		char_we => not asc_clk_keyboard,
		char_value => ascii_keyboard,

		r => r,
		g => g, 
		b => b,
		
		hs => hs,
		vs => vs
	);
	
	process(rst, booting)
	begin
		is_booting <= booting;
		rst_booting <= rst and booting;
	end process;
	
	process(data_keyboard, int_keyboard)
	begin
		data_display <= data_keyboard;
		int_signal <= int_keyboard;
	end process;

end Behavioral;

