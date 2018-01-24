--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 13.4
--  \   \         Application : sch2hdl
--  /   /         Filename : pro1.vhf
-- /___/   /\     Timestamp : 10/13/2017 10:57:18
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Documents and Settings/pro1/pro1.vhf" -w "C:/Documents and Settings/pro1/pro1.sch"
--Design Name: pro1
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity pro1 is
   port ( A      : in    std_logic_vector (3 downto 0); 
          B      : in    std_logic_vector (3 downto 0); 
          S      : in    std_logic_vector (3 downto 0); 
          XLXN_1 : in    std_logic; 
          XLXN_2 : in    std_logic; 
          F      : out   std_logic_vector (3 downto 0); 
          XLXN_6 : out   std_logic);
end pro1;

architecture BEHAVIORAL of pro1 is
   component alu_74181
      port ( M         : in    std_logic; 
             C_n       : in    std_logic; 
             A         : in    std_logic_vector (3 downto 0); 
             B         : in    std_logic_vector (3 downto 0); 
             S         : in    std_logic_vector (3 downto 0); 
             C_n_plus4 : out   std_logic; 
             F         : out   std_logic_vector (3 downto 0));
   end component;
   
begin
   XLXI_1 : alu_74181
      port map (A(3 downto 0)=>A(3 downto 0),
                B(3 downto 0)=>B(3 downto 0),
                C_n=>XLXN_2,
                M=>XLXN_1,
                S(3 downto 0)=>S(3 downto 0),
                C_n_plus4=>XLXN_6,
                F(3 downto 0)=>F(3 downto 0));
   
end BEHAVIORAL;


