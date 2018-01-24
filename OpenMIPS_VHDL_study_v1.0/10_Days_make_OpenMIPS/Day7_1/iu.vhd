-----------------------------------------------------------------------------
-- Entity: 	iu
-- File:	iu.vhd
-- Author:	Lei Silei
-- Description:	OpenMIPS 5-stage integer pipline
------------------------------------------------------------------------------

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
    div_opdata1,div_opdata2 : out word    
    );
end;

architecture rtl of iu is

  signal r, rin : registers;
  signal HI,LO : word;
      
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
						when others =>
					end case;
				 when others =>
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

  procedure opdata_select(r,v: registers; opdata1 : out word; opdata2: out word) is
                   
	begin   
	   if r.e.rfe1='0' then
	     opdata1 := r.e.imm;                            --Դ��������������
     elsif (r.m.waddr = r.e.rfa1 and r.m.wreg = '1' and r.e.rfe1 = '1') then  
       opdata1 := r.m.result;                     --����һ��ָ������������
     elsif (r.w.waddr = r.e.rfa1 and r.w.wreg = '1' and r.e.rfe1 = '1') then
       opdata1 := r.w.result;                     --������һ��ָ������������
     else     
       opdata1 := r.e.reg1;                     --�������������
     end if;
     
     if r.e.rfe2='0' then
	     opdata2 := r.e.imm;                            --Դ��������������
     elsif (r.m.waddr = r.e.rfa2 and r.m.wreg = '1' and r.e.rfe2 = '1' ) then  
       opdata2 := r.m.result;                     --����һ��ָ������������
     elsif (r.w.waddr = r.e.rfa2 and r.w.wreg = '1' and r.e.rfe2 = '1' ) then
       opdata2 := r.w.result;                     --������һ��ָ������������
     else     
       opdata2 := r.e.reg2;                     --�������������
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
   
      --�����ָ��clz����ô���ú���find_first_one���������aluin1�Ӹ�λ
      --��ʼ�ĵ�һ��1֮ǰ��0�ĸ�������֮��aluin1ȡ�����ڵ��ú���find_first_one
      --ʵ��Ч���Ǽ��������aluin1�Ӹ�λ��ʼ�ĵ�һ��0֮ǰ��1�ĸ���
	    if r.e.aluop = EXE_CLZ_OP then
	       countres := find_first_one(aluin1 );
	    else 
	       countres := find_first_one(not aluin1);
	    end if;
	    
	    --����Ƿ������Ƚϣ���ô����compΪ1����֮������compΪ0
	    if r.e.aluop = EXE_SLT_OP then 
	      comp := '1';              --���з������Ƚ�
	    else 
	      comp := '0';              --���޷������Ƚ�
	    end if;
	    
	    --���½��бȽ�����
	    comp_a := (aluin1(31) xor comp) & aluin1(30 downto 0);
	    comp_b := (aluin2(31) xor comp) & aluin2(30 downto 0);
	    
	    if comp_a < comp_b then 
	      compareres := (others => '0');
	      compareres(0) := '1';
	    else 
	      compareres := (others => '0');
	    end if;
	      
	      --����Ǽ�������ô��������aluin2ȡ����1��������ת��Ϊ�ӷ�  
	      if(r.e.aluop = EXE_SUB_OP or r.e.aluop = EXE_SUBU_OP) then
	        aluin2_mux := (not aluin2) + 1;
	      else 
	        aluin2_mux := aluin2;
	      end if;
	      
	      --result�Ǽ������ӷ�������	        	        
	      result := aluin1 + aluin2_mux;
	      
	      --���ݾ��������ָ�ѡ�����漸���������е�һ������Ϊ��������������
		    case r.e.aluop is
			   when EXE_ADD_OP | EXE_ADDI_OP =>   --add��addiָ��Ҫ������������ 			        
			        if( (aluin1(31)='1' and aluin2_mux(31)='1' and result(31)='0')
			         or (aluin1(31)='0' and aluin2_mux(31)='0' and result(31)='1')) then
			            overflow := true;
			        end if;
			   when EXE_SUB_OP =>            --subָ��Ҫ������������
			        if( aluin1(31)='0' and aluin2_mux(31)='1' and result(31)='1' ) then
			           overflow := true;
			        end if;
			   when EXE_SLT_OP | EXE_SLTU_OP => result := compareres;  --�Ƚ�ָ��Ľ����compareres
			   when EXE_CLZ_OP | EXE_CLO_OP => result := countres;		 --clo��clzָ��Ľ����countres          
			   when others  => null;
		    end case;
		  
		  --������������ս�������arithmeticres��  
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
	       opdata1 := (not aluin1) + 1;    --���з�����ת��Ϊ�޷�������������
	    else 
	       opdata1 := aluin1;
	    end if;
	     
	    if((r.e.aluop = EXE_MUL_OP or r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MADD_OP or r.e.aluop = EXE_MSUB_OP )
	        and aluin2(31) = '1') then
	       opdata2 := (not aluin2) + 1;    --���з�����ת��Ϊ�޷�������������
	    else 
	       opdata2 := aluin2;
      end if;
       
      mulout := opdata1 * opdata2;
          
		 case r.e.aluop is
			when EXE_MUL_OP | EXE_MULT_OP | EXE_MADD_OP | EXE_MSUB_OP => 
			     if((aluin1(31) xor aluin2(31)) = '1') then  --�з��ų˷����һ�Ϊ��
			       mulout := (not mulout) + 1;
			     end if;
			when others => 
		 end case;
		 mulres := mulout;
  end;

  procedure move_op(r : registers; aluin1, aluin2: word; 
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
			         moveout := aluin1;  --movnָ���������Ĵ���������0��ʱ���޸ļĴ�����ֵ
			      else 
			         notmove := true;
			      end if;
			when EXE_MOVZ_OP => 
					  if aluin2 = zeros then
			         moveout := aluin1;  --movzָ���������Ĵ�������0��ʱ���޸ļĴ�����ֵ
			      else 
			         notmove := true;
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

  --�õ����µ�HI��LO�Ĵ�����ֵ
  function get_new_hilo(r,v: registers; hi,lo: word) return std_logic_vector is
  begin
     if(r.m.whilo = '1' ) then  --����ô�׶�ҪдHI��LO
       return r.m.hilo;
     elsif(r.w.whilo = '1' ) then  --�����д�׶�ҪдHI��LO
       return r.w.hilo;
     else
       return hi & lo;             --����ֱ�ӷ���HI��LO�Ĵ�����ֵ
     end if;
  end;

  --����ָ�����HI��LO�Ĵ�����ֵ
  procedure set_new_hilo(r, v: registers; aluin1, aluin2: word; 
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
    hilo_temp := new_hilo;    --Ŀǰ���µ�HI��LO�Ĵ�����ֵ
    start_div := '0';
    annul_div := '0';
    signed_div := '0';
    
    --mult\multuָ��˷���������HI��LO�Ĵ�������������whiloΪ1��hiloΪ�˷����
    if((r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MULTU_OP)) then
      hilo := mul_res;
      whilo := '1';
    elsif(r.e.aluop = EXE_MADD_OP or r.e.aluop = EXE_MADDU_OP) then
      if( r.e.cnt = "01" ) then      --MADD��MADDU�Ƕ�����ָ�cntΪ1��ʾ�ǵ�һ������
                                     --��ʱִ�г˷�
        hilo_temp := mul_res;
        new_cnt := "00";             --����new_cntΪ00����ʾ��һ��ʱ�������Ƕ�����ָ���
                                     --ִ�н׶����һ��ʱ������
      else
        hilo := new_hilo + r.e.hilo;  --cntΪ00����ʾ�ǵڶ������ڣ���ʱִ�мӷ�
                                      --r.e.hilo�д洢����һ�����ڼ�������ĳ˷����
        whilo := '1';                 --�ڶ�������MADD��MADDUָ����޸�HI��LO��ֵ
      end if;
    elsif(r.e.aluop = EXE_MSUB_OP or r.e.aluop = EXE_MSUBU_OP) then
      temp := (not r.e.hilo) +1;     --���룬������ת��Ϊ�ӷ���r.e.hilo����һ������
                                     --��������ĳ˷����
      if( r.e.cnt = "01" ) then      --MSUB��MSUBU�Ƕ�����ָ�cntΪ1��ʾ�ǵ�һ������
                                     --��ʱִ�г˷�
        new_cnt := "00";
        hilo_temp := mul_res;        --����new_cntΪ00����ʾ��һ��ʱ�������Ƕ�����ָ���
                                     --ִ�н׶����һ��ʱ������
      else
        hilo := new_hilo + temp;     --cntΪ00����ʾ�ǵڶ������ڣ���ʱִ�м���
        whilo := '1';                --�ڶ�������MSUB��MSUBUָ����޸�HI��LO��ֵ
      end if;
    elsif(r.e.aluop = EXE_MTHI_OP) then   --��mthiָ���ҪдHI�Ĵ���
        hilo(63 downto 32) := aluin1;
        hilo(31 downto 0) := new_hilo(31 downto 0); --LO�Ĵ������ֲ���
        whilo := '1';
    elsif (r.e.aluop = EXE_MTLO_OP) then  --��mtloָ���ҪЩLO�Ĵ���
        hilo(31 downto 0) := aluin1;
        hilo(63 downto 32) := new_hilo(63 downto 32); --HI�Ĵ������ֲ���
        whilo := '1';            
    elsif( r.e.aluop = EXE_DIV_OP ) then  --����Ҳ�Ƕ�����ָ��
        if(div_result_ready = '1') then    --������div_result_readyΪ1ʱ����ʾ��������
           new_cnt := "00";                --����new_cntΪ00����ʾ��һ��ʱ�������Ƕ�����ָ���
                                           --ִ�н׶����һ��ʱ������
           hilo := div_result;             --���������д��HI��LO�Ĵ���
           whilo := '1';
           start_div := '0';               --֪ͨ����ģ�����free״̬
        else
          new_cnt := "01"; 
          whilo := '0';
          start_div := '1';                --֪ͨ����ģ�鿪ʼ��������
          signed_div := '1';               --divָ����е����з��ų���
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
          signed_div := '0';                --divuָ����е����޷��ų��� 
        end if;
     else
      hilo := new_hilo;
      whilo := '0';
    end if;      
  end;

  procedure jump_branch_op(r: registers;
                           aluin1, aluin2: word; jump_branch_res, jump_target: out word;
                           jump_branch_true: out std_logic; next_is_dslot: out std_logic) is 
    variable temp:pctype;
  begin
    temp := r.e.pc + 2;
    jump_target := (others => '0');
    jump_branch_true := '0';
    next_is_dslot := '0';
    
    if(r.e.aluop = EXE_JAL_OP or r.e.aluop = EXE_JALR_OP) then
      jump_branch_res := temp & "00";
    end if;
    
    case r.e.aluop is
      when EXE_JALR_OP | EXE_JR_OP =>
            jump_target := aluin1;         --��ͬ��ת��ָ�����ת��Ŀ���ַ�ķ�����ͬ
            jump_branch_true := '1';
            next_is_dslot := '1';          --������һ��ָ�����ӳٲ���
      when EXE_J_OP | EXE_JAL_OP =>
            jump_target := temp(31 downto 28) & r.e.inst(25 downto 0) & "00";
            jump_branch_true := '1';
            next_is_dslot := '1';            
      when others =>
    end case;
  end;

begin
  

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
----------------------------      process comb         ----------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

  comb : process( dmem_rdata, imem_data, rf_i, r, rst, HI, LO, div_result_ready, div_result)     
	  variable v 	: registers;
	  variable ex_logic_res, ex_shift_res: word;
	  variable ex_arithmetic_res, ex_move_res: word;
	  variable ex_mul_res : std_logic_vector(63 downto 0);
    variable newhilo, hilo_temp : std_logic_vector(63 downto 0);	  	  	  
	  variable ex_result: word;
	  variable ex_opdata1,ex_opdata2 : word;
    variable cnt_temp : std_logic_vector(1 downto 0);
    variable overflow, notmove : boolean;
    variable ex_stall_for_multicycle_inst: std_logic;   
    variable start_div_temp, signed_div_temp, annul_div_temp : std_logic;
    variable jump_branch_true: std_logic;
    variable jump_branch_res, ex_jump_target: word;         
  begin

    v := r; 

-----------------------------------------------------------------------
-- WRITE BACK STAGE
-----------------------------------------------------------------------
    --��������������Regfile��д����
    rf_o.wdata <= r.w.result; 
	  rf_o.waddr <= r.w.waddr;
    rf_o.wren <= r.w.wreg; 
    
-----------------------------------------------------------------------
-- MEMORY STAGE
-----------------------------------------------------------------------

    --��Regfile��д�źŴ��ݵ���д�׶�
    v.w.result := r.m.result;
	  v.w.waddr  := r.m.waddr;
	  v.w.wreg   := r.m.wreg;
	  
	  --��HI��LO��д�źŴ��ݵ���д�׶�
	  v.w.whilo  := r.m.whilo;
	  v.w.hilo   := r.m.hilo; 	  
	     
-----------------------------------------------------------------------
-- EXECUTE STAGE
-----------------------------------------------------------------------
    --madd��maddu��msub��msubuָ����Ҫ��HI��LO�Ĵ�����ֵ���㣬�˴�����
    --����get_new_hilo�õ����µ�HI��Lo�Ĵ�����ֵ
    newhilo := get_new_hilo(r,v,HI,LO);

    --������ѡ�������������ǼĴ�����ֵ
    opdata_select(r, v, ex_opdata1, ex_opdata2);
    
    div_opdata1 <= ex_opdata1;
	  div_opdata2 <= ex_opdata2;
    
    --��ô�׶δ���Ҫд��Ŀ�ļĴ������Ƿ�Ҫд��Ŀ�ļĴ���
    v.m.waddr := r.e.rd;
    v.m.wreg := r.e.wreg;    
   
    --���ù���logic_op�����߼����㣬����洢��ex_logic_res��
    logic_op(r, ex_opdata1, ex_opdata2, ex_logic_res);

    --���ù���shift_op������λ���㣬����洢��ex_shift_res��
    shift_op(r, ex_opdata1, ex_opdata2, ex_shift_res);

    --���ù���arithmetic_op�����������㣬����洢��ex_arithmetic_op��
    arithmetic_op(r, ex_opdata1, ex_opdata2, ex_arithmetic_res, overflow);
    
    --����add\addi\subָ�����������������ô���޸�Ŀ�ļĴ��� 
    if(overflow = true) then
      v.m.wreg := '0';
    end if;

    --���ù���mul_op���г˷����㣬����洢��ex_mul_res��
    mul_op(r, ex_opdata1, ex_opdata2, ex_mul_res);

    --���ù���move_op�����ƶ�������ָ���ִ�У�����洢��ex_move_res��
    move_op(r, ex_opdata1, ex_opdata2, newhilo, ex_move_res, notmove);
    
    --����movn\movzָ�������������㣬��ônotmoveΪtrue����ʾ���޸�Ŀ�ļĴ���
    --��������v.m.wregΪ0
    if(notmove = true) then
      v.m.wreg := '0';
    end if;

    --���ù���jump_branch_op���ж��Ƿ���Ҫת�ƣ�ת�Ƶ�Ŀ���ַ��Ҫд��r31��ֵ
    jump_branch_op(r, ex_opdata1, ex_opdata2, jump_branch_res, 
                   ex_jump_target, jump_branch_true, v.e.dslot);
    
    --���ù���alu_select�����ݲ������ͣ�ѡ���Ӧ���������洢��ex_result��
    alu_select(r, ex_logic_res, ex_shift_res, ex_arithmetic_res, ex_move_res, ex_mul_res,
               jump_branch_res, ex_result);      
    
    --�����յ����������ݵ��ô�׶�
    v.m.result := ex_result;

    --���ݳ˷�����������µ�hilo��whilo��ֵ���Լ�cnt��ֵ
    set_new_hilo(r, v,  ex_opdata1, ex_opdata2, ex_mul_res, newhilo, hilo_temp, v.m.hilo, v.m.whilo, cnt_temp,
                  start_div_temp, signed_div_temp, annul_div_temp );   
    
    annul_div <= annul_div_temp;
    start_div <= start_div_temp;
	  signed_div <= signed_div_temp;
    
    if(r.e.cnt /= "00") then     --��inst_decode����������ָ������r.e.cnt��ֵ
	    ex_stall_for_multicycle_inst := '1';     --���ڶ�����ָ����ø�ֵΪ"1"����ʾ��ˮ����Ϊ
	                                             --������ָ�����ͣ
	    v.m.whilo := '0';
	    v.m.wreg := '0';
	  else
	    ex_stall_for_multicycle_inst := '0';
    end if; 
-----------------------------------------------------------------------
-- DECODE STAGE
-----------------------------------------------------------------------
    --���ù���inst_decode
	  inst_decode(r.d.inst, v.e.wreg, v.e.rd, v.e.aluop, v.e.alusel,
	              v.e.rfe1, v.e.rfe2, v.e.rfa1, v.e.rfa2, v.e.imm, v.e.cnt, v.e.inst_valid);
  
    --����������������Regfile�ķ����ź�
    rf_o.raddr1 <= v.e.rfa1;   --��һ���Ĵ����Ķ���ַ
	  rf_o.raddr2 <= v.e.rfa2;   --�ڶ����Ĵ����Ķ���ַ                    
    rf_o.ren1 <= v.e.rfe1;     --��һ���Ĵ����Ķ�ʹ���ź�
    rf_o.ren2 <= v.e.rfe2;     --�ڶ����Ĵ����Ķ�ʹ���ź�

    v.e.inst := r.d.inst;
    v.e.pc := r.d.pc;

    --����Regfile�ж�ȡ���ļĴ���ֵ�����ݵ�ִ�н׶�
    v.e.reg1 := rf_i.data1;    --�����ĵ�һ���Ĵ�����ֵ
    v.e.reg2 := rf_i.data2;    --�����ĵڶ����Ĵ�����ֵ
    
-----------------------------------------------------------------------
-- FETCH STAGE
-----------------------------------------------------------------------
    
    --����imem�Ķ�ȡ��ַ
    imem_addr <= r.f.pc(31 downto 2) & "00";
    
    --����imem�ж�ȡ��ָ��浽v.d.inst�У���һ��ʱ�����ڽ�������׶�           
    v.d.inst := imem_data;
    v.d.pc := r.f.pc;
   
    if (rst = '1') then                           
      v.f.pc := "000000000000000000000000000000"; 
    elsif(ex_stall_for_multicycle_inst = '1') then
      --���������ִ�н׶ε��Ƕ�����ָ���ô���ı�pc��ֵ
      v.f.pc := r.f.pc;      
    elsif(jump_branch_true = '1') then  
      --ִ�н׶���ת��ָ������µ�pcֵ��ͬʱ����ȡָ�׶ε�ָ��ΪNOP    
      v.f.pc := ex_jump_target(31 downto 2);
      v.d.inst := zero32;          
    else
      --��һ��ָ���ǵ�ǰ��ȡָ���ַ��4
      v.f.pc := r.f.pc(31 downto 2) + 1;  
    end if;
   

    
-----------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------    
    --���������ִ�н׶εĶ�����ָ���ô�����ָ��Ĳ��������ô桢
    --��д�׶ε�ָ����Լ�����ǰ��ת��ͬʱ����ִ�н׶�ָ��������HI��Lo
    --��ֵ���Լ�cnt��ֵ���Զ�����ָ����ԣ�ÿִ��һ�����ڣ�cnt��ֵ��1��
    --cntΪ0��ʾ��ǰ�Ƕ�����ָ������һ�����ڣ�
    if(ex_stall_for_multicycle_inst = '1') then
      rin.e.reg1 <= ex_opdata1;
      rin.e.reg2 <= ex_opdata2;    
      rin <= r;
      rin.e.cnt <= cnt_temp;        
      rin.e.hilo <= hilo_temp;
      rin.m <= v.m;                   --�ô�׶μ�����ǰ��ת
      rin.w <= v.w;                   --��д�׶μ�����ǰ��ת
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
      r.m.waddr <= (others => '0');
      r.m.wreg <= '0';
      r.m.result <= zero32;		
      r.m.whilo <= '0';
      r.m.hilo <= (others => '0');      				
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
			r.d.pc <= (others => '0');
			r.d.inst <= zero32;					
			r.f.pc <= "000000000000000000000000000000";		
			HI <= (others => '0');
			LO <= (others => '0');				
	   else
		   r <= rin;	
		   if(r.w.whilo = '1') then
		      HI <= r.w.hilo(63 downto 32);
		      LO <= r.w.hilo(31 downto 0);
		   end if;		   	    
      end if;		  
    end if;
  end process;

end;