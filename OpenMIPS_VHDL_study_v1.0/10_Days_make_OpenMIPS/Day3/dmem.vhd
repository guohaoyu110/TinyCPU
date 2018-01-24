------------------------------------------------------------------------------
-- Entity:  dmem
-- File:    dmem.vhd
-- Author:  Lei Silei
-- Description: Data Memory
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use WORK.stdlib.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity dmem is
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    we    : in  std_logic;
    sel   : in  std_logic_vector(3 downto 0);
	  addr  : in  word;
	  data_i  : in  word;
	  data_o  : out word
  );
end; 

architecture rtl of dmem is

  --定义4个8位存储器
	TYPE mem is ARRAY (DMEMSIZEINWORD downto 0) of std_logic_vector(7 downto 0);
	signal mem0, mem1, mem2, mem3: mem;
begin
   
  
   process(clk) 
		variable temp: integer range 0 to DMEMSIZEINWORD;
	  begin
	  if rising_edge(clk) then
       if (rst='0') then 
	       temp := conv_integer(addr(DMEMBIT+2 downto 2));
	       if(we = '1') then
	         --如果是写操作，那么依据sel的值确定要写入的字节
	         if(sel(3) = '1') then
	            mem0(temp) <= data_i(31 downto 24);
	         end if;
	         if(sel(2) = '1') then
	            mem1(temp) <= data_i(23 downto 16);
	         end if;
	         if(sel(1) = '1') then
	            mem2(temp) <= data_i(15 downto 8);
	         end if;
	         if(sel(0) = '1') then
	            mem3(temp) <= data_i(7 downto 0);
	         end if;
        end if;
       end if;       
	  end if;
	  end process;
	  
	  process(rst, we, addr)
	    variable temp: integer range 0 to DMEMSIZEINWORD;
	  begin
	    if(rst = '1') then
	      data_o <= (others => '0');
	    elsif(we = '0') then
	      --读操作是异步的，注意地址的低2bit没有使用
	      temp := conv_integer(addr(DMEMBIT+2 downto 2));
	      data_o <= mem0(temp) & mem1(temp) & mem2(temp) & mem3(temp);
	    else
	      data_o <= (others => '0');
	    end if;
	  end process;
end;
