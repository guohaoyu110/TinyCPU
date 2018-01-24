--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 13.4
--  \   \         Application : sch2hdl
--  /   /         Filename : pro11.vhf
-- /___/   /\     Timestamp : 11/10/2017 13:03:18
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Documents and Settings/pro11/pro11.vhf" -w "C:/Documents and Settings/pro11/pro11.sch"
--Design Name: pro11
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

entity pro11 is
   port ( clk     : in    std_logic; 
          en_n    : in    std_logic; 
          gwe     : in    std_logic; 
          oen     : in    std_logic; 
          oen_n   : in    std_logic; 
          we1     : in    std_logic; 
          we2     : in    std_logic; 
          XLXN_12 : in    std_logic_vector (7 downto 0); 
          XLXN_13 : out   std_logic_vector (7 downto 0); 
          XLXN_15 : out   std_logic_vector (7 downto 0));
end pro11;

architecture BEHAVIORAL of pro11 is
   attribute BOX_TYPE   : string ;
   signal XLXN_1                     : std_logic_vector (7 downto 0);
   signal XLXN_4                     : std_logic_vector (7 downto 0);
   signal XLXN_5                     : std_logic_vector (7 downto 0);
   signal XLXN_7                     : std_logic_vector (7 downto 0);
   signal XLXN_8                     : std_logic;
   signal XLXI_4_data_in3_openSignal : std_logic_vector (7 downto 0);
   signal XLXI_4_data_in4_openSignal : std_logic_vector (7 downto 0);
   component reg_74244
      port ( oen  : in    std_logic; 
             Din  : in    std_logic_vector (7 downto 0); 
             Qout : out   std_logic_vector (7 downto 0));
   end component;
   
   component reg_74377
      port ( clk  : in    std_logic; 
             en_n : in    std_logic; 
             Din  : in    std_logic_vector (7 downto 0); 
             Qout : out   std_logic_vector (7 downto 0));
   end component;
   
   component reg_74373
      port ( clk   : in    std_logic; 
             gwe   : in    std_logic; 
             oen_n : in    std_logic; 
             Din   : in    std_logic_vector (7 downto 0); 
             Qout  : out   std_logic_vector (7 downto 0));
   end component;
   
   component data_bus
      port ( clk       : in    std_logic; 
             data_in1  : in    std_logic_vector (7 downto 0); 
             data_out4 : out   std_logic_vector (7 downto 0); 
             data_out3 : out   std_logic_vector (7 downto 0); 
             data_out2 : out   std_logic_vector (7 downto 0); 
             data_out1 : out   std_logic_vector (7 downto 0); 
             we_io2    : in    std_logic; 
             we_io1    : in    std_logic; 
             we4       : in    std_logic; 
             we3       : in    std_logic; 
             data_in2  : in    std_logic_vector (7 downto 0); 
             data_in3  : in    std_logic_vector (7 downto 0); 
             data_in4  : in    std_logic_vector (7 downto 0); 
             we2       : in    std_logic; 
             we1       : in    std_logic; 
             data_io2  : inout std_logic_vector (7 downto 0); 
             data_io1  : inout std_logic_vector (7 downto 0));
   end component;
   
   component GND
      port ( G : out   std_logic);
   end component;
   attribute BOX_TYPE of GND : component is "BLACK_BOX";
   
begin
   XLXI_1 : reg_74244
      port map (Din(7 downto 0)=>XLXN_12(7 downto 0),
                oen=>oen,
                Qout(7 downto 0)=>XLXN_1(7 downto 0));
   
   XLXI_2 : reg_74377
      port map (clk=>clk,
                Din(7 downto 0)=>XLXN_4(7 downto 0),
                en_n=>en_n,
                Qout(7 downto 0)=>XLXN_13(7 downto 0));
   
   XLXI_3 : reg_74373
      port map (clk=>clk,
                Din(7 downto 0)=>XLXN_5(7 downto 0),
                gwe=>gwe,
                oen_n=>oen_n,
                Qout(7 downto 0)=>XLXN_7(7 downto 0));
   
   XLXI_4 : data_bus
      port map (clk=>clk,
                data_in1(7 downto 0)=>XLXN_1(7 downto 0),
                data_in2(7 downto 0)=>XLXN_7(7 downto 0),
                data_in3(7 downto 0)=>XLXI_4_data_in3_openSignal(7 downto 0),
                data_in4(7 downto 0)=>XLXI_4_data_in4_openSignal(7 downto 0),
                we_io1=>XLXN_8,
                we_io2=>XLXN_8,
                we1=>we1,
                we2=>we2,
                we3=>XLXN_8,
                we4=>XLXN_8,
                data_out1(7 downto 0)=>XLXN_4(7 downto 0),
                data_out2(7 downto 0)=>XLXN_5(7 downto 0),
                data_out3(7 downto 0)=>XLXN_15(7 downto 0),
                data_out4=>open,
                data_io1=>open,
                data_io2=>open);
   
   XLXI_5 : GND
      port map (G=>XLXN_8);
   
end BEHAVIORAL;


