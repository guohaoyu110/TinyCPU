----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:52 02/27/2014 
-- Design Name: 
-- Module Name:    pc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- ?????????
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Program_Counter is
Port ( 
        clk : in  STD_LOGIC;
	    rst : in  std_logic;
        en : in  STD_LOGIC;
        PC_sel : in std_logic_vector(1 downto 0);
        PC_in : in STD_LOGIC_VECTOR (15 downto 0);
        PC_branch : in STD_LOGIC_VECTOR (15 downto 0);
        PC_out : out  STD_LOGIC_VECTOR (15 downto 0)
 );
end Program_Counter ;

architecture Behavioral of Program_Counter is

signal PC : std_logic_vector (15 downto 0); --:= "0000000000000000";
--PC := "0000000000000000";
begin

    PC_out <= PC;

 process (clk,rst,PC_sel)
 begin
  
  if (rst = '0') then
     PC <= (others => '0');
  elsif (clk = '1' and clk'event) then
        if (en = '1') then
            if (PC_sel = "11") then
                PC  <= PC_in;   
            elsif (PC_sel = "10") then  --JMP
                PC <= conv_std_logic_vector(conv_integer(PC) + conv_integer(PC_branch)-3,16);       
            else
               PC <= PC + '1';
            end if;
        end if;
  end if;
 end process;
end Behavioral;

