------------------------------------------------------------------------------
-- Entity:  regfile
-- File:    regfile.vhd
-- Author:  Lei Silei
-- Description: register file
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use WORK.stdlib.all;
use WORK.all;

entity regfile is
  port (
    clk   : in  std_logic;
	  rst   : in  std_logic;
    waddr  : in  std_logic_vector(4 downto 0);
    wdata  : in  std_logic_vector(31 downto 0);
    we     : in  std_logic;
    raddr1 : in  std_logic_vector(4 downto 0);
    re1    : in  std_logic;
    rdata1 : out std_logic_vector(31 downto 0);
    raddr2 : in  std_logic_vector(4 downto 0);
    re2    : in  std_logic;
    rdata2 : out std_logic_vector(31 downto 0)
  );
end;

architecture rtl of regfile is
  type mem is array(0 to 31) of std_logic_vector(31 downto 0);
  signal regarr : mem;
begin


  process(clk)
  begin
    if rising_edge(clk) then       
      if(rst /= '1') then              
	      if (we = '1') and (waddr /= "00000") then
	        --如果是写操作，且目的地址不是r0
		      regarr(conv_integer(waddr)) <= wdata; 
		    end if;
      end if;
    end if;
  end process;

  --根据raddr1的值，给出读操作的寄存器1的值
  rdata1 <= (others => '0') when raddr1 = "00000" else
            wdata           when raddr1 = waddr and re1 = '1' and we = '1' else
            regarr(conv_integer(raddr1)) when re1 = '1' else
            (others => '0');
            
  --根据raddr2的值，给出读操作的寄存器2的值
  rdata2 <= (others => '0') when raddr2 = "00000" else
            wdata           when raddr2 = waddr and re2 = '1' and we = '1' else 
            regarr(conv_integer(raddr2)) when re2 = '1' else
            (others => '0');

end;