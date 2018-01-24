------------------------------------------------------------------------------
-- Entity:  OpenMIPS_min_sopc_tb
-- File:    OpenMIPS_min_sopc_tb.vhd
-- Author:  Lei Silei
-- Description: OpenMIPS_min_sopc TestBench
------------------------------------------------------------------------------

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