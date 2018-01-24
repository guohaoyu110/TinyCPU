--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 13.4
--  \   \         Application : sch2hdl
--  /   /         Filename : ab.vhf
-- /___/   /\     Timestamp : 01/11/2018 12:12:06
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: sch2hdl -intstyle ise -family spartan6 -flat -suppress -vhdl "C:/Documents and Settings/zx/ab.vhf" -w "C:/Documents and Settings/zx/ab.sch"
--Design Name: ab
--Device: spartan6
--Purpose:
--    This vhdl netlist is translated from an ECS schematic. It can be 
--    synthesized and simulated, but it should not be modified. 
--
----- CELL CB4CE_HXILINX_ab -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CB4CE_HXILINX_ab is
  
port (
    CEO  : out STD_LOGIC;
    Q0   : out STD_LOGIC;
    Q1   : out STD_LOGIC;
    Q2   : out STD_LOGIC;
    Q3   : out STD_LOGIC;
    TC   : out STD_LOGIC;
    C    : in STD_LOGIC;
    CE   : in STD_LOGIC;
    CLR  : in STD_LOGIC
    );
end CB4CE_HXILINX_ab;

architecture Behavioral of CB4CE_HXILINX_ab is

  signal COUNT : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
  constant TERMINAL_COUNT : STD_LOGIC_VECTOR(3 downto 0) := (others => '1');
  
begin

process(C, CLR)
begin
  if (CLR='1') then
    COUNT <= (others => '0');
  elsif (C'event and C = '1') then
    if (CE='1') then 
      COUNT <= COUNT+1;
    end if;
  end if;
end process;

TC   <=  '0' when (CLR = '1') else
         '1' when (COUNT = TERMINAL_COUNT) else '0';
CEO  <= '1' when ((COUNT = TERMINAL_COUNT) and CE='1') else '0';

Q3 <= COUNT(3);
Q2 <= COUNT(2);
Q1 <= COUNT(1);
Q0 <= COUNT(0);

end Behavioral;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ab is
   port ( ce  : in    std_logic; 
          clk : in    std_logic; 
          rst : in    std_logic; 
          c1  : out   std_logic; 
          c2  : out   std_logic; 
          c3  : out   std_logic; 
          c4  : out   std_logic; 
          c5  : out   std_logic; 
          c6  : out   std_logic; 
          c7  : out   std_logic; 
          c8  : out   std_logic; 
          c9  : out   std_logic; 
          c10 : out   std_logic);
end ab;

architecture BEHAVIORAL of ab is
   attribute HU_SET     : string ;
   signal XLXN_14 : std_logic;
   signal XLXN_16 : std_logic;
   signal XLXN_17 : std_logic;
   signal XLXN_18 : std_logic;
   component myrom
      port ( s0  : in    std_logic; 
             s1  : in    std_logic; 
             s2  : in    std_logic; 
             c1  : out   std_logic; 
             c2  : out   std_logic; 
             c3  : out   std_logic; 
             c4  : out   std_logic; 
             c5  : out   std_logic; 
             c6  : out   std_logic; 
             c7  : out   std_logic; 
             c8  : out   std_logic; 
             c9  : out   std_logic; 
             c10 : out   std_logic);
   end component;
   
   component CB4CE_HXILINX_ab
      port ( C   : in    std_logic; 
             CE  : in    std_logic; 
             CLR : in    std_logic; 
             CEO : out   std_logic; 
             Q0  : out   std_logic; 
             Q1  : out   std_logic; 
             Q2  : out   std_logic; 
             Q3  : out   std_logic; 
             TC  : out   std_logic);
   end component;
   
   component clock_divider
      port ( clk_in   : in    std_logic; 
             rst      : in    std_logic; 
             clk_1Hz  : out   std_logic; 
             clk_5Hz  : out   std_logic; 
             clk_10Hz : out   std_logic; 
             clk_1KHz : out   std_logic; 
             clk_1MHz : out   std_logic);
   end component;
   
   attribute HU_SET of XLXI_2 : label is "XLXI_2_0";
begin
   XLXI_1 : myrom
      port map (s0=>XLXN_16,
                s1=>XLXN_17,
                s2=>XLXN_18,
                c1=>c1,
                c2=>c2,
                c3=>c3,
                c4=>c4,
                c5=>c5,
                c6=>c6,
                c7=>c7,
                c8=>c8,
                c9=>c9,
                c10=>c10);
   
   XLXI_2 : CB4CE_HXILINX_ab
      port map (C=>XLXN_14,
                CE=>ce,
                CLR=>rst,
                CEO=>open,
                Q0=>XLXN_16,
                Q1=>XLXN_17,
                Q2=>XLXN_18,
                Q3=>open,
                TC=>open);
   
   XLXI_3 : clock_divider
      port map (clk_in=>clk,
                rst=>rst,
                clk_1Hz=>XLXN_14,
                clk_1KHz=>open,
                clk_1MHz=>open,
                clk_5Hz=>open,
                clk_10Hz=>open);
   
end BEHAVIORAL;


