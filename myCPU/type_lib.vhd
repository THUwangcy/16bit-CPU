 --
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package type_lib is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

	--数组类型
	TYPE RAM is array (65535 downto 0) of std_logic_vector(15 downto 0);
	TYPE RegGroup is array (15 downto 0) of std_logic_vector(15 downto 0);

	--rst
	constant RstEnable : STD_LOGIC := '0';
	constant RstDisable : STD_LOGIC := '1';
	
	--指令寄存器
	constant Ram2Enable : STD_LOGIC := '1';
	constant Ram2Disable : STD_LOGIC := '0';
	
	--读信号
	constant ReadEnable : STD_LOGIC := '1';
	constant ReadDisable : STD_LOGIC := '0';
	
	--写信号
	constant WriteEnable : STD_LOGIC := '1';
	constant WriteDisable : STD_LOGIC := '0';
	
	--模块使能
	constant ChipEnable : STD_LOGIC := '1';
	constant ChipDisable : STD_LOGIC := '0';
	
	--暂停
	constant Stop : STD_LOGIC := '1';
	constant NoStop : STD_LOGIC := '0';
	
	--跳转
	constant Branch : STD_LOGIC := '1';
	constant NoBranch : STD_LOGIC := '0';
	
	--冲突
	constant Conflict : STD_LOGIC := '1';
	constant NoConflict : STD_LOGIC := '0';
	
	--Zero
	constant Zero_18 : STD_LOGIC_VECTOR (17 downto 0):= (others => '0');
	constant Zero_16 : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
	constant Zero_14 : STD_LOGIC_VECTOR (13 downto 0):= (others => '0');
	constant Zero_4 : STD_LOGIC_VECTOR (3 downto 0):= (others => '0');
	constant Zero_5 : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');
	
	--HighZ
	constant HighZ_16 : STD_LOGIC_VECTOR (15 downto 0) := (others => 'Z');
	
	--指令寄存器数组长度
	constant InstMemNum : INTEGER := 32767;
	
	--特殊寄存器编号
	constant sp : STD_LOGIC_VECTOR (3 downto 0):= "1000";
	constant pc : STD_LOGIC_VECTOR (3 downto 0):= "1001";
	constant ra : STD_LOGIC_VECTOR (3 downto 0):= "1010";
	constant t  : STD_LOGIC_VECTOR (3 downto 0):= "1011";
	constant ih : STD_LOGIC_VECTOR (3 downto 0):= "1100";
	constant no_read : std_logic_vector (3 downto 0):= "1111";
	constant no_write : std_logic_vector (3 downto 0):= "1111";
	
	
	--串口状态地址
	constant serialStateAddr : STD_LOGIC_VECTOR (15 downto 0):= "1011111100000001";
	--串口地址
	constant serialAddr : STD_LOGIC_VECTOR (15 downto 0):= "1011111100000000";


	--控制信号
	
	type bt is (EZ, NEZ, D, NONE);
	type as is (Imme, Reg, NONE);
	type mtr is (ALU, Mem, NONE);
	type alutype is (ADDU, SUBU, ANDU, ORU, XORU, SLLU, 
				SRAU, SRLU, EQUAL1, EQUAL2, EQUAL0, SLTU, NONE );
	
	type id_control is record
		branch : std_logic;
		branchType : bt;
		jump : std_logic;
	end record id_control;
	
	type ex_control is record
		ALUSrc : as;
		ALUOp : alutype;
	end record ex_control;
	
	type mem_control is record
		memRead : std_logic;
		memWrite : std_logic;
	end record mem_control;
	
	type wb_control is record
		regWrite : std_logic;
		memToReg : mtr;
	end record wb_control;

	type flush_control is record
		if_flush : std_logic;
		id_flush : std_logic;
		ex_flush : std_logic;
	end record flush_control;
	
	type ram_control is record
		EN: STD_LOGIC;
		OE: STD_LOGIC;
		WE: STD_LOGIC;
	end record;
	
	
	--record默认值
	constant id_control_none : id_control := ('0', NONE, '0');
	constant ex_control_none : ex_control := (NONE, NONE);
	constant mem_control_none : mem_control := (ReadDisable, WriteDisable);
	constant wb_control_none : wb_control := (WriteDisable, NONE);
	constant flush_control_none : flush_control := ('0', '0', '0');
	constant ram_control_none : ram_control := ('1', '1', '1');
	
	constant ram_WriteEnable : ram_control := ('0', '1', '0');
	constant ram_ReadEnable : ram_control := ('0', '0', '1');

end type_lib;

package body type_lib is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end type_lib;
