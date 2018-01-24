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
-- Entity:  div
-- File:    div.vhd
-- Author:  Lei Silei
-- Description: execute divide operation
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use WORK.stdlib.all;
use WORK.all;

entity div is
  port (
    clk   : in  std_logic;
	  rst   : in  std_logic;
	  signed_div : in std_logic;   --�Ƿ����з��ų���
    opdata1  : in  word;         --������
    opdata2  : in  word;         --����
    start    : in  std_logic;    --�Ƿ�ʼ��������
    annul  : in std_logic;       --�Ƿ�ȡ����������
    result : out  std_logic_vector(63 downto 0);  --��������������32bit����������32bit����
    ready  : out std_logic       --���������Ƿ����
  );
end;

architecture rtl of div is

  --ʵ�ֳ�����������Ҫ��һ��״̬��
  type divide_state is (free, divide_by_zero, divide_on, result_ready);
  signal state : divide_state;
  signal cnt : integer range 0 to 32;
  signal div_temp : std_logic_vector(32 downto 0);
  signal dividend : std_logic_vector(64 downto 0); 
  signal divisor : std_logic_vector(31 downto 0);
begin
    
    div_temp <= ('0' & dividend(63 downto 32)) - ('0' & divisor);
    
    process(clk)
      variable temp_op1,temp_op2 : word;
    begin
       if(rising_edge(clk)) then
          if(rst = '1') then
            result <= (others => '0');
            ready <= '0';
            state <= free;
          else
            case state is
              when free =>                      --free״̬
                if(start = '1' and annul = '0') then
                  if(opdata2 = zero32) then
                    state <= divide_by_zero;
                  else
                    state <= divide_on;
                    cnt <= 0;
                    if(signed_div = '1' and opdata1(31) = '1') then
                      temp_op1 := (not opdata1) + 1;
                    else
                      temp_op1 := opdata1;
                    end if;
                    if(signed_div = '1' and opdata2(31) = '1') then
                      temp_op2 := (not opdata2) + 1;
                    else
                      temp_op2 := opdata2;
                    end if;
                    dividend <= (others => '0');
                    dividend(32 downto 1) <= temp_op1;
                    divisor <= temp_op2;
                  end if;
                else
                  ready <= '0';
                end if;
              when divide_by_zero =>            --divide_by_zero״̬
                dividend <= (others => '1');
                state <= result_ready;
              when divide_on =>                 --divide_on״̬��ʹ�����̷����г�������
                if(annul = '0') then  
                if(cnt /= 32) then
                  if(div_temp(32) = '1') then
                    dividend <= dividend(63 downto 0) & '0';
                  else
                    dividend <= div_temp(31 downto 0) & dividend(31 downto 0) & '1';
                  end if;
                  cnt <= cnt + 1;
                else
                  if(signed_div = '1' and (opdata1(31) xor opdata2(31)) = '1') then
                    dividend(31 downto 0) <= (not dividend(31 downto 0) + 1);
                  end if;
                  if(signed_div = '1' and (opdata1(31) xor dividend(64)) = '1') then  --����Ҫ�뱻����ͬ��
                      dividend(64 downto 33) <= (not dividend(64 downto 33) + 1);
                    end if;
                  state <= result_ready;
                  cnt <= 0;
                end if;
                else
                 state <= free;
               end if;
              when result_ready =>              --�������������������洢�ְ�result�У�ͬʱ��readyΪ1
                result <= dividend(64 downto 33) & dividend(31 downto 0);  --ע�������Ǹ�32λ��������32-63bit
                ready <= '1';
                if(start = '0') then
                  state <= free;
                end if;
            end case;
         end if;
       end if;
    end process;

end;