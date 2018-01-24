------------------------------------------------------------------------------
-- Entity:  OpenMIPS_min_sopc
-- File:    OpenMIPS_min_sopc.vhd
-- Author:  Lei Silei
-- Description:  OpenMIPS + memory
------------------------------------------------------------------------------

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
    
    
   
     OpenMIPS0 : OpenMIPS port map (clk, rst, imem_addr, imem_data, dmem_addr, dmem_we, dmem_wdata,
                                    dmem_rdata, dmem_sel, timerint);
	  
     imem0 : imem port map ( rst, imem_addr, imem_data);
     
     dmem0 : dmem port map ( clk, rst, dmem_we, dmem_sel, dmem_addr, dmem_wdata, dmem_rdata );


end;