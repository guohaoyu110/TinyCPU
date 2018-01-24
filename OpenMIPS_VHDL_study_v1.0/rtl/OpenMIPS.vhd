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
-- Entity:  OpenMIPS
-- File:    OpenMIPS.vhd
-- Author:  Lei Silei
-- Description: Top-level OpenMIPS component
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use WORK.stdlib.all;
use WORK.all;

entity OpenMIPS is
  port (
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
end; 

architecture rtl of OpenMIPS is

	signal rf_i: iregfile_in_type;
	signal rf_o: iregfile_out_type;
	signal start_div, div_result_ready, signed_div, annul_div: std_logic;
	signal opdata1, opdata2: word;
	signal div_result: std_logic_vector(63 downto 0);   

	component iu   port (
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
     div_opdata1,div_opdata2 : out word;
     int_i : in std_logic_vector(7 downto 0);
     SI_TimerInt : out std_logic     		 
		 );
	end component;

	component regfile   port (
		 clk   : in  std_logic;
		 rst   : in  std_logic;
		 waddr  : in  std_logic_vector(4 downto 0);
		 wdata  : in  word;
		 we     : in  std_logic;
		 raddr1 : in  std_logic_vector(4 downto 0);
		 re1    : in  std_logic;
		 rdata1 : out word;
		 raddr2 : in  std_logic_vector(4 downto 0);
		 re2    : in  std_logic;
		 rdata2 : out word
	  );
	end component;

  component div   port (
     clk   : in  std_logic;
	   rst   : in  std_logic;
	   signed_div : in std_logic;
     opdata1  : in  word;
     opdata2  : in  word;
     start    : in  std_logic;
     annul  : in std_logic;
     result : out  std_logic_vector(63 downto 0);
     ready  : out std_logic
  );	
  end component;
  
begin
    

     iu0 : iu port map (clk, rst, imem_addr, imem_data, dmem_addr, dmem_we, dmem_wdata,
                        dmem_rdata, dmem_sel, rf_i, rf_o, signed_div, start_div, 
                        annul_div, div_result, div_result_ready, opdata1, opdata2, int_i, SI_Timerint );
  
     rf0 : regfile port map (clk, rst,
	                            rf_i.waddr,  rf_i.wdata, rf_i.wren, 
                               rf_i.raddr1, rf_i.ren1,  rf_o.data1, 
                               rf_i.raddr2, rf_i.ren2,  rf_o.data2);

     div0 : div port map (clk, rst, signed_div, opdata1, opdata2, start_div, annul_div,
                          div_result, div_result_ready);                          
										 
end;
