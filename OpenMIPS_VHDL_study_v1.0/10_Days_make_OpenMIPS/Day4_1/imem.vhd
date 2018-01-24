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

  --此处的IMEMSIZEINWORD是在stdlib.vhd中定义的imem的大小（单位是word）
	TYPE mem is ARRAY (IMEMSIZEINWORD downto 0) of std_logic_vector(31 downto 0);
	signal mem0: mem;
	
	--使用inst_rom.data文件初始化imem
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
		    --如果复位信号有效，那么读取inst_rom.data文件初始化imem
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
			   --复位信号无效的时候就是正常读取，依据地址给出指令
			   --注意的是地址的最低两位不用
	       temp1 := conv_integer(addr(IMEMBIT+2 downto 2));
		     data <= mem0(temp1);	
		  end if;

	end process; 
    
end;