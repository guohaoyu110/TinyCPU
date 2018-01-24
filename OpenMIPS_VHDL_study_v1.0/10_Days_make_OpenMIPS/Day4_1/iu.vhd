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

  procedure alu_select(r : registers; logicout, shiftout: word; res: out word) is
	  variable aluresult : word;
	begin

	    aluresult := (others => '0');
		 case r.e.alusel is
			when EXE_RES_LOGIC => aluresult := logicout;
			when EXE_RES_SHIFT => aluresult := shiftout;
			when others => aluresult := zero32;
		 end case;
		 res := aluresult;
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
	  variable ex_result: word;
	  variable ex_opdata1,ex_opdata2 : word;
    variable cnt_temp : std_logic_vector(1 downto 0);

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
    
    --调用过程alu_select，依据操作类型，选择对应的运算结果存储到ex_result中
    alu_select(r, ex_logic_res, ex_shift_res, ex_result);      
    
    --将最终的运算结果传递到访存阶段
    v.m.result := ex_result;
    
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
      r.m.waddr <= (others => '0');
      r.m.wreg <= '0';
      r.m.result <= zero32;						
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
	   else
		   r <= rin;		    
      end if;		  
    end if;
  end process;

end;
