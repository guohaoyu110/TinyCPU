-----------------------------------------------------------------------------
-- Package: 	stdlib
-- File:	stdlib.vhd
-- Author:	Lei Silei
-- Description:	OpenMIPS library(type,funciton,etc)
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

package stdlib is

	constant IMEMSIZEINBYTE : integer := 4095;
	constant IMEMSIZEINWORD : integer := 1023;
	constant IMEMBIT  : integer := 10;
	constant DMEMSIZEINBYTE : integer := 4095;
	constant DMEMSIZEINWORD : integer := 1023;
	constant DMEMBIT  : integer := 10;
	constant MEMSIZEINWORD : integer := 524288;	
	constant PCLOW : integer := 2;
	constant zero32 : std_logic_vector(31 downto 0) := (others => '0');
	constant SSNOP : std_logic_vector(31 downto 0 ) := "00000000000000000000000001000000";
	
   constant EXE_AND   : std_logic_vector(5 downto 0) := "100100";
   constant EXE_OR    : std_logic_vector(5 downto 0) := "100101";
   constant EXE_XOR  : std_logic_vector(5 downto 0) := "100110";
   constant EXE_NOR  : std_logic_vector(5 downto 0) := "100111";
   constant EXE_ANDI  : std_logic_vector(5 downto 0) := "001100";
   constant EXE_ORI   : std_logic_vector(5 downto 0) := "001101";
   constant EXE_XORI  : std_logic_vector(5 downto 0) := "001110";
   constant EXE_LUI  : std_logic_vector(5 downto 0) := "001111";

   constant EXE_SLL  : std_logic_vector(5 downto 0) := "000000";
   constant EXE_SLLV  : std_logic_vector(5 downto 0) := "000100";
   constant EXE_SRL  : std_logic_vector(5 downto 0) := "000010";
   constant EXE_SRLV  : std_logic_vector(5 downto 0) := "000110";
   constant EXE_SRA  : std_logic_vector(5 downto 0) := "000011";
   constant EXE_SRAV  : std_logic_vector(5 downto 0) := "000111";
   
   constant EXE_NOP    : std_logic_vector(5 downto 0) := "000000";
   
	constant EXE_RES_LOGIC : std_logic_vector(2 downto 0) := "001";
	constant EXE_RES_SHIFT : std_logic_vector(2 downto 0) := "010";
		
	constant EXE_SPECIAL_INST : std_logic_vector(5 downto 0) := "000000";
	constant EXE_REGIMM_INST : std_logic_vector(5 downto 0) := "000001";
	constant EXE_SPECIAL2_INST : std_logic_vector(5 downto 0) := "011100";
--	constant EXE_COP0_INST : std_logic_vector(5 downto 0) := "010000";
	
	constant EXE_RES_NOP : std_logic_vector(2 downto 0) := "000";

	 constant EXE_AND_OP   : std_logic_vector(7 downto 0) := "00100100";
   constant EXE_OR_OP    : std_logic_vector(7 downto 0) := "00100101";
   constant EXE_XOR_OP  : std_logic_vector(7 downto 0) := "00100110";
   constant EXE_NOR_OP  : std_logic_vector(7 downto 0) := "00100111";
   constant EXE_ANDI_OP  : std_logic_vector(7 downto 0) := "01011001";
   constant EXE_ORI_OP  : std_logic_vector(7 downto 0) := "01011010";
   constant EXE_XORI_OP  : std_logic_vector(7 downto 0) := "01011011";
   constant EXE_LUI_OP  : std_logic_vector(7 downto 0) := "01011100";

   constant EXE_SLL_OP  : std_logic_vector(7 downto 0) := "01111100";
   constant EXE_SLLV_OP  : std_logic_vector(7 downto 0) := "00000100";
   constant EXE_SRL_OP  : std_logic_vector(7 downto 0) := "00000010";
   constant EXE_SRLV_OP  : std_logic_vector(7 downto 0) := "00000110";
   constant EXE_SRA_OP  : std_logic_vector(7 downto 0) := "00000011";
   constant EXE_SRAV_OP  : std_logic_vector(7 downto 0) := "00000111";
   
   constant EXE_NOP_OP    : std_logic_vector(7 downto 0) := "00000000";
	
	 constant EXCEPTION_TYPE_TRAP : std_logic_vector(7 downto 0) := "10000000";
	 
	 
	subtype word is std_logic_vector(31 downto 0);

  --iu与Regfile之间的接口信号，相对Regfile而言是输入
	type iregfile_in_type is record
	  raddr1	: std_logic_vector(4 downto 0); -- read address 1
	  raddr2	: std_logic_vector(4 downto 0); -- read address 2
	  waddr	: std_logic_vector(4 downto 0); -- write address
	  wdata 	: std_logic_vector(31 downto 0); -- write data
	  ren1   : std_logic;			 -- read 1 enable
	  ren2   : std_logic;			 -- read 2 enable
	  wren   : std_logic;			 -- write enable
	end record;

  --iu与Regfile之间的接口信号，相对Regfile而言是输出
	type iregfile_out_type is record
	  data1    	: std_logic_vector(31 downto 0); -- read data 1
	  data2    	: std_logic_vector(31 downto 0); -- read data 2
	end record;
	
  subtype pctype is std_logic_vector(31 downto 2);
  
  --只有32个寄存器，所以寄存器地址只有5位
  subtype rfatype is std_logic_vector(4 downto 0); 
 
  --取指阶段的寄存器 
  type fetch_reg_type is record                     
    pc     : pctype;  --要读取的指令地址
  end record;
  
  --译码阶段的寄存器
  type decode_reg_type is record                  
    pc     : pctype;  --处于译码阶段的指令地址
    inst   : word;    --处于译码阶段的指令
  end record;
  
  --执行阶段的寄存器
  type execute_reg_type is record                               
    rd    : rfatype;         --要写入的目的寄存器
    wreg  : std_logic;       --是否要写入目的寄存器
    rfe1       : std_logic;  --是否要读取源寄存器1
    rfe2       : std_logic;  --是否要读取源寄存器2
    rfa1       : rfatype;    --要读取的源寄存器1的地址
    rfa2       : rfatype;    --要读取的源寄存器2的地址
    reg1       : word;       --读取到的源寄存器1的值
    reg2       : word;       --读取到的源寄存器2的值
    imm        : word;       --指令需要的立即数的值
    cnt    : std_logic_vector(1 downto 0);    --是否是多周期指令 
    aluop  : std_logic_vector(7 downto 0);  	--ALU的操作类型
    alusel : std_logic_vector(2 downto 0);  	--ALU的运算结果选择信号
	  inst_valid : std_logic;  --指令是否有效
  end record;
  
  --访存阶段的寄存器
  type memory_reg_type is record                                               
    waddr : rfatype;         --要写入的目的寄存器
    wreg  : std_logic;       --是否要写入目的寄存器
    result : word;           --要写入目的寄存器的值
  end record;

  --回写阶段的寄存器
  type write_reg_type is record                                     
    result : word;           --要写入目的寄存器的值
    waddr  : rfatype;        --要写入目的寄存器
    wreg   : std_logic;      --是否要写入目的寄存器
  end record;
  
  type registers is record                                                        
    f  : fetch_reg_type;
    d  : decode_reg_type;
    e  : execute_reg_type;
    m  : memory_reg_type;
    w  : write_reg_type;
  end record;

  function conv_character_to_std_logic_vector(c : character) return std_logic_vector;
end;

package body stdlib is

	function conv_character_to_std_logic_vector(c : character) return std_logic_vector is
	begin
	  case c is
			when '0' => return "0000";
			when '1' => return "0001";
			when '2' => return "0010";
			when '3' => return "0011";
			when '4' => return "0100";
			when '5' => return "0101";
			when '6' => return "0110";
			when '7' => return "0111";
			when '8' => return "1000";
			when '9' => return "1001";
			when 'A' | 'a' => return "1010";
			when 'B' | 'b' => return "1011";
			when 'C' | 'c' => return "1100";
			when 'D' | 'd' => return "1101";
			when 'E' | 'e' => return "1110";
			when 'F' | 'f' => return "1111";
			when others => return "0000";
	   end case;   
   end;

end;
