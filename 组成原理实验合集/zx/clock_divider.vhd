----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:31:57 03/22/2013 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_divider is
    Port ( clk_in : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk_1Hz : out  STD_LOGIC;
           clk_5Hz : out  STD_LOGIC;
           clk_10Hz : out  STD_LOGIC;
           clk_1KHz : out  STD_LOGIC;
           clk_1MHz : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

   signal cnt : std_logic_vector(25 downto 0);

begin

process(clk_in)
begin
   if clk_in'event and clk_in = '1' then
	   if rst = '1' then
		   cnt <= (others => '0');
		else
		   cnt <= cnt + 1;
		end if;
	end if;
end process;

clk_1Hz <= cnt(25); -- 100MHz/2^26 
clk_5Hz <= cnt(23); -- 100MHz/2^24
clk_10Hz <= cnt(22);-- 100MHz/2^23
clk_1KHz <= cnt(16);-- 100MHz/2^17
clk_1MHz <= cnt(6); -- 100MHz/2^7

end Behavioral;

