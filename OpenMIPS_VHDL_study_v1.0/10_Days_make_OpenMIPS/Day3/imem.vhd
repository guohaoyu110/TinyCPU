------------------------------------------------------------------------------
-- Entity:  imem
-- File:    imem.vhd
-- Author:  Lei Silei
-- Description: Instruction Memory
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use WORK.stdlib.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity imem is
  port (
    rst   : in  std_logic;
	  addr  : in  word;
	  data  : out word
  );
end; 

architecture rtl of imem is

  --�˴���IMEMSIZEINWORD����stdlib.vhd�ж����imem�Ĵ�С����λ��word��
	TYPE mem is ARRAY (IMEMSIZEINWORD downto 0) of std_logic_vector(31 downto 0);
	signal mem0: mem;
	
	--ʹ��inst_rom.data�ļ���ʼ��imem
	file f1:text is in "inst_rom.data"; 
begin

	process(rst, addr)
		variable li : line;
		variable k,i : integer;
		variable j : character;
		variable good : boolean;
		variable temp : std_logic_vector(31 downto 0);
		variable temp1: integer range 0 to IMEMSIZEINWORD;
	begin
		  if(rst='1') then
		    --�����λ�ź���Ч����ô��ȡinst_rom.data�ļ���ʼ��imem
			  k := 0;
			  while not endfile(f1) loop
				 readline(f1,li);
				 i := 0;
				 while i<8 loop
					 read(li,j,good);
					 if(good) then
						temp(31-i*4 downto 28-i*4) := conv_character_to_std_logic_vector(j);
					 end if;
					 i := i+1;
				 end loop;
				 mem0(k) <= temp;
				 k := k+1;
			  end loop;
			  data <= (others=>'0'); 
			else
			   --��λ�ź���Ч��ʱ�����������ȡ�����ݵ�ַ����ָ��
			   --ע����ǵ�ַ�������λ����
	       temp1 := conv_integer(addr(IMEMBIT+2 downto 2));
		     data <= mem0(temp1);	
		  end if;

	end process; 
    
end;