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
-- Entity:  OpenMIPS_min_sopc
-- File:    OpenMIPS_min_sopc.vhd
-- Author:  Lei Silei
-- Description:  OpenMIPS + memory
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.stdlib.all;
use WORK.all;

entity OpenMIPS_min_sopc is
  port (
    clk    : in  std_logic;
    rst   : in  std_logic
  );
end;

architecture rtl of OpenMIPS_min_sopc is

   signal imem_addr : word;
   signal imem_data : word;
   signal dmem_addr : word;
   signal dmem_we : std_logic;
   signal dmem_wdata : word;
   signal dmem_rdata : word;
   signal dmem_sel  : std_logic_vector(3 downto 0);
	 signal timerint     : std_logic;  
   signal interrupt    : std_logic_vector(7 downto 0);	  

  component OpenMIPS port(
    clk    : in  std_logic;
    rst   : in  std_logic;
    imem_addr : out word;
    imem_data : in  word;
    dmem_addr : out word;
    dmem_we : out std_logic;
    dmem_wdata : out word;
    dmem_rdata : in word;
    dmem_sel  : out std_logic_vector(3 downto 0);
    int_i : in std_logic_vector(7 downto 0);
    SI_TimerInt : out std_logic    
  );
  end component;
  
  component imem port (
    rst   : in  std_logic;
	  addr  : in  word;
	  data  : out word
	);
	end component;
	
	component dmem port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    we    : in  std_logic;
    sel   : in  std_logic_vector(3 downto 0);
	  addr  : in  word;
	  data_i  : in  word;
	  data_o  : out word
	);
	end component;
  
begin
    
     interrupt <= "00000" & timerint & '0' & '0';
   
     OpenMIPS0 : OpenMIPS port map (clk, rst, imem_addr, imem_data, dmem_addr, dmem_we, dmem_wdata,
                                    dmem_rdata, dmem_sel, interrupt, timerint);
	  
     imem0 : imem port map ( rst, imem_addr, imem_data);
     
     dmem0 : dmem port map ( clk, rst, dmem_we, dmem_sel, dmem_addr, dmem_wdata, dmem_rdata );


end;