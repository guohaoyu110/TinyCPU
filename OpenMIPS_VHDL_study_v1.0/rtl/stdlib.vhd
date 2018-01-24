----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2013 leishangwen@163.com                       ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE.  See the GNU Lesser General Public License for more ----
---- details.                                                     ----
----                                                              ----
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
-- Package: 	stdlib
-- File:	stdlib.vhd
-- Author:	Lei Silei
-- Description:	OpenMIPS library(type,funciton,etc)
----------------------------------------------------------------------

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

   constant EXE_SLT  : std_logic_vector(5 downto 0) := "101010";
   constant EXE_SLTU  : std_logic_vector(5 downto 0) := "101011";
   constant EXE_SLTI  : std_logic_vector(5 downto 0) := "001010";
   constant EXE_SLTIU  : std_logic_vector(5 downto 0) := "001011";   
   constant EXE_ADD  : std_logic_vector(5 downto 0) := "100000";
   constant EXE_ADDU  : std_logic_vector(5 downto 0) := "100001";
   constant EXE_SUB  : std_logic_vector(5 downto 0) := "100010";
   constant EXE_SUBU  : std_logic_vector(5 downto 0) := "100011";
   constant EXE_ADDI  : std_logic_vector(5 downto 0) := "001000";
   constant EXE_ADDIU  : std_logic_vector(5 downto 0) := "001001";
   constant EXE_CLZ  : std_logic_vector(5 downto 0) := "100000";
   constant EXE_CLO  : std_logic_vector(5 downto 0) := "100001";

   constant EXE_MULT  : std_logic_vector(5 downto 0) := "011000";
   constant EXE_MULTU  : std_logic_vector(5 downto 0) := "011001";
   constant EXE_MUL  : std_logic_vector(5 downto 0) := "000010";
   constant EXE_MADD  : std_logic_vector(5 downto 0) := "000000";
   constant EXE_MADDU  : std_logic_vector(5 downto 0) := "000001";
   constant EXE_MSUB  : std_logic_vector(5 downto 0) := "000100";
   constant EXE_MSUBU  : std_logic_vector(5 downto 0) := "000101";
   constant EXE_DIV  : std_logic_vector(5 downto 0) := "011010";
   constant EXE_DIVU  : std_logic_vector(5 downto 0) := "011011";

   constant EXE_MOVZ  : std_logic_vector(5 downto 0) := "001010";
   constant EXE_MOVN  : std_logic_vector(5 downto 0) := "001011";
   constant EXE_MFHI  : std_logic_vector(5 downto 0) := "010000";
   constant EXE_MTHI  : std_logic_vector(5 downto 0) := "010001";
   constant EXE_MFLO  : std_logic_vector(5 downto 0) := "010010";
   constant EXE_MTLO  : std_logic_vector(5 downto 0) := "010011";

   constant EXE_J  : std_logic_vector(5 downto 0) := "000010";
   constant EXE_JAL  : std_logic_vector(5 downto 0) := "000011";
   constant EXE_JALR  : std_logic_vector(5 downto 0) := "001001";
   constant EXE_JR  : std_logic_vector(5 downto 0) := "001000";
   constant EXE_BEQ  : std_logic_vector(5 downto 0) := "000100";
   constant EXE_BGEZ  : std_logic_vector(4 downto 0) := "00001";
   constant EXE_BGEZAL  : std_logic_vector(4 downto 0) := "10001";
   constant EXE_BGTZ  : std_logic_vector(5 downto 0) := "000111";
   constant EXE_BLEZ  : std_logic_vector(5 downto 0) := "000110";
   constant EXE_BLTZ  : std_logic_vector(4 downto 0) := "00000";
   constant EXE_BLTZAL  : std_logic_vector(4 downto 0) := "10000";
   constant EXE_BNE  : std_logic_vector(5 downto 0) := "000101";

   constant EXE_LB  : std_logic_vector(5 downto 0) := "100000";
   constant EXE_LBU  : std_logic_vector(5 downto 0) := "100100";
   constant EXE_LH  : std_logic_vector(5 downto 0) := "100001";
   constant EXE_LHU  : std_logic_vector(5 downto 0) := "100101";
   constant EXE_LL  : std_logic_vector(5 downto 0) := "110000";
   constant EXE_LW  : std_logic_vector(5 downto 0) := "100011";
   constant EXE_LWL  : std_logic_vector(5 downto 0) := "100010";
   constant EXE_LWR  : std_logic_vector(5 downto 0) := "100110";
   constant EXE_PREF  : std_logic_vector(5 downto 0) := "110011";
   constant EXE_SB  : std_logic_vector(5 downto 0) := "101000";
   constant EXE_SC  : std_logic_vector(5 downto 0) := "111000";
   constant EXE_SH  : std_logic_vector(5 downto 0) := "101001";
   constant EXE_SW  : std_logic_vector(5 downto 0) := "101011";
   constant EXE_SWL  : std_logic_vector(5 downto 0) := "101010";
   constant EXE_SWR  : std_logic_vector(5 downto 0) := "101110";
   constant EXE_SYNC  : std_logic_vector(5 downto 0) := "001111";

   constant EXE_SYSCALL : std_logic_vector(5 downto 0) := "001100";
   
   constant EXE_TEQ : std_logic_vector(5 downto 0) := "110100";
   constant EXE_TEQI : std_logic_vector(4 downto 0) := "01100";
   constant EXE_TGE : std_logic_vector(5 downto 0) := "110000";
   constant EXE_TGEI : std_logic_vector(4 downto 0) := "01000";
   constant EXE_TGEIU : std_logic_vector(4 downto 0) := "01001";
   constant EXE_TGEU : std_logic_vector(5 downto 0) := "110001";
   constant EXE_TLT : std_logic_vector(5 downto 0) := "110010";
   constant EXE_TLTI : std_logic_vector(4 downto 0) := "01010";
   constant EXE_TLTIU : std_logic_vector(4 downto 0) := "01011";
   constant EXE_TLTU : std_logic_vector(5 downto 0) := "110011";
   constant EXE_TNE : std_logic_vector(5 downto 0) := "110110";
   constant EXE_TNEI : std_logic_vector(4 downto 0) := "01110";
   
   constant EXE_ERET : std_logic_vector(31 downto 0) := "01000010000000000000000000011000";
   
   constant EXE_NOP    : std_logic_vector(5 downto 0) := "000000";
   
	constant EXE_RES_LOGIC : std_logic_vector(2 downto 0) := "001";
	constant EXE_RES_SHIFT : std_logic_vector(2 downto 0) := "010";
	constant EXE_RES_ARITHMETIC : std_logic_vector(2 downto 0) := "100";	
	constant EXE_RES_MUL : std_logic_vector(2 downto 0) := "101";
	constant EXE_RES_MOVE : std_logic_vector(2 downto 0) := "011";		
	constant EXE_RES_JUMP_BRANCH : std_logic_vector(2 downto 0) := "110";	
	constant EXE_RES_LOAD : std_logic_vector(2 downto 0) := "111";	
		
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

   constant EXE_SLT_OP  : std_logic_vector(7 downto 0) := "00101010";
   constant EXE_SLTU_OP  : std_logic_vector(7 downto 0) := "00101011";
   constant EXE_SLTI_OP  : std_logic_vector(7 downto 0) := "01010111";
   constant EXE_SLTIU_OP  : std_logic_vector(7 downto 0) := "01011000";   
   constant EXE_ADD_OP  : std_logic_vector(7 downto 0) := "00100000";
   constant EXE_ADDU_OP  : std_logic_vector(7 downto 0) := "00100001";
   constant EXE_SUB_OP  : std_logic_vector(7 downto 0) := "00100010";
   constant EXE_SUBU_OP  : std_logic_vector(7 downto 0) := "00100011";
   constant EXE_ADDI_OP  : std_logic_vector(7 downto 0) := "01010101";
   constant EXE_ADDIU_OP  : std_logic_vector(7 downto 0) := "01010110";
   constant EXE_CLZ_OP  : std_logic_vector(7 downto 0) := "10110000";
   constant EXE_CLO_OP  : std_logic_vector(7 downto 0) := "10110001";

   constant EXE_MULT_OP  : std_logic_vector(7 downto 0) := "00011000";
   constant EXE_MULTU_OP  : std_logic_vector(7 downto 0) := "00011001";
   constant EXE_MUL_OP  : std_logic_vector(7 downto 0) := "10101001";
   constant EXE_MADD_OP  : std_logic_vector(7 downto 0) := "10100110";
   constant EXE_MADDU_OP  : std_logic_vector(7 downto 0) := "10101000";
   constant EXE_MSUB_OP  : std_logic_vector(7 downto 0) := "10101010";
   constant EXE_MSUBU_OP  : std_logic_vector(7 downto 0) := "10101011";
   constant EXE_DIV_OP  : std_logic_vector(7 downto 0) := "00011010";
   constant EXE_DIVU_OP  : std_logic_vector(7 downto 0) := "00011011";

   constant EXE_MOVZ_OP  : std_logic_vector(7 downto 0) := "00001010";
   constant EXE_MOVN_OP  : std_logic_vector(7 downto 0) := "00001011";
   constant EXE_MFHI_OP  : std_logic_vector(7 downto 0) := "00010000";
   constant EXE_MTHI_OP  : std_logic_vector(7 downto 0) := "00010001";
   constant EXE_MFLO_OP  : std_logic_vector(7 downto 0) := "00010010";
   constant EXE_MTLO_OP  : std_logic_vector(7 downto 0) := "00010011";

   constant EXE_J_OP  : std_logic_vector(7 downto 0) := "01001111";
   constant EXE_JAL_OP  : std_logic_vector(7 downto 0) := "01010000";
   constant EXE_JALR_OP  : std_logic_vector(7 downto 0) := "00001001";
   constant EXE_JR_OP  : std_logic_vector(7 downto 0) := "00001000";
   constant EXE_BEQ_OP  : std_logic_vector(7 downto 0) := "01010001";
   constant EXE_BGEZ_OP  : std_logic_vector(7 downto 0) := "01000001";
   constant EXE_BGEZAL_OP  : std_logic_vector(7 downto 0) := "01001011";
   constant EXE_BGTZ_OP  : std_logic_vector(7 downto 0) := "01010100";
   constant EXE_BLEZ_OP  : std_logic_vector(7 downto 0) := "01010011";
   constant EXE_BLTZ_OP  : std_logic_vector(7 downto 0) := "01000000";
   constant EXE_BLTZAL_OP  : std_logic_vector(7 downto 0) := "01001010";
   constant EXE_BNE_OP  : std_logic_vector(7 downto 0) := "01010010";

   constant EXE_LB_OP  : std_logic_vector(7 downto 0) := "11100000";
   constant EXE_LBU_OP  : std_logic_vector(7 downto 0) := "11100100";
   constant EXE_LH_OP  : std_logic_vector(7 downto 0) := "11100001";
   constant EXE_LHU_OP  : std_logic_vector(7 downto 0) := "11100101";
   constant EXE_LL_OP  : std_logic_vector(7 downto 0) := "11110000";
   constant EXE_LW_OP  : std_logic_vector(7 downto 0) := "11100011";
   constant EXE_LWL_OP  : std_logic_vector(7 downto 0) := "11100010";
   constant EXE_LWR_OP  : std_logic_vector(7 downto 0) := "11100110";
   constant EXE_PREF_OP  : std_logic_vector(7 downto 0) := "11110011";
   constant EXE_SB_OP  : std_logic_vector(7 downto 0) := "11101000";
   constant EXE_SC_OP  : std_logic_vector(7 downto 0) := "11111000";
   constant EXE_SH_OP  : std_logic_vector(7 downto 0) := "11101001";
   constant EXE_SW_OP  : std_logic_vector(7 downto 0) := "11101011";
   constant EXE_SWL_OP  : std_logic_vector(7 downto 0) := "11101010";
   constant EXE_SWR_OP  : std_logic_vector(7 downto 0) := "11101110";
   constant EXE_SYNC_OP  : std_logic_vector(7 downto 0) := "00001111";
   constant EXE_SYSCALL_OP : std_logic_vector(7 downto 0) := "00001100";

   constant EXE_TEQ_OP : std_logic_vector(7 downto 0) := "00110100";
   constant EXE_TEQI_OP : std_logic_vector(7 downto 0) := "01001000";
   constant EXE_TGE_OP : std_logic_vector(7 downto 0) := "00110000";
   constant EXE_TGEI_OP : std_logic_vector(7 downto 0) := "01000100";
   constant EXE_TGEIU_OP : std_logic_vector(7 downto 0) := "01000101";
   constant EXE_TGEU_OP : std_logic_vector(7 downto 0) := "00110001";
   constant EXE_TLT_OP : std_logic_vector(7 downto 0) := "00110010";
   constant EXE_TLTI_OP : std_logic_vector(7 downto 0) := "01000110";
   constant EXE_TLTIU_OP : std_logic_vector(7 downto 0) := "01000111";
   constant EXE_TLTU_OP : std_logic_vector(7 downto 0) := "00110011";
   constant EXE_TNE_OP : std_logic_vector(7 downto 0) := "00110110";
   constant EXE_TNEI_OP : std_logic_vector(7 downto 0) := "01001001";
   
   constant EXE_ERET_OP : std_logic_vector(7 downto 0) := "01101011";
   constant EXE_MFC0_OP : std_logic_vector(7 downto 0) := "01011101";
   constant EXE_MTC0_OP : std_logic_vector(7 downto 0) := "01100000";
   
   constant EXE_NOP_OP    : std_logic_vector(7 downto 0) := "00000000";
	
	 constant EXCEPTION_TYPE_TRAP : std_logic_vector(7 downto 0) := "10000000";
	 
	 constant CP0_REG_COUNT    : std_logic_vector(4 downto 0) := "01001";        --�ɶ�д
	 constant CP0_REG_COMPARE    : std_logic_vector(4 downto 0) := "01011";      --�ɶ�д
	 constant CP0_REG_STATUS    : std_logic_vector(4 downto 0) := "01100";       --�ɶ�д
	 constant CP0_REG_CAUSE    : std_logic_vector(4 downto 0) := "01101";        --ֻ��
	 constant CP0_REG_EPC    : std_logic_vector(4 downto 0) := "01110";          --�ɶ�д
	 constant CP0_REG_PrId    : std_logic_vector(4 downto 0) := "01111";         --ֻ��
	 constant CP0_REG_CONFIG    : std_logic_vector(4 downto 0) := "10000";       --ֻ��
	 
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

   type status_reg_type is record          
    CU : std_logic_vector(3 downto 0);
    RP : std_logic;
    RE : std_logic;
    BEV : std_logic;
    TS : std_logic;
    SR : std_logic;
    NMI : std_logic;
    IM : std_logic_vector(7 downto 0);
    UM : std_logic;
    ERL : std_logic;
    EXL : std_logic;
    IE : std_logic;
  end record;
  
  type cause_reg_type is record            
    BD : std_logic;
    CE : std_logic_vector(1 downto 0);
    IV : std_logic;
    WP : std_logic;
    IP : std_logic_vector(7 downto 0);
    ExcCode : std_logic_vector(4 downto  0);
  end record;
  
  type config_reg_type is record           
    M : std_logic;
    ISP : std_logic;
    DSP : std_logic;
    MDU : std_logic;
    BE : std_logic;
    AT : std_logic_vector(1 downto 0);
    AR : std_logic_vector(2 downto 0);
    MT : std_logic_vector(2 downto 0);
  end record;
  
  type PrId_reg_type is record             
    CompanyID : std_logic_vector(7 downto 0);
    ProcessorID : std_logic_vector(7 downto 0);
    Revision : std_logic_vector(7 downto 0); 
  end record;
  
  subtype EPC_reg_type is std_logic_vector(31 downto 0);  
  subtype BadVAddr_reg_type is std_logic_vector(31 downto 0); 
  subtype ErrorEPC_reg_type is std_logic_vector(31 downto 0); 
  subtype count_reg_type is std_logic_vector(31 downto 0);    
  subtype compare_reg_type is std_logic_vector(31 downto 0);  
  
  type CP0_reg_type is record
     status : status_reg_type;     --CP0�е�status�Ĵ���
     cause : cause_reg_type;       --CP0�е�cause�Ĵ���
     config : config_reg_type;     --CP0�е�config�Ĵ���
     PrId : PrId_reg_type;         --CP0�е�PrId�Ĵ���
     EPC : EPC_reg_type;           --CP0�е�EPC�Ĵ���
     BadVAddr : BadVAddr_reg_type; --CP0�е�BadVAddr�Ĵ���
     ErrorEPC : ErrorEPC_reg_type; --CP0�е�ErrorEPC�Ĵ���
     count : count_reg_type;       --CP0�е�count�Ĵ���
     compare : compare_reg_type;   --CP0�е�compare�Ĵ���
  end record;
 
  --ȡָ�׶εļĴ��� 
  type fetch_reg_type is record                     
    pc     : pctype;  --Ҫ��ȡ��ָ���ַ
  end record;
  
  --����׶εļĴ���
  type decode_reg_type is record                  
    pc     : pctype;  --��������׶ε�ָ���ַ
    inst   : word;    --��������׶ε�ָ��
    annul  : std_logic;    
  end record;
  
  --ִ�н׶εļĴ���
  type execute_reg_type is record    
    pc    : pctype;          --����ִ�н׶ε�ָ���ַ
    inst  : word;            --����ִ�н׶ε�ָ�� 
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
    hilo : std_logic_vector(63 downto 0);  --�µ�hi��lo�Ĵ�����ֵ  	  
    dslot : std_logic;       --ָ���Ƿ���λ���ӳٲ���  
    annul  : std_logic;      
  end record;
  
  --�ô�׶εļĴ���
  type memory_reg_type is record                                               
    waddr : rfatype;         --Ҫд���Ŀ�ļĴ���
    wreg  : std_logic;       --�Ƿ�Ҫд��Ŀ�ļĴ���
    result : word;           --Ҫд��Ŀ�ļĴ�����ֵ
    whilo : std_logic;       --�Ƿ�Ҫдhi��lo�Ĵ���
    hilo : std_logic_vector(63 downto 0);  --Ҫд��hi��lo�Ĵ�����ֵ  
    we : std_logic;          --�����dmem��д�˿�
    sel : std_logic_vector(3 downto 0);    --dmem���ֽ�ѡ���ź�
    addr : word;             --Ҫ����д��dmem�ĵ�ַ
    wdata : word;            --Ҫд��dmem������
    load_op : std_logic_vector(1 downto 0);--���ز�������
    store_op : std_logic;    --�Ƿ��Ǵ洢����
    aluop : std_logic_vector(7 downto 0);  --ALU�Ĳ�������
    opdata1    : word;       --ALU�Ĳ�����1
    opdata2    : word;       --ALU�Ĳ�����2
    inst_valid : std_logic;  --ָ���Ƿ���Ч   
    CP0: CP0_reg_type;       --���µ�CP0�Ĵ�����ֵ  
    exception_type : std_logic_vector(7 downto 0);
    annul  : std_logic;
    dslot : std_logic;  
    pc    : pctype;                  
  end record;

  --��д�׶εļĴ���
  type write_reg_type is record                                     
    result : word;           --Ҫд��Ŀ�ļĴ�����ֵ
    waddr  : rfatype;        --Ҫд��Ŀ�ļĴ���
    wreg   : std_logic;      --�Ƿ�Ҫд��Ŀ�ļĴ���
    whilo  : std_logic;      --�Ƿ�Ҫдhi��lo�Ĵ���
    hilo   : std_logic_vector(63 downto 0);  --Ҫд��hi��lo�Ĵ�����ֵ
    LLbit : std_logic;	     --LL��SCָ���ʹ�õ�LLbit�����ԭ�Ӳ���
    sel : std_logic_vector(3 downto 0);      --dmem���ֽ�ѡ���ź�
    load_op : std_logic_vector(1 downto 0);  --���ز���������
    store_op : std_logic;                    --�Ƿ��Ǵ洢����
    aluop : std_logic_vector(7 downto 0);    --ALU�Ĳ�������
	  inst_valid : std_logic;                  --ָ���Ƿ���Ч
    CP0 : CP0_reg_type;      --CP0�Ĵ�����ֵ
    CP0_t : CP0_reg_type;	   --���µ�CP0�Ĵ�����ֵ����һ��ʱ�����ڻḳֵ��CP0
    opdata1    : word;
    opdata2    : word;     
    exception_type : std_logic_vector(7 downto 0);
    annul  : std_logic;
    dslot : std_logic;   
    pc    : pctype;             
  end record;
  
  type registers is record                                                        
    f  : fetch_reg_type;
    d  : decode_reg_type;
    e  : execute_reg_type;
    m  : memory_reg_type;
    w  : write_reg_type;
  end record;

  function conv_character_to_std_logic_vector(c : character) return std_logic_vector;
  function find_first_one(aluin1: word ) return std_logic_vector;
  function find_first_one(num: std_logic_vector(7 downto 0) ) return integer;  
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

  function find_first_one(aluin1: word ) return std_logic_vector is
    variable pos : integer;
  begin
    pos := 32;
    if(aluin1(31 downto 24) /= "00000000") then
       pos := 7 - find_first_one(aluin1(31 downto 24));
    elsif(aluin1(23 downto 16) /= "00000000") then
       pos := 15 - find_first_one(aluin1(23 downto 16));
    elsif(aluin1(15 downto 8) /= "00000000") then
       pos := 23 + find_first_one(aluin1(15 downto 8));
    elsif(aluin1(7 downto 0) /= "00000000") then
       pos := 31 - find_first_one(aluin1(7 downto 0));
    end if;
    return(conv_std_logic_vector(pos,32));
    
  end;
  
  function find_first_one(num: std_logic_vector(7 downto 0) ) return integer is
    variable pos : integer;
  begin
    if(num(7) = '1') then
      pos := 7;
    elsif (num(6) = '1') then
      pos := 6;
    elsif (num(5) = '1') then
      pos := 5;
    elsif (num(4) = '1') then
      pos := 4;
    elsif (num(3) = '1') then
      pos :=3;
    elsif (num(2) = '1') then
      pos :=2;
    elsif (num(1) = '1') then
      pos :=1;
    else
      pos :=0;
    end if;
    return pos;
  end;

end;