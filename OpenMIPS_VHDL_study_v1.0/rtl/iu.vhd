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
-- Entity: 	iu
-- File:	iu.vhd
-- Author:	Lei Silei
-- Description:	OpenMIPS 5-stage integer pipline
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.stdlib.all;

entity iu is
  port (
    clk   : in  std_logic;
    rst  : in  std_logic;
    imem_addr : out word;
    imem_data : in  word;
    dmem_addr : out word;
    dmem_we : out std_logic;
    dmem_wdata : out word;
    dmem_rdata : in word;
    dmem_sel  : out std_logic_vector(3 downto 0);
    rf_o   : out iregfile_in_type;             
    rf_i   : in  iregfile_out_type;
    signed_div : out std_logic;
    start_div : out std_logic;
    annul_div : out std_logic;
    div_result : in std_logic_vector(63 downto 0);
    div_result_ready : in std_logic;
    div_opdata1,div_opdata2 : out word;
    int_i : in std_logic_vector(7 downto 0);    
	  SI_TimerInt : out std_logic        
    );
end;

architecture rtl of iu is

  signal r, rin : registers;
  signal HI,LO : word;
  signal int_r: std_logic_vector(7 downto 0);  
      
  procedure inst_decode(inst : word; 
    wreg : out std_logic; 
	  rdo : out std_logic_vector(4 downto 0);
	  aluop  : out std_logic_vector(7 downto 0);
	  alusel : out std_logic_vector(2 downto 0);
	  rfe1, rfe2 : out std_logic; rfa1, rfa2 : out rfatype;
    imm : out word; 
    new_cnt : out std_logic_vector(1 downto 0);
    inst_valid : out std_logic) is
	  variable op : std_logic_vector(5 downto 0);
	  variable op2 : std_logic_vector(4 downto 0);
	  variable op3 : std_logic_vector(5 downto 0);
	  variable op4 : std_logic_vector(4 downto 0);
	begin
	
		 op    := inst(31 downto 26);
		 op2   := inst(10 downto 6);
		 op3   := inst(5 downto 0);
		 op4   := inst(20 downto 16);
		 aluop := EXE_NOP_OP; 
		 alusel := EXE_RES_NOP;
		 wreg := '0'; 
		 rdo := inst(15 downto 11);
		 
		 rfe1 := '0'; rfe2 := '0';
		 rfa1 := inst(25 downto 21);
		 rfa2 := inst(20 downto 16);
		 imm := (others=>'0');
     new_cnt := "00";
     inst_valid := '0';
		 case op is
			when EXE_SPECIAL_INST =>
			  case op2 is
				 when "00000" =>
					case op3 is
					  when EXE_OR   => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_OR_OP;   alusel := EXE_RES_LOGIC; inst_valid := '1';
						when EXE_AND  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_AND_OP;  alusel := EXE_RES_LOGIC; inst_valid := '1';
						when EXE_XOR  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_XOR_OP;  alusel := EXE_RES_LOGIC; inst_valid := '1';
						when EXE_NOR  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_NOR_OP;  alusel := EXE_RES_LOGIC; inst_valid := '1';
						when EXE_SLLV => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SLL_OP;  alusel := EXE_RES_SHIFT; inst_valid := '1';
					  when EXE_SRLV => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SRL_OP;  alusel := EXE_RES_SHIFT; inst_valid := '1';
					  when EXE_SRAV => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SRA_OP;  alusel := EXE_RES_SHIFT; inst_valid := '1';
						when EXE_SLT  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SLT_OP;  alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
						when EXE_SLTU => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SLTU_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
						when EXE_ADD  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_ADD_OP;  alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
						when EXE_ADDU => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_ADDU_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
						when EXE_SUB  => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SUB_OP;  alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
						when EXE_SUBU => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_SUBU_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
					  when EXE_MULT => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MULT_OP;  inst_valid := '1';
					  when EXE_MULTU=> rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MULTU_OP;  inst_valid := '1';
					  when EXE_DIV  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_DIV_OP;  new_cnt :="01"; inst_valid := '1';
					  when EXE_DIVU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_DIVU_OP; new_cnt :="01"; inst_valid := '1';
						when EXE_MFHI => rfe1 := '0'; rfe2 := '0'; wreg :='1'; aluop := EXE_MFHI_OP; alusel := EXE_RES_MOVE; inst_valid := '1';
						when EXE_MTHI => rfe1 := '1'; rfe2 := '0'; wreg :='0'; aluop := EXE_MTHI_OP; inst_valid := '1';
		        when EXE_MFLO => rfe1 := '0'; rfe2 := '0'; wreg :='1'; aluop := EXE_MFLO_OP; alusel := EXE_RES_MOVE; inst_valid := '1';
		        when EXE_MTLO => rfe1 := '1'; rfe2 := '0'; wreg :='0'; aluop := EXE_MTLO_OP; inst_valid := '1';
						when EXE_MOVZ => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_MOVZ_OP; alusel := EXE_RES_MOVE; inst_valid := '1';
						when EXE_MOVN => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_MOVN_OP; alusel := EXE_RES_MOVE; inst_valid := '1';					  					  
					  when EXE_JALR => rfe1 := '1'; rfe2 := '0'; wreg :='1'; aluop := EXE_JALR_OP; alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
						when EXE_JR   => rfe1 := '1'; rfe2 := '0'; wreg :='0'; aluop := EXE_JR_OP; 	 alusel := EXE_RES_JUMP_BRANCH;	 inst_valid := '1';							
						when EXE_TEQ  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TEQ_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TGE  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TGE_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TGEU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TGEU_OP; alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TLT  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TLT_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TLTU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TLTU_OP; alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TNE  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TNE_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_SYSCALL =>   rfe1 := '0'; rfe2 := '0'; wreg :='0'; aluop := EXE_SYSCALl_OP;  inst_valid := '1';
						when EXE_SYNC => rfe1 := '0'; rfe2 := '0'; wreg :='0'; aluop := EXE_NOP_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when others =>
					end case;
				 when others =>
				  case op3 is 
				    when EXE_TEQ  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TEQ_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
				    when EXE_TGE  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TGE_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TGEU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TGEU_OP; alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TLT  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TLT_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TLTU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TLTU_OP; alusel := EXE_RES_NOP; inst_valid := '1';
						when EXE_TNE  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_TNE_OP;  alusel := EXE_RES_NOP;  inst_valid := '1';
						when EXE_SYSCALL =>   rfe1 := '0'; rfe2 := '0'; wreg :='0'; aluop := EXE_SYSCALl_OP; inst_valid := '1';
					  when others =>
					end case;
			  end case;
			when EXE_ORI  => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16); 
			                 aluop := EXE_OR_OP;  alusel := EXE_RES_LOGIC; inst_valid := '1';
			                 imm(15 downto 0) := inst(15 downto 0);
			                 
			when EXE_ANDI => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16); 
			                 aluop := EXE_AND_OP; alusel := EXE_RES_LOGIC; inst_valid := '1';
			                 imm(15 downto 0) := inst(15 downto 0);
			                 
			when EXE_XORI => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16); 
			                 aluop := EXE_XOR_OP; alusel := EXE_RES_LOGIC; inst_valid := '1';
			                 imm(15 downto 0) := inst(15 downto 0);
			                 
			when EXE_LUI =>  rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16); 
			                 aluop := EXE_OR_OP;  alusel := EXE_RES_LOGIC; inst_valid := '1';
		                   imm(31 downto 16) := inst(15 downto 0); imm(15 downto 0) := (others => '0');	
			when EXE_SLTI => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16); 
			                 aluop := EXE_SLT_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
			                 imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
			                 		 	     
		  when EXE_SLTIU => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16);
						            aluop := EXE_SLTU_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
		                    imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		                    	 	    
		  when EXE_ADDI => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16);
						           aluop := EXE_ADDI_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
		                   imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
			 	     
			when EXE_ADDIU => rfe1 := '1'; wreg :='1'; rdo := inst(20 downto 16);
						            aluop := EXE_ADDIU_OP; alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
		                    imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		                    
		  when EXE_J    => rfe1 := '0';rfe2 := '0'; wreg :='0'; aluop := EXE_J_OP;    alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		  when EXE_JAL  => rfe1 := '0';rfe2 := '0'; wreg :='1'; aluop := EXE_JAL_OP;  alusel := EXE_RES_JUMP_BRANCH; rdo := "11111"; inst_valid := '1';
		  when EXE_BEQ  => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_BEQ_OP;  alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		  when EXE_BGTZ => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_BGTZ_OP; alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		  when EXE_BLEZ => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_BLEZ_OP; alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		  when EXE_BNE  => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_BNE_OP;  alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		  when EXE_LB   => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LB_OP;   alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
		  when EXE_LBU  => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LBU_OP;  alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
		  when EXE_LH   => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LH_OP;   alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
			when EXE_LHU  => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LHU_OP;  alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
  	  when EXE_LW   => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LW_OP;   alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
  	  when EXE_LL   => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_LL_OP;   alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
  	  when EXE_LWL  => rfe1 := '1';rfe2 := '1'; wreg :='1'; aluop := EXE_LWL_OP;  alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
  	  when EXE_LWR  => rfe1 := '1';rfe2 := '1'; wreg :='1'; aluop := EXE_LWR_OP;  alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1';
		  when EXE_SB   => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_SB_OP;    inst_valid := '1';
		  when EXE_SH   => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_SH_OP;    inst_valid := '1';
		  when EXE_SW   => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_SW_OP;    inst_valid := '1';
		  when EXE_SWL  => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_SWL_OP;   inst_valid := '1';
		  when EXE_SWR  => rfe1 := '1';rfe2 := '1'; wreg :='0'; aluop := EXE_SWR_OP;   inst_valid := '1';
		  when EXE_SC   => rfe1 := '1';rfe2 := '1'; wreg :='1'; aluop := EXE_SC_OP;   alusel := EXE_RES_LOAD; rdo := inst(20 downto 16); inst_valid := '1'; 		  

		  when EXE_REGIMM_INST =>
		      case op4 is
		        when EXE_BGEZ   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_BGEZ_OP;   alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		        when EXE_BGEZAL => rfe1 := '1';rfe2 := '0'; wreg :='1'; aluop := EXE_BGEZAL_OP; alusel := EXE_RES_JUMP_BRANCH; rdo := "11111"; inst_valid := '1';
		        when EXE_BLTZ   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_BLTZ_OP;   alusel := EXE_RES_JUMP_BRANCH; inst_valid := '1';
		        when EXE_BLTZAL => rfe1 := '1';rfe2 := '0'; wreg :='1';	aluop := EXE_BLTZAL_OP; alusel := EXE_RES_JUMP_BRANCH; rdo := "11111"; inst_valid := '1';
		        when EXE_TEQI   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TEQI_OP;   alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		        when EXE_TGEI   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TGEI_OP;   alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		        when EXE_TGEIU  => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TGEIU_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		        when EXE_TLTI   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TLTI_OP;   alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		        when EXE_TLTIU  => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TLTIU_OP;  alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));
		        when EXE_TNEI   => rfe1 := '1';rfe2 := '0'; wreg :='0'; aluop := EXE_TNEI_OP;   alusel := EXE_RES_NOP; inst_valid := '1';
		                           imm(15 downto 0) := inst(15 downto 0); imm(31 downto 16) := (others => inst(15));		        
   				  when others =>
					end case;
		  		                    
			when EXE_SPECIAL2_INST =>
			    case op3 is 
			      when EXE_CLZ   => rfe1 := '1'; rfe2 := '0'; wreg :='1'; aluop := EXE_CLZ_OP;   alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
					  when EXE_CLO   => rfe1 := '1'; rfe2 := '0'; wreg :='1'; aluop := EXE_CLO_OP;   alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
            when EXE_MUL   => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_MUL_OP;   alusel := EXE_RES_MUL; inst_valid := '1';
					  when EXE_MADD  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MADD_OP;  alusel := EXE_RES_MUL; new_cnt := "01"; inst_valid := '1';
					  when EXE_MADDU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MADDU_OP; alusel := EXE_RES_MUL; new_cnt := "01"; inst_valid := '1';
					  when EXE_MSUB  => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MSUB_OP;  alusel := EXE_RES_MUL; new_cnt := "01"; inst_valid := '1';
					  when EXE_MSUBU => rfe1 := '1'; rfe2 := '1'; wreg :='0'; aluop := EXE_MSUBU_OP; alusel := EXE_RES_MUL; new_cnt := "01"; inst_valid := '1';            
					  when others =>
					 end case;				                    		                   
			when others =>
		 end case;
		 
     if(inst(31 downto 21) = "00000000000" ) then
       if(inst(5 downto 0) = EXE_SLL ) then
       	imm(4 downto 0) := inst(10 downto 6);
			 	rfe2 := '1'; 
			  wreg :='1';
				rdo := inst(15 downto 11);
				aluop := EXE_SLL_OP; 
				alusel := EXE_RES_SHIFT;
				 inst_valid := '1';
			 elsif (inst(5 downto 0) = EXE_SRL ) then
       	imm(4 downto 0) := inst(10 downto 6);
			 	rfe2 := '1'; 
			  wreg :='1';
				rdo := inst(15 downto 11);
				aluop := EXE_SRL_OP; 
				alusel := EXE_RES_SHIFT;
				 inst_valid := '1';
			 elsif (inst(5 downto 0) = EXE_SRA ) then
       	imm(4 downto 0) := inst(10 downto 6);
			 	rfe2 := '1'; 
			  wreg :='1';
				rdo := inst(15 downto 11);
				aluop := EXE_SRA_OP; 
				alusel := EXE_RES_SHIFT;
				 inst_valid := '1';
			end if;
		 end if;		 

		 if(inst = zero32 or inst = SSNOP) then
		   rfe1 := '0'; rfe2 := '0'; 
		   wreg :='0';
		   aluop := EXE_NOP_OP; 
			 alusel := EXE_RES_NOP;
			 inst_valid := '1';
		 elsif(inst = EXE_ERET) then
			   rfe1 := '0'; rfe2 := '0';
				 wreg :='0';
				 aluop := EXE_ERET_OP; 
				 alusel := EXE_RES_NOP;
				  inst_valid := '1';			 
		 elsif(inst(31 downto 21)="01000000000" and inst(10 downto 0) = "00000000000") then
 			 	 rfe1 := '0';rfe2 := '0';
 			 	 imm(4 downto 0) := inst(15 downto 11);
			   wreg := '1';
				 rdo := inst(20 downto 16);
				 aluop := EXE_MFC0_OP; 
				 alusel := EXE_RES_MOVE;
				  inst_valid := '1';
		  elsif(inst(31 downto 21) = "01000000100" and inst(10 downto 0) = "00000000000") then
			   rfe1 := '1';
			   rfa1 := inst(20 downto 16);
 			 	 imm(4 downto 0) := inst(15 downto 11);
			   wreg := '0';
				 aluop := EXE_MTC0_OP; 
				 alusel := EXE_RES_NOP;
				 inst_valid := '1';			 
		  end if;    
		 
  end;

  procedure logic_op(r : registers; aluin1, aluin2: word; 
    logicres : out word) is
	  variable logicout : word;
	begin
	    logicout := (others => '0');
		 case r.e.aluop is
			when EXE_OR_OP  => logicout := aluin1 or aluin2;
			when EXE_AND_OP => logicout := aluin1 and aluin2;
			when EXE_NOR_OP => logicout := aluin1 nor aluin2;
			when EXE_XOR_OP => logicout := aluin1 xor aluin2;
			when others => logicout := (others => '-');
		 end case;
		 logicres := logicout;
  end;

  procedure opdata_select(r,v: registers; 
                          exception_mem_annul, exception_wb_annul: std_logic;
                          opdata1 : out word; opdata2: out word; ex_stall : out std_logic) is
  variable ex_stall1, ex_stall2 : std_logic;                   
	begin  
		 ex_stall1 := '0';
	   ex_stall2 := '0';
	 
	   if r.e.rfe1='0' then
	     opdata1 := r.e.imm;                            --源操作数是立即数
     elsif (r.m.waddr = r.e.rfa1 and r.m.wreg = '1' and r.e.rfe1 = '1' and exception_mem_annul = '0' and (r.m.load_op="00")) then  
       opdata1 := r.m.result;                     --与上一条指令存在数据相关，上一条指令不是加载指令
     elsif (r.m.waddr = r.e.rfa1 and r.m.wreg = '1' and r.e.rfe1 = '1' and exception_mem_annul = '0' and (r.m.load_op/="00")) then  
       ex_stall1 := '1';                          --与上一条指令存在数据相关，上一条指令是加载指令
       opdata1 := zero32;	     
     elsif (r.w.waddr = r.e.rfa1 and r.w.wreg = '1' and r.e.rfe1 = '1' and exception_wb_annul = '0') then
       opdata1 := r.w.result;                     --与上上一条指令存在数据相关
     else     
       opdata1 := r.e.reg1;                     --不存在数据相关
     end if;
     
     if r.e.rfe2='0' then
	     opdata2 := r.e.imm;                            --源操作数是立即数
     elsif (r.m.waddr = r.e.rfa2 and r.m.wreg = '1' and r.e.rfe2 = '1' and exception_mem_annul = '0' and (r.m.load_op="00")) then  
       opdata2 := r.m.result;                     --与上一条指令存在数据相关，上一条指令不是加载指令
     elsif (r.m.waddr = r.e.rfa2 and r.m.wreg = '1' and r.e.rfe2 = '1' and exception_mem_annul = '0' and (r.m.load_op/="00")) then  
       ex_stall2 := '1';   
       opdata2 := zero32;                       --与上一条指令存在数据相关，上一条指令是加载指令
     elsif (r.w.waddr = r.e.rfa2 and r.w.wreg = '1' and r.e.rfe2 = '1' and exception_wb_annul = '0') then
       opdata2 := r.w.result;                     --与上上一条指令存在数据相关
     else     
       opdata2 := r.e.reg2;                     --不存在数据相关
     end if;

     if(ex_stall1 = '1' or ex_stall2 = '1') then --与上一条加载指令存在数据相关，那么设置ex_stall为1
       ex_stall := '1';
     else
       ex_stall := '0';
     end if;
     
  end;

  procedure shift_op(r : registers; aluin1, aluin2: word; 
    shiftres : out word) is
	  variable shiftout,zero,extend_sign : word;
--	  variable shiftnum :integer;
	begin
	    shiftout := aluin2;
--	    shiftnum := conv_integer(aluin1(4 downto 0));
	    zero := (others => '0');
	    extend_sign := (others => aluin2(31));
	    if(aluin1(4) = '1') then 
		    case r.e.aluop is
			   when EXE_SLL_OP => shiftout := shiftout(15 downto 0) & zero(15 downto 0);
			   when EXE_SRA_OP => shiftout := extend_sign(15 downto 0) & shiftout(31 downto 16);
			   when EXE_SRL_OP => shiftout := zero(15 downto 0) & shiftout(31 downto 16);
			   when others  => shiftout := shiftout;
		    end case;
		  end if;
		 
		 if(aluin1(3) = '1') then 
		    case r.e.aluop is
			   when EXE_SLL_OP => shiftout := shiftout(23 downto 0) & zero(7 downto 0);
			   when EXE_SRA_OP => shiftout := extend_sign(7 downto 0) & shiftout(31 downto 8);
			   when EXE_SRL_OP => shiftout := zero(7 downto 0) & shiftout(31 downto 8);
			   when others  => shiftout := shiftout;
		    end case;
		  end if;
		  
		 if(aluin1(2) = '1') then 
		    case r.e.aluop is
			   when EXE_SLL_OP => shiftout := shiftout(27 downto 0) & zero(3 downto 0);
			   when EXE_SRA_OP => shiftout := extend_sign(3 downto 0) & shiftout(31 downto 4);
			   when EXE_SRL_OP => shiftout := zero(3 downto 0) & shiftout(31 downto 4);
			   when others  => shiftout := shiftout;
		    end case;
		  end if;
		  
		 if(aluin1(1) = '1') then 
		    case r.e.aluop is
			   when EXE_SLL_OP => shiftout := shiftout(29 downto 0) & zero(1 downto 0);
			   when EXE_SRA_OP => shiftout := extend_sign(1 downto 0) & shiftout(31 downto 2);
			   when EXE_SRL_OP => shiftout := zero(1 downto 0) & shiftout(31 downto 2);
			   when others  => shiftout := shiftout;
		    end case;
		  end if;
		  
		 if(aluin1(0) = '1') then 
		    case r.e.aluop is
			   when EXE_SLL_OP => shiftout := shiftout(30 downto 0) & zero(0);
			   when EXE_SRA_OP => shiftout := extend_sign(0) & shiftout(31 downto 1);
			   when EXE_SRL_OP => shiftout := zero(0) & shiftout(31 downto 1);
			   when others  => shiftout := shiftout;
		    end case;
		  end if;
		 shiftres := shiftout;
  end;

  procedure arithmetic_op(r : registers; aluin1, aluin2: word; 
    arithmeticres : out word; overflow : out boolean) is
	  variable aluin2_mux,result : word;
	  variable comp : std_logic;
	  variable comp_a,comp_b,compareres : word;
	  variable countres : word;
	begin
	    overflow := false;   
	    countres := (others => '0');
   
      --如果是指令clz，那么调用函数find_first_one计算操作数aluin1从高位
      --开始的第一个1之前的0的个数，反之将aluin1取反，在调用函数find_first_one
      --实际效果是计算操作数aluin1从高位开始的第一个0之前的1的个数
	    if r.e.aluop = EXE_CLZ_OP then
	       countres := find_first_one(aluin1 );
	    else 
	       countres := find_first_one(not aluin1);
	    end if;
	    
	    --如果是符号数比较，那么设置comp为1，反之，设置comp为0
	    if r.e.aluop = EXE_SLT_OP then 
	      comp := '1';              --是有符号数比较
	    else 
	      comp := '0';              --是无符号数比较
	    end if;
	    
	    --以下进行比较运算
	    comp_a := (aluin1(31) xor comp) & aluin1(30 downto 0);
	    comp_b := (aluin2(31) xor comp) & aluin2(30 downto 0);
	    
	    if comp_a < comp_b then 
	      compareres := (others => '0');
	      compareres(0) := '1';
	    else 
	      compareres := (others => '0');
	    end if;
	      
	      --如果是减法，那么将操作数aluin2取反加1，将减法转化为加法  
	      if(r.e.aluop = EXE_SUB_OP or r.e.aluop = EXE_SUBU_OP) then
	        aluin2_mux := (not aluin2) + 1;
	      else 
	        aluin2_mux := aluin2;
	      end if;
	      
	      --result是减法、加法运算结果	        	        
	      result := aluin1 + aluin2_mux;
	      
	      --依据具体的算术指令，选择上面几个运算结果中的一个，作为最终算术运算结果
		    case r.e.aluop is
			   when EXE_ADD_OP | EXE_ADDI_OP =>   --add、addi指令要考虑溢出的情况 			        
			        if( (aluin1(31)='1' and aluin2_mux(31)='1' and result(31)='0')
			         or (aluin1(31)='0' and aluin2_mux(31)='0' and result(31)='1')) then
			            overflow := true;
			        end if;
			   when EXE_SUB_OP =>            --sub指令要考虑溢出的情况
			        if( aluin1(31)='0' and aluin2_mux(31)='1' and result(31)='1' ) then
			           overflow := true;
			        end if;
			   when EXE_SLT_OP | EXE_SLTU_OP => result := compareres;  --比较指令的结果是compareres
			   when EXE_CLZ_OP | EXE_CLO_OP => result := countres;		 --clo、clz指令的结果是countres          
			   when others  => null;
		    end case;
		  
		  --算术运算的最终结果存放在arithmeticres中  
		  arithmeticres := result;
		  
  end;

  procedure mul_op(r : registers; aluin1, aluin2: word; 
    mulres : out std_logic_vector(63 downto 0)) is
	  variable mulout : std_logic_vector(63 downto 0);
	  variable opdata1, opdata2 : word;
	begin
	    mulout := (others => '0');
	    if((r.e.aluop = EXE_MUL_OP or r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MADD_OP or r.e.aluop = EXE_MSUB_OP )
	        and aluin1(31) = '1') then
	       opdata1 := (not aluin1) + 1;    --将有符号数转化为无符号数进行运算
	    else 
	       opdata1 := aluin1;
	    end if;
	     
	    if((r.e.aluop = EXE_MUL_OP or r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MADD_OP or r.e.aluop = EXE_MSUB_OP )
	        and aluin2(31) = '1') then
	       opdata2 := (not aluin2) + 1;    --将有符号数转化为无符号数进行运算
	    else 
	       opdata2 := aluin2;
      end if;
       
      mulout := opdata1 * opdata2;
          
		 case r.e.aluop is
			when EXE_MUL_OP | EXE_MULT_OP | EXE_MADD_OP | EXE_MSUB_OP => 
			     if((aluin1(31) xor aluin2(31)) = '1') then  --有符号乘法，且积为负
			       mulout := (not mulout) + 1;
			     end if;
			when others => 
		 end case;
		 mulres := mulout;
  end;

  procedure move_op(r : registers; new_CP0 : CP0_reg_type; 
                    aluin1, aluin2: word; 
                    newhilo : std_logic_vector(63 downto 0);
                    moveres : out word; notmove : out boolean) is
	  variable moveout,zeros : word;
	begin
	    moveout := (others => '0');
	    zeros := (others => '0');
	    notmove := false;
		 case r.e.aluop is
			when EXE_MFHI_OP  => moveout := newhilo(63 downto 32);
			when EXE_MFLO_OP => moveout := newhilo(31 downto 0);
			when EXE_MOVN_OP =>   
			      if aluin2 /= zeros then
			         moveout := aluin1;  --movn指令是条件寄存器不等于0的时候修改寄存器的值
			      else 
			         notmove := true;
			      end if;
			when EXE_MOVZ_OP => 
					  if aluin2 = zeros then
			         moveout := aluin1;  --movz指令是条件寄存器等于0的时候修改寄存器的值
			      else 
			         notmove := true;
			      end if;
			when EXE_MFC0_OP =>
			      if(aluin2(31 downto 5) = "000000000000000000000000000") then
			      case aluin2(4 downto 0) is 
			        when CP0_REG_COUNT => moveout := new_CP0.count;
			        when CP0_REG_COMPARE => moveout := new_CP0.compare;
			        when CP0_REG_EPC => moveout := new_CP0.EPC;
			        when CP0_REG_STATUS => 
			                 moveout := new_CP0.status.CU & new_CP0.status.RP & '0' & new_CP0.status.RE & 
			                            "00" & new_CP0.status.BEV & new_CP0.status.TS & new_CP0.status.SR &
			                            new_CP0.status.NMI & "000" & new_CP0.status.IM & "000" & new_CP0.status.UM &
			                            '0' & new_CP0.status.ERL & new_CP0.status.EXL & new_CP0.status.IE;
			        when CP0_REG_CAUSE => 
			                 moveout := new_CP0.cause.BD & '0' & new_CP0.cause.CE & "0000" & new_CP0.cause.IV & 
			                            new_CP0.cause.WP & "000000" & new_CP0.cause.IP & '0' & new_CP0.cause.ExcCode & "00";
			        when CP0_REG_PrId =>
			                 moveout := "00000000" & new_CP0.PrId.CompanyID & new_CP0.PrId.ProcessorID & new_CP0.PrId.Revision;
			        when CP0_REG_CONFIG =>
			                 moveout := new_CP0.config.M & "000000" & new_CP0.config.ISP & new_CP0.config.DSP & "00" & 
			                            new_CP0.config.MDU & "0000" & new_CP0.config.BE & new_CP0.config.AT & 
			                            new_CP0.config.AR & new_CP0.config.MT & "0000000";
			        when others => 
			                 moveout := (others => '0');
			      end case;
			      else
			        moveout := (others => '0');
			      end if;			      
			when others => moveout := (others => '-');
		 end case;
		 moveres := moveout;
  end;

  procedure alu_select(r : registers; logicout, shiftout, arithmeticres, moveres: word; mulres: std_logic_vector(63 downto 0);
                       jump_branch_res: word; res: out word) is
	  variable aluresult : word;
	begin

	    aluresult := (others => '0');
		 case r.e.alusel is
			when EXE_RES_LOGIC => aluresult := logicout;
			when EXE_RES_SHIFT => aluresult := shiftout;
			when EXE_RES_ARITHMETIC => aluresult := arithmeticres;
			when EXE_RES_MUL => aluresult := mulres(31 downto 0);	
			when EXE_RES_MOVE => aluresult := moveres;		
			when EXE_RES_JUMP_BRANCH => aluresult := jump_branch_res;									
			when others => aluresult := zero32;
		 end case;
		 res := aluresult;
  end;

  --得到最新的HI、LO寄存器的值
  function get_new_hilo(r,v: registers; hi,lo: word) return std_logic_vector is
  begin
     if(r.m.whilo = '1' and r.m.annul = '0') then
       return r.m.hilo;
     elsif(r.w.whilo = '1' and r.w.annul = '0') then
       return r.w.hilo;
     else
       return hi & lo;
     end if;
  end;

  --依据指令，设置HI、LO寄存器的值
  procedure set_new_hilo(r, v: registers; annul, ex_stall_for_new_RF : std_logic; 
               aluin1, aluin2: word; 
               mul_res: in std_logic_vector(63 downto 0);
               new_hilo : in std_logic_vector(63 downto 0); 
               hilo_temp: out std_logic_vector(63 downto 0);
               hilo: out std_logic_vector(63 downto 0); whilo: out std_logic; 
               new_cnt : out std_logic_vector(1 downto 0);
               start_div, signed_div, annul_div: out std_logic ) is
     variable temp : std_logic_vector(63 downto 0);
  begin
    hilo := new_hilo;
    whilo := '0';
    new_cnt := r.e.cnt;       
    hilo_temp := new_hilo;    --目前最新的HI、LO寄存器的值
    start_div := '0';
    annul_div := '0';
    signed_div := '0';
    
    if(annul = '0' and ex_stall_for_new_RF = '0') then
    --mult\multu指令将乘法结果存放在HI、LO寄存器，所以设置whilo为1，hilo为乘法结果
    if((r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MULTU_OP)) then
      hilo := mul_res;
      whilo := '1';
    elsif(r.e.aluop = EXE_MADD_OP or r.e.aluop = EXE_MADDU_OP) then
      if( r.e.cnt = "01" ) then      --MADD、MADDU是多周期指令，cnt为1表示是第一个周期
                                     --此时执行乘法
        hilo_temp := mul_res;
        new_cnt := "00";             --设置new_cnt为00，表示下一个时钟周期是多周期指令的
                                     --执行阶段最后一个时钟周期
      else
        hilo := new_hilo + r.e.hilo;  --cnt为00，表示是第二个周期，此时执行加法
                                      --r.e.hilo中存储的上一个周期计算出来的乘法结果
        whilo := '1';                 --第二个周期MADD、MADDU指令会修改HI、LO的值
      end if;
    elsif(r.e.aluop = EXE_MSUB_OP or r.e.aluop = EXE_MSUBU_OP) then
      temp := (not r.e.hilo) +1;     --求补码，将减法转化为加法，r.e.hilo是上一个周期
                                     --计算出来的乘法结果
      if( r.e.cnt = "01" ) then      --MSUB、MSUBU是多周期指令，cnt为1表示是第一个周期
                                     --此时执行乘法
        new_cnt := "00";
        hilo_temp := mul_res;        --设置new_cnt为00，表示下一个时钟周期是多周期指令的
                                     --执行阶段最后一个时钟周期
      else
        hilo := new_hilo + temp;     --cnt为00，表示是第二个周期，此时执行减法
        whilo := '1';                --第二个周期MSUB、MSUBU指令会修改HI、LO的值
      end if;
    elsif(r.e.aluop = EXE_MTHI_OP) then   --是mthi指令，需要写HI寄存器
        hilo(63 downto 32) := aluin1;
        hilo(31 downto 0) := new_hilo(31 downto 0); --LO寄存器保持不变
        whilo := '1';
    elsif (r.e.aluop = EXE_MTLO_OP) then  --是mtlo指令，需要些LO寄存器
        hilo(31 downto 0) := aluin1;
        hilo(63 downto 32) := new_hilo(63 downto 32); --HI寄存器保持不变
        whilo := '1';            
    elsif( r.e.aluop = EXE_DIV_OP ) then  --除法也是多周期指令
        if(div_result_ready = '1') then    --当输入div_result_ready为1时，表示除法结束
           new_cnt := "00";                --设置new_cnt为00，表示下一个时钟周期是多周期指令的
                                           --执行阶段最后一个时钟周期
           hilo := div_result;             --将除法结果写入HI、LO寄存器
           whilo := '1';
           start_div := '0';               --通知除法模块进入free状态
        else
          new_cnt := "01"; 
          whilo := '0';
          start_div := '1';                --通知除法模块开始除法运算
          signed_div := '1';               --div指令进行的是有符号除法
        end if;
     elsif( r.e.aluop = EXE_DIVU_OP ) then
        if( div_result_ready = '1') then
           new_cnt := "00";
           hilo := div_result;
           whilo := '1';
           start_div := '0';
        else
          new_cnt := "01"; 
          whilo := '0';
          start_div := '1';  
          signed_div := '0';                --divu指令进行的是无符号除法 
        end if;
     else
      hilo := new_hilo;
      whilo := '0';
    end if;       
    elsif(annul = '1') then
      annul_div := '1';
      start_div := '0';
      new_cnt := "00";
      hilo := r.e.hilo;
      whilo := '0';
    end if;                     
  end;

  procedure jump_branch_op(r: registers; exception_ex_annul: std_logic;
                           aluin1, aluin2: word; jump_branch_res, jump_target: out word;
                           jump_branch_true: out std_logic; next_is_dslot: out std_logic) is 
    variable temp:pctype;
    variable is_zero, less_than_zero: std_logic;
    variable sign_ext : std_logic_vector(13 downto 0);
    variable jump_branch_address: word;    
  begin
    temp := r.e.pc + 2;
    jump_branch_res := (others => '0');
    jump_target := (others => '0');
    sign_ext := (others => r.e.inst(15));
    jump_branch_address := (r.d.pc & "00") + (sign_ext & r.e.inst(15 downto 0) & "00");
    jump_branch_true := '0';
    next_is_dslot := '0';
    if(aluin1 = zero32) then
      is_zero := '1';
    else
      is_zero := '0';
    end if;
    
    if(aluin1(31) = '1') then             --依据源操作数的最高位判断是否小于0
       less_than_zero := '1';
    else 
       less_than_zero := '0';
    end if;
    
    if(r.e.aluop = EXE_JAL_OP or r.e.aluop = EXE_JALR_OP or r.e.aluop = EXE_BGEZAL_OP or r.e.aluop = EXE_BLTZAL_OP) then
      jump_branch_res := temp & "00";
    end if;
    
    case r.e.aluop is
      when EXE_JALR_OP | EXE_JR_OP =>
            jump_target := aluin1;         --不同的转移指令，计算转移目标地址的方法不同
            jump_branch_true := '1';
            next_is_dslot := '1';          --设置下一条指令在延迟槽中
      when EXE_J_OP | EXE_JAL_OP =>
            jump_target := temp(31 downto 28) & r.e.inst(25 downto 0) & "00";
            jump_branch_true := '1';
            next_is_dslot := '1'; 
      when EXE_BEQ_OP =>
            if(aluin1 = aluin2) then       --源操作数相等的时候转移
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';               
            end if;
      when EXE_BGEZ_OP | EXE_BGEZAL_OP =>
            if(less_than_zero = '0') then  --源操作数大于等于0的时候转移
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';
            end if;           
      when EXE_BGTZ_OP =>                  --源操作数大于0的时候转移
            if(less_than_zero = '0' and is_zero = '0') then
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';
            end if;                 
      when EXE_BLEZ_OP =>                  --源操作数小于等于0的时候转移
            if(less_than_zero = '1' and is_zero = '1') then
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';
            end if;                 
      when EXE_BLTZ_OP | EXE_BLTZAL_OP =>  --源操作数小于0的时候转移
            if(less_than_zero = '1') then
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';
            end if;               
      when EXE_BNE_OP =>                   --源操作数不相等的时候转移
            if(aluin1 /= aluin2) then
               jump_target := jump_branch_address;
               jump_branch_true := '1';
               next_is_dslot := '1';
            end if;                                      
      when others =>
    end case;

    if(exception_ex_annul = '1') then
      jump_branch_true := '0';
      next_is_dslot := '0';
    end if;    
  end;

  procedure load_store_op(annul : std_logic; inst : word; 
               aluop : std_logic_vector(7 downto 0); 
               aluin1, aluin2: word;
               we_o : out std_logic;
               sel_o : out std_logic_vector(3 downto 0);
               addr_o,data_o : out word;
               load_op: out std_logic_vector(1 downto 0); 
               store_op : out std_logic) is
      variable temp,imm,temp1: word;
	begin
	    addr_o := (others => '0');
	    we_o := '0';
			imm(15 downto 0) := inst(15 downto 0);
		  imm(31 downto 16) := (others => inst(15));  --注意此处是符号扩展
		  temp := aluin1 + imm;
		  
		  --字节加载、存储指令，要依据目标地址设置sel的值，注意OpenMIPS工作在大端模式
	    if(aluop = EXE_LB_OP or aluop = EXE_SB_OP or aluop = EXE_LBU_OP or aluop = EXE_LWL_OP or aluop = EXE_LWR_OP) then
	      temp1 := aluin2(7 downto 0) & aluin2(7 downto 0) & aluin2(7 downto 0) & aluin2(7 downto 0);
        case temp(1 downto 0) is
          when "00" => sel_o := "1000";
          when "01" => sel_o := "0100";
          when "10" => sel_o := "0010";
          when "11" => sel_o := "0001";
          when others => sel_o := "1111";
        end case;
      --半字加载、存储指令，要依据目标地址设置sel的值，注意OpenMIPS工作在大端模式
      elsif(aluop = EXE_LH_OP or aluop = EXE_LHU_OP or aluop = EXE_SH_OP) then
        temp1 := aluin2(15 downto 0) & aluin2(15 downto 0);
        case temp(1 downto 0) is
          when "00" => sel_o := "1100"; 
          when "10" => sel_o := "0011"; 
          when others => sel_o := "1111";
        end case;
      --MIPS32指令集允许非对齐存储，对应的就是指令SWL、SWR
      elsif(aluop = EXE_SWL_OP) then
        temp1 := aluin2;
        case temp(1 downto 0) is
          when "00" => sel_o := "1111"; 
          when "01" => sel_o := "0111";
          when "10" => sel_o := "0011";
          when "11" => sel_o := "0001";
          when others => sel_o := "1111";
        end case;
      elsif(aluop = EXE_SWR_OP) then
        case temp(1 downto 0) is
          when "00" => sel_o := "1000"; temp1 := aluin2(7 downto 0) & zero32(23 downto 0);
          when "01" => sel_o := "1100"; temp1 := aluin2(15 downto 0) & zero32(15 downto 0);
          when "10" => sel_o := "1110"; temp1 := aluin2(23 downto 0) & zero32(7 downto 0);
          when "11" => sel_o := "1111"; temp1 := aluin2(31 downto 0);
          when others => sel_o := "1111"; temp1 := aluin2(31 downto 0);
        end case;
      else
        temp1 := aluin2;
        sel_o := "1111";
      end if;
	    data_o := (others => '0');
	    load_op := "00";
	    store_op := '0';
	    if(annul = '0') then	    
	    if(aluop = EXE_LB_OP or aluop = EXE_LH_OP or aluop = EXE_LW_OP 
	       or aluop = EXE_LL_OP or aluop = EXE_LWL_OP or aluop = EXE_LWR_OP) then
	      addr_o := temp;
	      we_o := '0';
	      load_op := "01";  --有符号加载
	    elsif(aluop = EXE_LBU_OP or aluop = EXE_LHU_OP) then
	      addr_o := temp;
	      we_o := '0';
	      load_op := "10";   --无符号加载
	    elsif(aluop = EXE_SB_OP or aluop = EXE_SH_OP or aluop = EXE_SW_OP or aluop = EXE_SWL_OP) then
	      addr_o := temp;
	      we_o := '1';
	      store_op := '1';   --store_op为1表示是存储操作
	      data_o := temp1;   --要存储的数据
	    elsif(aluop = EXE_SWR_OP) then
	      addr_o := temp;
	      we_o := '1';
	      store_op := '1';   --store_op为1表示是存储操作
	      data_o := temp1;   --要存储的数据
	    elsif(aluop = EXE_SC_OP) then
	      addr_o := temp;
	      we_o := '1';
	      store_op := '1';   --store_op为1表示是存储操作
	      load_op := "11";   --SC指令专用的load_op，SC指令既有存储操作，也有修改目的寄存器的操作
	      data_o := aluin2;  --要存储的数据
	    end if;
	    end if;
  end;

   --依据具体的加载指令，调整加载到的数据，作为要写入目的寄存器的数据
   function load_align(aluop : std_logic_vector(7 downto 0); sel: std_logic_vector(3 downto 0); 
                       load_op: std_logic_vector(1 downto 0); oldLLbit : std_logic;
                       data: word; opdata2: word) return std_logic_vector is
         variable data_sign_ext,result : word;
   begin
     	 data_sign_ext(31 downto 0) := (others => '0');
     	 if(load_op = "11") then       --是SC指令，将LLbit的值写入目的寄存器
	        result := data_sign_ext(30 downto 0) & oldLLbit;
	     elsif(aluop = EXE_LWL_OP) then  --MIPS32指令集中的LWL允许非对齐加载
	        case sel is
	          when "1000" => result := data;
	          when "0100" => result := data(23 downto 0) & opdata2(7 downto 0);
	          when "0010" => result := data(15 downto 0) & opdata2(15 downto 0);
	          when "0001" => result := data(7 downto 0) & opdata2(23 downto 0);
	          when others => 
	        end case;
	     elsif(aluop = EXE_LWR_OP) then  --MIPS32指令集中的LWR允许非对齐加载
	        case sel is
	          when "1000" => result := opdata2(31 downto 8) & data(31 downto 24);
	          when "0100" => result := opdata2(31 downto 16) & data(31 downto 16);
	          when "0010" => result := opdata2(31 downto 24) & data(31 downto 8);
	          when "0001" => result := data;
	          when others => 
	        end case;
	     else
	       case sel is
	         when "1000" =>
	           if(load_op = "01") then
	             data_sign_ext(23 downto 0 ) := (others => data(31));   --符号扩展加载
	           end if;	           
	           result := data_sign_ext(23 downto 0) & data(31 downto 24); --无符号扩展加载
	         when "0100" =>
	           if(load_op = "01") then
	             data_sign_ext(23 downto 0 ) := (others => data(23));   
	           end if;
	           result := data_sign_ext(23 downto 0) & data(23 downto 16);
	         when "0010" =>
	           if(load_op = "01") then
	             data_sign_ext(23 downto 0 ) := (others => data(15));
	           end if;
	           result := data_sign_ext(23 downto 0) & data(15 downto 8);
	         when "0001" =>
	           if(load_op = "01") then
	             data_sign_ext(23 downto 0 ) := (others => data(7));
	           end if;
	           result := data_sign_ext(23 downto 0) & data(7 downto 0);
	         when "1100" =>
	           if(load_op = "01") then
	             data_sign_ext(15 downto 0 ) := (others => data(31));
	           end if;
	           result := data_sign_ext(15 downto 0) & data(31 downto 16);
	         when "0011" =>
	           if(load_op = "01") then
	             data_sign_ext(15 downto 0 ) := (others => data(15));
	           end if;
	           result := data_sign_ext(15 downto 0) & data(15 downto 0);	         
	         when others =>
	           result := data(31 downto 0);
	       end case;
	     end if;
	     return result;
   end;

   procedure set_new_cp0_at_exstage(r,v: registers; opdata1, opdata2: in word; new_CP0: out CP0_reg_type) is
   begin
     --取得最新的CP0的值
     if(r.m.aluop = EXE_MTC0_OP) then 
       new_CP0 := r.m.CP0;   --如果访存阶段的指令是mtc0，那么r.m.cp0是最新的CP0的值
     else
       new_CP0 := v.w.CP0;   --反之，最新的CP0就是v.w.CP0
     end if;

     if(r.e.aluop = EXE_MTC0_OP and r.e.annul = '0') then
         if(opdata2(31 downto 5) = "000000000000000000000000000") then
         case opdata2(4 downto 0) is
              --mtc0指令写count寄存器
			        when CP0_REG_COUNT => new_CP0.count := opdata1;
			        --mtc0指令写compare寄存器
			        when CP0_REG_COMPARE => new_CP0.compare := opdata1; new_CP0.count := zero32;
			        --mtc0指令写EPC寄存器
			        when CP0_REG_EPC => new_CP0.EPC := opdata1;
			        --mtc0指令写status寄存器
			        when CP0_REG_STATUS => 
			                   new_CP0.status.CU := opdata1(31 downto 28);
			                   new_CP0.status.RP := opdata1(27);
			                   new_CP0.status.RE := opdata1(25); 
			                   new_CP0.status.BEV := opdata1(22); 
			                   new_CP0.status.TS := opdata1(21);
			                   new_CP0.status.SR := opdata1(20);
			                   new_CP0.status.NMI := opdata1(19);
			                   new_CP0.status.IM := opdata1(15 downto 8);
			                   new_CP0.status.UM := opdata1(4);
			                   new_CP0.status.ERL := opdata1(2);
			                   new_CP0.status.EXL := opdata1(1);
			                   new_CP0.status.IE := opdata1(0);
			        --mtc0指令写cause寄存器
			        when CP0_REG_CAUSE =>
	                       new_CP0.cause.BD := opdata1(1);
	                       new_CP0.cause.CE := opdata1(29 downto 28);
	                       new_CP0.cause.IV := opdata1(23);
	                       new_CP0.cause.WP := opdata1(22);
	                       new_CP0.cause.IP := opdata1(15 downto 8);
	                       new_CP0.cause.ExcCode := opdata1(6 downto 2);		        
			        when others => 
			   end case;
			   end if;
       end if;    
   end;

   procedure set_new_cp0_at_wbstage(r, v: registers; new_CP0: out CP0_reg_type; int: in std_logic_vector(7 downto 0); 
                                 exception_if_annul, exception_de_annul, exception_ex_annul, exception_mem_annul, exception_wb_annul: out std_logic; 
                                 exception_target_pc: out word; timer_int : out std_logic) is
   begin
     exception_if_annul := '0';
     exception_de_annul := r.d.annul;
     exception_ex_annul := r.e.annul;
     exception_mem_annul := r.m.annul;
     exception_wb_annul := r.w.annul;
     exception_target_pc := (others => '0');
     new_CP0 := r.w.CP0;
     
     --如果count寄存器的值等于compare寄存器的值，并且compare不为0，那么输出时钟中断
     --同时，保持count寄存器的值不变，等待中断处理
     if((r.w.CP0.count = r.w.CP0.compare) and r.w.CP0.compare /= zero32) then
	     timer_int := '1';
	     new_CP0.count := r.w.CP0.count;
	   --如果compare寄存器的值等于0，那么count寄存器的值保持为0，不计数，不产生中断
	   elsif(r.w.CP0.compare = zero32) then
	     new_CP0.count := zero32 ;
	     timer_int := '0';	     
	   --其余情况下，每个时钟周期count加1
	   else
	     new_CP0.count := r.w.CP0.count + 1;
	     timer_int := '0';
	   end if;  

       --判断是否满足中断条件，具体的中断条件有：
       --1、status寄存器的中断使能位IE为1
       --2、status寄存器的对应中断掩码IM为1
       --3、不处于异常处理过程中，也就是status寄存器的EXL位为0
       if(((int_r and r.w.CP0.status.IM) /= "00000000") and r.w.CP0.status.EXL = '0' and r.w.CP0.status.IE = '1' and r.w.annul = '0') then
         if(r.w.dslot = '1') then             --当前指令是否在延迟槽中
           new_CP0.EPC := r.w.pc & "00" - 4;  
           new_CP0.cause.BD := '1';
         elsif(r.w.store_op = '1') then       --如果当前指令是存储指令，那么设置EPC为PC+4
                                              --因为存储指令在访存阶段就已经执行完毕，如果此处设置为PC
                                              --那么当从异常返回时，会重复执行该存储指令
           new_CP0.EPC := r.w.pc & "00" + 4;
           new_CP0.cause.BD := '0';
         else                                 --其余情况下设置EPC的值等于PC
           new_CP0.EPC := r.w.pc & "00";
           new_CP0.cause.BD := '0';
         end if;
         new_CP0.status.EXL := '1';           --设置status寄存器的EXL位为1，表示处于异常处理中
         exception_if_annul := '1';           --取消取指阶段的指令
         exception_de_annul := '1';           --取消译码阶段的指令
         exception_ex_annul := '1';           --取消执行阶段的指令
         exception_mem_annul := '1';          --取消访存阶段的指令
         exception_wb_annul := '1';           --取消回写阶段的指令
         exception_target_pc := "00000000000000000000000000100000";  --此处设置中断的入口地址是0x20
         new_CP0.cause.ExcCode := "00001";    --设置cause寄存器的ExcCode位，存储异常代码 
         new_CP0.cause.IP := int_r;           --设置cause寄存器的IP位，存储中断信号的值
       elsif(r.w.aluop = EXE_SYSCALL_OP and r.w.annul = '0') then  --处理syscall指令
         if(r.w.CP0.status.EXL = '0') then
           if(r.w.dslot = '1') then
             new_CP0.EPC := r.w.pc & "00" - 4;
             new_CP0.cause.BD := '1';
           else
             new_CP0.EPC := r.w.pc & "00";
             new_CP0.cause.BD := '0';
           end if;
         end if;
         new_CP0.status.EXL := '1';
         exception_if_annul := '1';
         exception_de_annul := '1';
         exception_ex_annul := '1';
         exception_mem_annul := '1';
         exception_wb_annul := '1';
         exception_target_pc := "00000000000000000000000001000000";  --此处设置SYSCALL的入口地址是0x40
         new_CP0.cause.ExcCode := "01000";
	    elsif(r.w.inst_valid = '0' and r.w.annul = '0') then  --处理指令无效异常
		   if(r.w.CP0.status.EXL = '0') then
           if(r.w.dslot = '1') then
             new_CP0.EPC := r.w.pc & "00" - 4;
             new_CP0.cause.BD := '1';
           else
             new_CP0.EPC := r.w.pc & "00";
             new_CP0.cause.BD := '0';
           end if;
         end if;
         new_CP0.status.EXL := '1';
         exception_if_annul := '1';
         exception_de_annul := '1';
         exception_ex_annul := '1';
         exception_mem_annul := '1';
         exception_wb_annul := '1';
         exception_target_pc := "00000000000000000000000001000000";  --此处设置invalid instruction的入口地址是0x40
         new_CP0.cause.ExcCode := "01010";
       elsif(((r.w.exception_type and EXCEPTION_TYPE_TRAP) /= "00000000") and r.w.annul = '0') then  --处理自陷指令异常
         if(r.w.CP0.status.EXL = '0') then
           if(r.w.dslot = '1') then
             new_CP0.EPC := r.w.pc & "00" - 4;
             new_CP0.cause.BD := '1';
           else
             new_CP0.EPC := r.w.pc & "00";
             new_CP0.cause.BD := '0';
           end if;
         end if;
         new_CP0.status.EXL := '1';
         exception_if_annul := '1';
         exception_de_annul := '1';
         exception_ex_annul := '1';
         exception_mem_annul := '1';
         exception_wb_annul := '1';
         exception_target_pc := "00000000000000000000000001000000";  --此处设置Txx指令的入口地址是0x40
         new_CP0.cause.ExcCode := "01101";
       elsif(r.w.aluop = EXE_ERET_OP and r.w.annul = '0') then   --处理eret返回指令
         exception_if_annul := '1';
         exception_de_annul := '1';
         exception_ex_annul := '1';
         exception_mem_annul := '1';
         exception_wb_annul := '1';
         exception_target_pc := r.w.CP0.EPC;                         --eret指令，返回到EPC寄存器保存的地址处
         new_CP0.status.EXL := '0';
       elsif(r.w.aluop = EXE_MTC0_OP ) then
         if(r.w.opdata2(31 downto 5) = "000000000000000000000000000") then
         case r.w.opdata2(4 downto 0) is
              when CP0_REG_COUNT => new_CP0.count := r.w.CP0_t.count;
              --此处单独处理compare寄存器，因为，如果要写compare寄存器，那么需要复位时钟中断，同时设置count为0
			        when CP0_REG_COMPARE => new_CP0.compare := r.w.opdata1; timer_int := '0'; new_CP0.count := zero32;
			        when others =>
			                   new_CP0.EPC := r.w.CP0_t.EPC;
			                   new_CP0.status := r.w.CP0_t.status;
			                   new_CP0.cause := r.w.CP0_t.cause; 
			   end case;
			   end if;
       end if;    
   end;

  procedure trap_op(r: registers; aluin1, aluin2: word; exception_type: out std_logic_vector(7 downto 0)) is
    variable signed_comp, a_gt_b, a_eq_b : std_logic;
    variable comp_a, comp_b : word;
  begin
  
    	if r.e.aluop = EXE_TGEIU_OP or r.e.aluop = EXE_TGEU_OP or r.e.aluop = EXE_TLTIU_OP or r.e.aluop = EXE_TLTU_OP then 
	      signed_comp := '0';              --是无符号数比较
	    else 
	      signed_comp := '1';              --是有符号数比较
	    end if;
	    
	    comp_a := (aluin1(31) xor signed_comp) & aluin1(30 downto 0);
	    comp_b := (aluin2(31) xor signed_comp) & aluin2(30 downto 0);
	    
	    if comp_a > comp_b then 
	      a_gt_b := '1';
	      a_eq_b := '0';
	    elsif comp_a = comp_b then
	      a_gt_b := '0';
	      a_eq_b := '1';
	    else
	      a_gt_b := '0';
	      a_eq_b := '0';
	    end if;
	    
	    case r.e.aluop is
	      when EXE_TEQI_OP | EXE_TEQ_OP => 
	           if(a_eq_b = '1') then
	             exception_type := EXCEPTION_TYPE_TRAP;
	           else
	             exception_type := (others => '0');
	           end if; 
	      when EXE_TGE_OP | EXE_TGEI_OP | EXE_TGEIU_OP | EXE_TGEU_OP => 
	           if(a_gt_b = '1' or a_eq_b = '1') then
	             exception_type := EXCEPTION_TYPE_TRAP;
	           else
	             exception_type := (others => '0');
	           end if; 
	      when EXE_TLT_OP | EXE_TLTI_OP | EXE_TLTIU_OP | EXE_TLTU_OP => 
	           if(a_gt_b = '0' and a_eq_b = '0') then
	             exception_type := EXCEPTION_TYPE_TRAP;
	           else
	             exception_type := (others => '0');
	           end if; 
	      when EXE_TNEI_OP | EXE_TNE_OP => 
	           if(a_eq_b = '0') then
	             exception_type := EXCEPTION_TYPE_TRAP;
	           else
	             exception_type := (others => '0');
	           end if;
	      when others => exception_type := (others => '0');
	    end case;
	            
  end;

begin
  

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
----------------------------      process comb         ----------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

  comb : process( dmem_rdata, imem_data, rf_i, r, rst, HI, LO, div_result_ready, div_result, int_r)     
	  variable v 	: registers;
	  variable ex_logic_res, ex_shift_res: word;
	  variable ex_arithmetic_res, ex_move_res: word;
	  variable ex_mul_res : std_logic_vector(63 downto 0);
	  variable ex_load_res : word;	  
    variable newhilo, hilo_temp : std_logic_vector(63 downto 0);	  	  	  
	  variable ex_result: word;
	  variable ex_opdata1,ex_opdata2 : word;
    variable cnt_temp : std_logic_vector(1 downto 0);
    variable overflow, notmove : boolean;
    variable ex_stall_for_new_RF, ex_stall_for_multicycle_inst: std_logic;  
    variable start_div_temp, signed_div_temp, annul_div_temp : std_logic;
    variable jump_branch_true: std_logic;
    variable jump_branch_res, ex_jump_target: word;  
    variable timer_int : std_logic;   
    variable exception_if_annul, exception_de_annul, exception_ex_annul, exception_mem_annul, exception_wb_annul : std_logic;
    variable exception_target_pc : word;            
  begin

    v := r; 
	  SI_TimerInt <= '0';
-----------------------------------------------------------------------
-- WRITE BACK STAGE
-----------------------------------------------------------------------
    
    set_new_cp0_at_wbstage(r, v, v.w.CP0, int_r, exception_if_annul, exception_de_annul,
                           exception_ex_annul, exception_mem_annul, exception_wb_annul, exception_target_pc, timer_int);    
    
    SI_TimerInt <= timer_int;
    
    --依据运算结果进行Regfile的写操作
    rf_o.wdata <= r.w.result; 
	  rf_o.waddr <= r.w.waddr;

    v.w.LLbit := r.w.LLbit;


	  if(exception_wb_annul = '1') then
	    rf_o.wren <= '0';
	  else
      rf_o.wren <= r.w.wreg; 
    end if;
 	     
    if((r.w.aluop = EXE_SC_OP or r.w.aluop = EXE_ERET_OP) and (exception_wb_annul = '0')) then
      v.w.LLbit := '0';           --只有SC指令执行完毕后或者eret指令执行后，才修改LLbit的值为0
    end if;
    
    if((r.w.aluop = EXE_LL_OP) and (exception_wb_annul = '0')) then
      v.w.LLbit := '1';           --只有LL指令执行完毕后，才修改LLbit的值为1
    end if;
    
-----------------------------------------------------------------------
-- MEMORY STAGE
-----------------------------------------------------------------------

    --将Regfile的写信号传递到回写阶段
    v.w.result := r.m.result;
	  v.w.waddr  := r.m.waddr;
	  v.w.wreg   := r.m.wreg;
	  
	  --将HI、LO的写信号传递到回写阶段
	  v.w.whilo  := r.m.whilo;
	  v.w.hilo   := r.m.hilo; 	  
	  
	  v.w.aluop  := r.m.aluop;  
	  v.w.inst_valid := r.m.inst_valid;

 	  v.w.load_op := r.m.load_op;
	  v.w.store_op := r.m.store_op;

	  v.w.CP0_t := r.m.CP0;

	  v.w.opdata1 := r.m.opdata1;
	  v.w.opdata2 := r.m.opdata2;
	  v.w.exception_type := r.m.exception_type;
	  v.w.dslot  := r.m.dslot;
	  v.w.pc     := r.m.pc;
	  v.w.annul := r.m.annul;	  	  
	  dmem_we <= r.m.we;
	  dmem_sel <= r.m.sel;
	  dmem_addr <= r.m.addr;
	  dmem_wdata <= r.m.wdata;

	  if(exception_mem_annul = '1') then
	    dmem_we <= '0';
	    v.w.annul := '1';
	    v.w.wreg := '0';
	    v.w.whilo := '0';	
	    v.w.load_op := "00";
	    v.w.store_op := '0';	           
	  end if;
	  
	  --load_op不为00，表示是加载指令，需要依据指令类型、目标地址，对dmem的返回值dmem_rdata进行修改对齐
	  if(r.m.load_op /= "00") then
      v.w.result := load_align(r.m.aluop, r.m.sel, r.m.load_op, v.w.LLbit, dmem_rdata, r.m.opdata2);    
    end if;
  
    --对于SC指令，如果LLbit为0，那需要么写入目的寄存器的值为0，反之为1
    if(r.m.aluop = EXE_SC_OP ) then
      if(v.w.LLbit = '0') then
        v.w.result := zero32;
        dmem_we <= '0';
      else 
        v.w.result := zero32(30 downto 0) & '1';
      end if;
    end if;	     
-----------------------------------------------------------------------
-- EXECUTE STAGE
-----------------------------------------------------------------------
    --madd、maddu、msub、msubu指令需要与HI、LO寄存器的值运算，此处调用
    --函数get_new_hilo得到最新的HI、Lo寄存器的值
    newhilo := get_new_hilo(r,v,HI,LO);

    --操作数选择，是立即数还是寄存器的值，要考虑加载指令与下一条指令可
    --能存在的数据相关问题，如果存在这种数据相关，那么设置ex_stall_for_new_RF
    --为1
    opdata_select(r, v, exception_mem_annul, exception_wb_annul, ex_opdata1, ex_opdata2, ex_stall_for_new_RF);
    
    div_opdata1 <= ex_opdata1;
	  div_opdata2 <= ex_opdata2;
    
    --向访存阶段传递要写的目的寄存器、是否要写入目的寄存器
    v.m.waddr := r.e.rd;
    v.m.wreg := r.e.wreg;    
    v.m.aluop := r.e.aluop;
    v.m.opdata1 := ex_opdata1;
    v.m.opdata2 := ex_opdata2;
    v.m.inst_valid := r.e.inst_valid;
    v.m.pc := r.e.pc;  
    v.m.dslot := r.e.dslot;
    if(exception_ex_annul = '1') then
      v.m.annul := '1';
    else
      v.m.annul := '0';
    end if;            
    
    --调用过程logic_op进行逻辑运算，结果存储在ex_logic_res中
    logic_op(r, ex_opdata1, ex_opdata2, ex_logic_res);

    --调用过程shift_op进行移位运算，结果存储在ex_shift_res中
    shift_op(r, ex_opdata1, ex_opdata2, ex_shift_res);

    --调用过程arithmetic_op进行算术运算，结果存储在ex_arithmetic_op中
    arithmetic_op(r, ex_opdata1, ex_opdata2, ex_arithmetic_res, overflow);
    
    --对于add\addi\sub指令，如果运算有溢出，那么不修改目的寄存器 
    if(overflow = true) then
      v.m.wreg := '0';
    end if;

    --调用过程mul_op进行乘法运算，结果存储在ex_mul_res中
    mul_op(r, ex_opdata1, ex_opdata2, ex_mul_res);

    --得到最新的CP0寄存器的值
    set_new_cp0_at_exstage(r, v, ex_opdata1, ex_opdata2, v.m.CP0);

    --调用过程move_op进行移动操作类指令的执行，结果存储在ex_move_res中
    move_op(r, v.m.CP0, ex_opdata1, ex_opdata2, newhilo, ex_move_res, notmove);
    
    --对于movn\movz指令，如果条件不满足，那么notmove为true，表示不修改目的寄存器
    --所以设置v.m.wreg为0
    if(notmove = true) then
      v.m.wreg := '0';
    end if;

    trap_op(r, ex_opdata1, ex_opdata2, v.m.exception_type);

    --调用过程jump_branch_op，判断是否需要转移，转移的目标地址，要写入r31的值
    jump_branch_op(r, exception_ex_annul, ex_opdata1, ex_opdata2, jump_branch_res, 
                   ex_jump_target, jump_branch_true, v.e.dslot);

    --调用过程load_store_op，在其中依据加载存储操作类型，设置dmem模块的输入信号
    load_store_op(exception_ex_annul, r.e.inst, r.e.aluop, ex_opdata1, ex_opdata2, 
               v.m.we, v.m.sel, v.m.addr, v.m.wdata, v.m.load_op, v.m.store_op);
    
    --调用过程alu_select，依据操作类型，选择对应的运算结果存储到ex_result中
    alu_select(r, ex_logic_res, ex_shift_res, ex_arithmetic_res, ex_move_res, ex_mul_res,
               jump_branch_res, ex_result);      
    
    --将最终的运算结果传递到访存阶段
    v.m.result := ex_result;

    --依据乘法结果，给出新的hilo、whilo的值，以及cnt的值
    set_new_hilo(r, v, exception_ex_annul, ex_stall_for_new_RF, ex_opdata1, ex_opdata2, ex_mul_res, newhilo, hilo_temp, v.m.hilo, v.m.whilo, cnt_temp,
                  start_div_temp, signed_div_temp, annul_div_temp );   
    
    annul_div <= annul_div_temp;
    start_div <= start_div_temp;
	  signed_div <= signed_div_temp;
    
    if(r.e.cnt /= "00"  and exception_ex_annul ='0') then     --在inst_decode过程中依据指令设置r.e.cnt的值
	    ex_stall_for_multicycle_inst := '1';     --对于多周期指令，设置该值为"1"，表示流水线因为
	                                             --多周期指令而暂停
	    v.m.whilo := '0';
	    v.m.wreg := '0';
	    v.m.aluop := (others => '0');
	    v.m.inst_valid := '1';	    
	  else
	    ex_stall_for_multicycle_inst := '0';
    end if; 
    
    --如果本指令与上一条加载指令存在数据相关，那么流水线会暂停，下一周期
    --进入访存阶段的指令为空指令
    if(ex_stall_for_new_RF = '1') then
      v.m.whilo := '0';
	    v.m.wreg := '0';
	    v.m.aluop := (others => '0');
	    v.m.inst_valid := '1';
	  end if;    
-----------------------------------------------------------------------
-- DECODE STAGE
-----------------------------------------------------------------------
    --调用过程inst_decode
	  inst_decode(r.d.inst, v.e.wreg, v.e.rd, v.e.aluop, v.e.alusel,
	              v.e.rfe1, v.e.rfe2, v.e.rfa1, v.e.rfa2, v.e.imm, v.e.cnt, v.e.inst_valid);
  
    --依据译码结果，给出Regfile的访问信号
    rf_o.raddr1 <= v.e.rfa1;   --第一个寄存器的读地址
	  rf_o.raddr2 <= v.e.rfa2;   --第二个寄存器的读地址                    
    rf_o.ren1 <= v.e.rfe1;     --第一个寄存器的读使能信号
    rf_o.ren2 <= v.e.rfe2;     --第二个寄存器的读使能信号

    v.e.inst := r.d.inst;
    v.e.pc := r.d.pc;

    --将从Regfile中读取出的寄存器值，传递到执行阶段
    v.e.reg1 := rf_i.data1;    --读出的第一个寄存器的值
    v.e.reg2 := rf_i.data2;    --读出的第二个寄存器的值

    if(exception_de_annul = '1') then
      v.e.annul := '1';
    else
      v.e.annul := r.d.annul;
    end if;    
    
-----------------------------------------------------------------------
-- FETCH STAGE
-----------------------------------------------------------------------
    v.d.annul := '0';  
    
    --给出imem的读取地址
    imem_addr <= r.f.pc(31 downto 2) & "00";
    
    --将从imem中读取的指令保存到v.d.inst中，在一个时钟周期进入译码阶段           
    v.d.inst := imem_data;
    v.d.pc := r.f.pc;
   
    if (rst = '1') then                           
      v.f.pc := "000000000000000000000000000000";
      dmem_we <= '0';
      dmem_sel <= "0000";       
    elsif(ex_stall_for_multicycle_inst = '1' or ex_stall_for_new_RF = '1') then
      --如果正处于执行阶段的是多周期指令或者与上一条加载指令存在数据相关，那么不改变pc的值
      v.f.pc := r.f.pc;  
    elsif(exception_if_annul = '1') then
      v.f.pc := exception_target_pc(31 downto 2);
      v.d.annul := '1';
      v.d.inst := zero32;          
    elsif(jump_branch_true = '1') then  
      --执行阶段是转移指令，设置新的pc值，同时设置取指阶段的指令为NOP    
      v.f.pc := ex_jump_target(31 downto 2);
      v.d.annul := '1';      
      v.d.inst := zero32;          
    else
      --下一条指令是当前读取指令地址加4
      v.f.pc := r.f.pc(31 downto 2) + 1;  
    end if;
   

    
-----------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------    
    --如果正处于执行阶段的指令与上一条加载指令存在数据相关，那么保存该指
    --令的操作数，访存、回写阶段的指令可以继续向前流转
    if(ex_stall_for_new_RF = '1') then         
      rin.e.reg1 <= ex_opdata1;
      rin.e.reg2 <= ex_opdata2;
      rin <= r;
      rin.m <= v.m;
      rin.w <= v.w;
    elsif(ex_stall_for_multicycle_inst = '1') then
    --如果正处于执行阶段的多周期指令，那么保存该指令的操作数，访存、
    --回写阶段的指令可以继续向前流转，同时保存执行阶段指令计算出的HI、Lo
    --的值，以及cnt的值，对多周期指令而言，每执行一个周期，cnt的值减1，
    --cnt为0表示当前是多周期指令的最后一个周期，    
      rin.e.reg1 <= ex_opdata1;
      rin.e.reg2 <= ex_opdata2;    
      rin <= r;
      rin.e.cnt <= cnt_temp;        
      rin.e.hilo <= hilo_temp;
      rin.m <= v.m;                   --访存阶段继续向前流转
      rin.w <= v.w;                   --回写阶段继续向前流转
    else    
      rin <= v;                                                      
    end if;                                              

  end process;

  reg : process (clk)
  begin
    if rising_edge(clk) then
		if(rst = '1') then
			r.w.result <= (others => '0');
			r.w.waddr  <= (others => '0');
			r.w.wreg   <= '0';		
			r.w.whilo <= '0';
			r.w.hilo <= (others => '0');	
			r.w.aluop <= (others => '0');		
			r.w.LLbit <= '0';
			r.w.sel <= (others => '0');	
      r.w.load_op <= "00";
      r.w.store_op <= '0';  					
			r.w.inst_valid <= '1';	      	
			r.w.CP0.status <= ("0001",'0','0','0','0','0','0',"00000000",'0','0','0','0');  --CP0协处理器存在
			r.w.CP0.cause <= ('0',"00",'0','0',"00000000","00000");
			r.w.CP0.config <= ('0','0','0','0','1',"00","000","011");  --MMU类型为固定映射
			r.w.CP0.PrId <= ("01001100","00000001","00000001"); --制作者是L，对应的是0x48，类型是0x1，基本类型，版本号是0.1
			r.w.CP0.EPC <= (others => '0');
			r.w.CP0.BadVAddr <= (others => '0');
			r.w.CP0.ErrorEPC <= (others => '0');
			r.w.CP0.count <= (others => '0');
			r.w.CP0.compare <= (others => '0');
			r.w.CP0_t.status <= ("0001",'0','0','0','0','0','0',"00000000",'0','0','0','0');  --CP0协处理器存在
			r.w.CP0_t.cause <= ('0',"00",'0','0',"00000000","00000");
			r.w.CP0_t.config <= ('0','0','0','0','1',"00","000","011");  --MMU类型为固定映射
			r.w.CP0_t.PrId <= ("01001100","00000001","00000001"); --制作者是L，对应的是0x48，类型是0x1，基本类型，版本号是0.1
			r.w.CP0_t.EPC <= (others => '0');
			r.w.CP0_t.BadVAddr <= (others => '0');
			r.w.CP0_t.ErrorEPC <= (others => '0');
			r.w.CP0_t.count <= (others => '0');
			r.w.CP0_t.compare <= (others => '0');			
			r.w.opdata1 <= (others => '0');
			r.w.opdata2 <= (others => '0');	
			r.w.exception_type <= (others => '0');
			r.w.annul <= '0';
			r.w.dslot <= '0';		
			r.w.pc <= (others => '0');											
									
      r.m.waddr <= (others => '0');
      r.m.wreg <= '0';
      r.m.result <= zero32;		
      r.m.whilo <= '0';
      r.m.hilo <= (others => '0');   
      r.m.we <= '0';
      r.m.sel <= (others => '0');
      r.m.addr <= (others => '0');
      r.m.wdata <= (others => '0');
      r.m.load_op <= "00";
      r.m.store_op <= '0';     
      r.m.hilo <= (others => '0'); 
      r.m.opdata1 <= zero32;
      r.m.opdata2 <= zero32;       
      r.m.inst_valid <= '1';    
			r.m.aluop <= (others => '0');	
			r.m.CP0.status <= ("0001",'0','0','0','0','0','0',"00000000",'0','0','0','0');  --CP0协处理器存在
			r.m.CP0.cause <= ('0',"00",'0','0',"00000000","00000");
			r.m.CP0.config <= ('0','0','0','0','1',"00","000","011");  --MMU类型为固定映射
			r.m.CP0.PrId <= ("01001100","00000001","00000001"); --制作者是L，对应的是0x48，类型是0x1，基本类型，版本号是0.1
			r.m.CP0.EPC <= (others => '0');
			r.m.CP0.BadVAddr <= (others => '0');
			r.m.CP0.ErrorEPC <= (others => '0');
			r.m.CP0.count <= (others => '0');
			r.m.CP0.compare <= (others => '0');		
      r.m.dslot <= '0';
      r.m.exception_type <= (others => '0');
      r.m.annul <= '0'; 
      r.m.pc <= (others => '0');                 			
							                				
			r.e.rd <= (others => '0');
			r.e.wreg <= '0';
			r.e.rfe1 <= '0';
			r.e.rfe2 <= '0';
			r.e.rfa1 <= (others => '0');
			r.e.rfa2 <= (others => '0');
			r.e.imm <= zero32;
			r.e.aluop <= (others => '0');
			r.e.alusel <= (others => '0');
			r.e.cnt <= (others => '0');
			r.e.inst_valid <= '1';		
			r.e.reg1 <= zero32;
			r.e.reg2 <= zero32;	
			r.e.hilo <= (others => '0');	
			r.e.dslot <= '0';
			r.e.pc <= (others => '0');
			r.e.inst <= (others => '0');		
			r.e.annul <= '0';				
										
			r.d.pc <= (others => '0');
			r.d.inst <= zero32;		
			r.d.annul <= '0';						
			
			r.f.pc <= "000000000000000000000000000000";	
				
			HI <= (others => '0');
			LO <= (others => '0');	
      int_r <= (others => '0');						
	   else
		   r <= rin;	
		   int_r <= int_i;		   
		   if(r.w.whilo = '1' and r.w.annul = '0') then
		      HI <= r.w.hilo(63 downto 32);
		      LO <= r.w.hilo(31 downto 0);
		   end if;		   	    
      end if;		  
    end if;
  end process;

end;
