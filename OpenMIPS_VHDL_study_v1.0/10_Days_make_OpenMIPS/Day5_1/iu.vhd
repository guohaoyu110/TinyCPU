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
    rf_i   : in  iregfile_out_type
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
			when EXE_SPECIAL2_INST =>
			    case op3 is 
			      when EXE_CLZ   => rfe1 := '1'; rfe2 := '0'; wreg :='1'; aluop := EXE_CLZ_OP;   alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
					  when EXE_CLO   => rfe1 := '1'; rfe2 := '0'; wreg :='1'; aluop := EXE_CLO_OP;   alusel := EXE_RES_ARITHMETIC; inst_valid := '1';
            when EXE_MUL   => rfe1 := '1'; rfe2 := '1'; wreg :='1'; aluop := EXE_MUL_OP;   alusel := EXE_RES_MUL; inst_valid := '1';
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
	     opdata1 := r.e.imm;                            --源操作数是立即数
     elsif (r.m.waddr = r.e.rfa1 and r.m.wreg = '1' and r.e.rfe1 = '1') then  
       opdata1 := r.m.result;                     --与上一条指令存在数据相关
     elsif (r.w.waddr = r.e.rfa1 and r.w.wreg = '1' and r.e.rfe1 = '1') then
       opdata1 := r.w.result;                     --与上上一条指令存在数据相关
     else     
       opdata1 := r.e.reg1;                     --不存在数据相关
     end if;
     
     if r.e.rfe2='0' then
	     opdata2 := r.e.imm;                            --源操作数是立即数
     elsif (r.m.waddr = r.e.rfa2 and r.m.wreg = '1' and r.e.rfe2 = '1' ) then  
       opdata2 := r.m.result;                     --与上一条指令存在数据相关
     elsif (r.w.waddr = r.e.rfa2 and r.w.wreg = '1' and r.e.rfe2 = '1' ) then
       opdata2 := r.w.result;                     --与上上一条指令存在数据相关
     else     
       opdata2 := r.e.reg2;                     --不存在数据相关
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
	    if((r.e.aluop = EXE_MUL_OP or r.e.aluop = EXE_MULT_OP )
	        and aluin1(31) = '1') then
	       opdata1 := (not aluin1) + 1;    --将有符号数转化为无符号数进行运算
	    else 
	       opdata1 := aluin1;
	    end if;
	     
	    if((r.e.aluop = EXE_MUL_OP or r.e.aluop = EXE_MULT_OP )
	        and aluin2(31) = '1') then
	       opdata2 := (not aluin2) + 1;    --将有符号数转化为无符号数进行运算
	    else 
	       opdata2 := aluin2;
      end if;
       
      mulout := opdata1 * opdata2;
          
		 case r.e.aluop is
			when EXE_MUL_OP | EXE_MULT_OP => 
			     if((aluin1(31) xor aluin2(31)) = '1') then  --有符号乘法，且积为负
			       mulout := (not mulout) + 1;
			     end if;
			when others => 
		 end case;
		 mulres := mulout;
  end;

  procedure alu_select(r : registers; logicout, shiftout, arithmeticres: word; mulres: std_logic_vector(63 downto 0);
                       res: out word) is
	  variable aluresult : word;
	begin

	    aluresult := (others => '0');
		 case r.e.alusel is
			when EXE_RES_LOGIC => aluresult := logicout;
			when EXE_RES_SHIFT => aluresult := shiftout;
			when EXE_RES_ARITHMETIC => aluresult := arithmeticres;
			when EXE_RES_MUL => aluresult := mulres(31 downto 0);						
			when others => aluresult := zero32;
		 end case;
		 res := aluresult;
  end;

  procedure set_new_hilo(r, v: registers; mul_res: in std_logic_vector(63 downto 0);
               hilo: out std_logic_vector(63 downto 0); whilo: out std_logic ) is
  begin
    hilo := (others => '0');
    whilo := '0';
    
    --mult\multu指令将乘法结果存放在HI、LO寄存器，所以设置whilo为1，hilo为乘法结果
    if((r.e.aluop = EXE_MULT_OP or r.e.aluop = EXE_MULTU_OP)) then
      hilo := mul_res;
      whilo := '1';
     else
      hilo := (others => '0');
      whilo := '0';
    end if;      
  end;

begin
  

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
----------------------------      process comb         ----------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

  comb : process( dmem_rdata, imem_data, rf_i, r, rst)     
	  variable v 	: registers;
	  variable ex_logic_res, ex_shift_res: word;
	  variable ex_arithmetic_res: word;
	  variable ex_mul_res : std_logic_vector(63 downto 0);
    variable newhilo, hilo_temp : std_logic_vector(63 downto 0);	  	  	  
	  variable ex_result: word;
	  variable ex_opdata1,ex_opdata2 : word;
    variable cnt_temp : std_logic_vector(1 downto 0);
    variable overflow : boolean;
  begin

    v := r; 

-----------------------------------------------------------------------
-- WRITE BACK STAGE
-----------------------------------------------------------------------
    --依据运算结果进行Regfile的写操作
    rf_o.wdata <= r.w.result; 
	  rf_o.waddr <= r.w.waddr;
    rf_o.wren <= r.w.wreg; 
    
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
	     
-----------------------------------------------------------------------
-- EXECUTE STAGE
-----------------------------------------------------------------------

    --操作数选择，是立即数还是寄存器的值
    opdata_select(r, v, ex_opdata1, ex_opdata2);
    
    --向访存阶段传递要写的目的寄存器、是否要写入目的寄存器
    v.m.waddr := r.e.rd;
    v.m.wreg := r.e.wreg;    
   
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
    
    --调用过程alu_select，依据操作类型，选择对应的运算结果存储到ex_result中
    alu_select(r, ex_logic_res, ex_shift_res, ex_arithmetic_res, ex_mul_res, ex_result);      
    
    --将最终的运算结果传递到访存阶段
    v.m.result := ex_result;

    --依据乘法结果，给出新的hilo、whilo的值
    set_new_hilo(r, v, ex_mul_res, v.m.hilo, v.m.whilo );    
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

    --将从Regfile中读取出的寄存器值，传递到执行阶段
    v.e.reg1 := rf_i.data1;    --读出的第一个寄存器的值
    v.e.reg2 := rf_i.data2;    --读出的第二个寄存器的值
    
-----------------------------------------------------------------------
-- FETCH STAGE
-----------------------------------------------------------------------
    
    --给出imem的读取地址
    imem_addr <= r.f.pc(31 downto 2) & "00";
    
    --将从imem中读取的指令保存到v.d.inst中，在一个时钟周期进入译码阶段           
    v.d.inst := imem_data;
    v.d.pc := r.f.pc;
   
    if (rst = '1') then                           
      v.f.pc := "000000000000000000000000000000"; 
    else
      --下一条指令是当前读取指令地址加4
      v.f.pc := r.f.pc(31 downto 2) + 1;  
    end if;
   

    
-----------------------------------------------------------------------
-- OUTPUTS
-----------------------------------------------------------------------    
      rin <= v;                                                    

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
