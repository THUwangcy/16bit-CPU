----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:56 11/30/2016 
-- Design Name: 
-- Module Name:    vga_top - Behavioral 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_top is
	port(
		clk_out: in std_logic;
		rst: in std_logic;
		char_we: in std_logic:='0';
		char_value: in std_logic_vector(7 downto 0);

		r : out STD_LOGIC_VECTOR(2 downto 0):= (OTHERS => '0');
		g : out STD_LOGIC_VECTOR(2 downto 0):= (OTHERS => '0'); 
		b : out STD_LOGIC_VECTOR(2 downto 0):= (OTHERS => '0'); 
		
		hs : out STD_LOGIC; --行同步信号
		vs : out STD_LOGIC  --场同步信号
	);
end vga_top;

architecture Behavioral of vga_top is
	
	COMPONENT vga
		PORT(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
		
			h_counter : out STD_LOGIC_VECTOR(9 downto 0); --行计数信号
			v_counter : out STD_LOGIC_VECTOR(9 downto 0); 
			hs : out STD_LOGIC; --行同步信号
			vs : out STD_LOGIC --场同步信号
		);
	END COMPONENT;
	
	COMPONENT Char_mem
		PORT(
			clk: in std_logic;
			char_read_addr : in std_logic_vector(11 downto 0);
			char_write_addr: in std_logic_vector(11 downto 0);
			char_we : in std_logic;
			char_write_value : in std_logic_vector(7 downto 0);
			char_read_value : out std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT font_rom
		PORT(
			clk: in std_logic;
			addr: in std_logic_vector(10 downto 0);
			data: out std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--vga hs,vs=>addr
	signal hc_i_0 : STD_LOGIC_VECTOR(9 downto 0):="0000000000"; --行计数信号
	signal vc_i_0 : STD_LOGIC_VECTOR(9 downto 0):="0000000000";
	signal hc_i_1 : STD_LOGIC_VECTOR(9 downto 0):="0000000000";
	signal vc_i_1 : STD_LOGIC_VECTOR(9 downto 0):="0000000000";
	signal hc_i_2 : STD_LOGIC_VECTOR(9 downto 0):="0000000000";
	signal vc_i_2 : STD_LOGIC_VECTOR(9 downto 0):="0000000000";
	signal hs_i_0 : STD_LOGIC:='1';
	signal vs_i_0 : STD_LOGIC:='1';
	signal hs_i_1 : STD_LOGIC:='1';
	signal vs_i_1 : STD_LOGIC:='1';
	signal hs_i_2 : STD_LOGIC:='1';
	signal vs_i_2 : STD_LOGIC:='1';
	
	
	signal cmr_addr : STD_LOGIC_VECTOR(11 downto 0); --char_mem读地址
	signal cmw_addr : STD_LOGIC_VECTOR(11 downto 0); --char_mem写地址
	
	signal read_value : std_logic_vector(7 downto 0); --char_mem输出ascii码
	signal fr_addr_i : std_logic_vector(10 downto 0); --font_rom输入地址
	signal data_o : std_logic_vector(7 downto 0); --font_rom读出字符集的8个bit
	
	
begin
	


	vga_INSTANCE: vga PORT MAP(
			clk => clk_out,
			rst => rst,
			h_counter =>hc_i_0,
			v_counter =>vc_i_0,
			hs => hs_i_0,
			vs => vs_i_0
	);
	--0
	--获取读地址
	process(hc_i_0,vc_i_0)
		variable temp_hc : INTEGER RANGE 0 to 799;
		variable temp_vc : INTEGER RANGE 0 to 524;
		variable temp_addr : INTEGER RANGE 0 to 4500;
	begin
		temp_hc := conv_integer(hc_i_0);
		temp_hc := temp_hc/8;
		temp_vc := conv_integer(vc_i_0);
		temp_vc := temp_vc/16;
		temp_addr := temp_hc + temp_vc*128;
		cmr_addr <= conv_std_logic_vector(temp_addr,12);
	end process;
	--计算写的地址
	process(clk_out)
		variable temp_px : INTEGER RANGE 0 to 79 :=0 ;
		variable temp_py : INTEGER RANGE 0 to 29 :=5 ;
		variable temp_addr : INTEGER RANGE 0 to 4500 :=0 ;
		variable temp_flag : std_logic := '0' ;
	begin
		if (rising_edge(clk_out)) then
			if( char_we='1' ) then
				temp_addr := temp_px + temp_py*128;
				temp_flag := '1';
			else
				if(temp_flag = '1') then
					temp_flag := '0' ;
					if(char_value = "00001010") then
						temp_px := 0;
						if(temp_py=28) then
							temp_py:=5;
						else
							temp_py := temp_py + 1 ;
						end if;
					else
						if(temp_px=79) then
							temp_px:=0;
							if(temp_py=28) then
								temp_py:=5;
							else
								temp_py := temp_py + 1 ;
							end if;
						else
							temp_px := temp_px+1;
						end if;
					end if;
				end if;
			end if;
		end if;
			cmw_addr <= CONV_STD_LOGIC_VECTOR(temp_addr,12);
	end process;
	
	
	process(clk_out)
	begin
		if (rising_edge(clk_out)) then
			hc_i_2 <= hc_i_1;
			vc_i_2 <= vc_i_1;
			hs_i_2 <= hs_i_1;
			vs_i_2 <= vs_i_1;
			hc_i_1 <= hc_i_0;
			vc_i_1 <= vc_i_0;
			hs_i_1 <= hs_i_0;
			vs_i_1 <= vs_i_0;
		end if;
	end process;
	
	
	Char_mem_INSTANCE: Char_mem PORT MAP(
			clk => clk_out,
			char_read_addr => cmr_addr,
			char_write_addr => cmw_addr,
			char_we => char_we,
			char_write_value => char_value,
			char_read_value => read_value
	);
	--1
	
	process(read_value)
		variable temp_vc : INTEGER RANGE 0 to 524;
		variable t_vc: std_logic_vector(10 downto 0);
	begin
		temp_vc := conv_integer(vc_i_1);
		temp_vc := temp_vc MOD 16;
		t_vc(3 downto 0) := CONV_STD_LOGIC_VECTOR(temp_vc,4);
		t_vc(10 downto 4) := read_value(6 downto 0);
		fr_addr_i <= t_vc;
	end process;
	
	
	font_rom_INSTANCE: font_rom PORT MAP(
			clk => clk_out,
			addr => fr_addr_i,
			data => data_o
	);
	--2
	
	process(data_o,hs_i_2,vs_i_2,hc_i_2,vc_i_2)
		variable temp_hc : INTEGER RANGE 0 to 799;
		variable t_hc : INTEGER RANGE 0 to 7;
		variable temp_vc : INTEGER RANGE 0 to 524;
	begin
		--if(rising_edge(clk_out)) then
			temp_hc := conv_integer(hc_i_2);
			t_hc := temp_hc MOD 8;
			t_hc := 7-t_hc; 
			temp_vc := conv_integer(vc_i_2);
			if( temp_hc<640 and temp_vc<480) then
				if( data_o(t_hc) = '1') then
					r <= (OTHERS => '1');
					g <= (OTHERS => '1');
					b <= (OTHERS => '1');
				else
					r <= (OTHERS => '0');
					g <= (OTHERS => '0');
					b <= (OTHERS => '0');
				end if;
			else
				r <= (OTHERS => '0');
				g <= (OTHERS => '0');
				b <= (OTHERS => '0');
			end if;
			hs <= hs_i_2;
			vs <= vs_i_2;
		--end if;
		
	end process;
	
	
	
end Behavioral;

