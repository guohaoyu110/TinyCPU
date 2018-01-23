----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:48 03/08/2013 
-- Design Name: 
-- Module Name:    reg_74373 - Behavioral 
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
-- 通用寄存器 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Regsfile is
    Port (
	   clk : in  STD_LOGIC;
	   rst : in  std_logic;
	   DR_in : in STD_LOGIC_VECTOR (15 downto 0);	
	   DR_en : in std_logic;
	   R0_en : in std_logic;
	   R1_en : in std_logic;
	   R2_en : in std_logic;
	   R3_en : in std_logic;
	   A_sel : in std_logic_vector(1 downto 0);
	   B_sel : in std_logic_vector(1 downto 0);
	   A_port : out std_logic_vector(15 downto 0);
	   B_port : out std_logic_vector(15 downto 0)
	);
end Regsfile;

architecture Behavioral of Regsfile is

signal R0 : STD_LOGIC_VECTOR (15 downto 0);
signal R1 : STD_LOGIC_VECTOR (15 downto 0);
signal R2 : STD_LOGIC_VECTOR (15 downto 0);
signal R3 : STD_LOGIC_VECTOR (15 downto 0);
signal DR : STD_LOGIC_VECTOR (15 downto 0);

begin

with A_sel select
	A_port <= R0 when "00",
	          R1 when "01",
	          R2 when "10",
	          R3 when "11",
	          (others => '0') when others;

with B_sel select
	B_port <= R0 when "00",
	          R1 when "01",
	          R2 when "10",
	          R3 when "11",
	          (others => '0') when others;


process (clk,rst)
 begin  
  if (rst = '0') then
     R0 <= (others => '0');
     R1 <= (others => '0');
     R2 <= (others => '0');
     R3 <= (others => '0');
  elsif (clk = '1' and clk'event) then
        if (R0_en = '1') then           
                R0  <= DR;   
        elsif (R1_en = '1') then 
		R1 <= DR;
	elsif (R2_en = '1') then 
		R2 <= DR;
	elsif (R3_en = '1') then 
                R3 <= DR;                  
        end if;
  end if;
 end process;

process (clk,rst)
 begin  
  if (rst = '0') then
     DR <= (others => '0');   
  elsif (clk = '1' and clk'event) then
        if (DR_en = '1') then           
                DR  <= DR_in;            
        end if;
  end if;
 end process;


end Behavioral;

