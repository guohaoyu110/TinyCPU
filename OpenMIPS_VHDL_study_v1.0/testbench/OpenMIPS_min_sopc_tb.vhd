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
-- Entity:  OpenMIPS_min_sopc_tb
-- File:    OpenMIPS_min_sopc_tb.vhd
-- Author:  Lei Silei
-- Description: OpenMIPS_min_sopc TestBench
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use WORK.stdlib.all;
use WORK.all;

entity OpenMIPS_min_sopc_tb is end; 

architecture rtl of OpenMIPS_min_sopc_tb is

constant cycle : Time := 10 ns;
signal rst,clk : std_logic;
signal int_i : std_logic_vector(7 downto 0);


component OpenMIPS_min_sopc port (
    clk    : in  std_logic;
    rst   : in  std_logic
--    int_i : in std_logic_vector(7 downto 0)
  );
end component;


begin

process 
variable count : integer;
begin
  clk <= '0';
  rst <= '1';
  count := 0;
  int_i <= (others => '0');
  wait for cycle;
--  rst <= '0';
  while count < 1000 loop
    clk <= '1';
	 wait for cycle/2;
	 clk <= '0';
	 wait for cycle/2;
	 	 if(count = 0) then
	    rst <= '0';
	  end if;
	  count := count + 1;
	end loop;
	wait;
end process;

OpenMIPS_min_sopc0 : OpenMIPS_min_sopc port map (clk , rst );

										 
end;