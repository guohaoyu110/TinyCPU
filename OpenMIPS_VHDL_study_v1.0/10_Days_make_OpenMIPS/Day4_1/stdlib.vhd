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

  --iu��Regfile֮��Ľӿ��źţ����Regfile����������
	type iregfile_in_type is record
	  raddr1	: std_logic_vector(4 downto 0); -- read address 1
	  raddr2	: std_logic_vector(4 downto 0); -- read address 2
	  waddr	: std_logic_vector(4 downto 0); -- write address
	  wdata 	: std_logic_vector(31 downto 0); -- write data
	  ren1   : std_logic;			 -- read 1 enable
	  ren2   : std_logic;			 -- read 2 enable
	  wren   : std_logic;			 -- write enable
	end record;

  --iu��Regfile֮��Ľӿ��źţ����Regfile���������
	type iregfile_out_type is record
	  data1    	: std_logic_vector(31 downto 0); -- read data 1
	  data2    	: std_logic_vector(31 downto 0); -- read data 2
	end record;
	
  subtype pctype is std_logic_vector(31 downto 2);
  
  --ֻ��32���Ĵ��������ԼĴ�����ַֻ��5λ
  subtype rfatype is std_logic_vector(4 downto 0); 
 
  --ȡָ�׶εļĴ��� 
  type fetch_reg_type is record                     
    pc     : pctype;  --Ҫ��ȡ��ָ���ַ
  end record;
  
  --����׶εļĴ���
  type decode_reg_type is record                  
    pc     : pctype;  --��������׶ε�ָ���ַ
    inst   : word;    --��������׶ε�ָ��
  end record;
  
  --ִ�н׶εļĴ���
  type execute_reg_type is record                               
    rd    : rfatype;         --Ҫд���Ŀ�ļĴ���
    wreg  : std_logic;       --�Ƿ�Ҫд��Ŀ�ļĴ���
    rfe1       : std_logic;  --�Ƿ�Ҫ��ȡԴ�Ĵ���1
    rfe2       : std_logic;  --�Ƿ�Ҫ��ȡԴ�Ĵ���2
    rfa1       : rfatype;    --Ҫ��ȡ��Դ�Ĵ���1�ĵ�ַ
    rfa2       : rfatype;    --Ҫ��ȡ��Դ�Ĵ���2�ĵ�ַ
    reg1       : word;       --��ȡ����Դ�Ĵ���1��ֵ
    reg2       : word;       --��ȡ����Դ�Ĵ���2��ֵ
    imm        : word;       --ָ����Ҫ����������ֵ
    cnt    : std_logic_vector(1 downto 0);    --�Ƿ��Ƕ�����ָ�� 
    aluop  : std_logic_vector(7 downto 0);  	--ALU�Ĳ�������
    alusel : std_logic_vector(2 downto 0);  	--ALU��������ѡ���ź�
	  inst_valid : std_logic;  --ָ���Ƿ���Ч
  end record;
  
  --�ô�׶εļĴ���
  type memory_reg_type is record                                               
    waddr : rfatype;         --Ҫд���Ŀ�ļĴ���
    wreg  : std_logic;       --�Ƿ�Ҫд��Ŀ�ļĴ���
    result : word;           --Ҫд��Ŀ�ļĴ�����ֵ
  end record;

  --��д�׶εļĴ���
  type write_reg_type is record                                     
    result : word;           --Ҫд��Ŀ�ļĴ�����ֵ
    waddr  : rfatype;        --Ҫд��Ŀ�ļĴ���
    wreg   : std_logic;      --�Ƿ�Ҫд��Ŀ�ļĴ���
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
