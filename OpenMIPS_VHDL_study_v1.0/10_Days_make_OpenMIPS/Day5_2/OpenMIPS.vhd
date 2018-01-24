------------------------------------------------------------------------------
-- Entity:  OpenMIPS
-- File:    OpenMIPS.vhd
-- Author:  Lei Silei
-- Description: Top-level OpenMIPS component
------------------------------------------------------------------------------

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
    dmem_sel  : out std_logic_vector(3 downto 0)
  );
end; 

architecture rtl of OpenMIPS is

	signal rf_i: iregfile_in_type;
	signal rf_o: iregfile_out_type;
  

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
		 rf_i   : in  iregfile_out_type
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
	
 
begin
    

     iu0 : iu port map (clk, rst, imem_addr, imem_data, dmem_addr, dmem_we, dmem_wdata,
                        dmem_rdata, dmem_sel, rf_i, rf_o);
  
     rf0 : regfile port map (clk, rst,
	                            rf_i.waddr,  rf_i.wdata, rf_i.wren, 
                               rf_i.raddr1, rf_i.ren1,  rf_o.data1, 
                               rf_i.raddr2, rf_i.ren2,  rf_o.data2);
                          
										 
end;
