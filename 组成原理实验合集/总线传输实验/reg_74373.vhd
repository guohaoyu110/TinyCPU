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
--
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

entity reg_74373 is
    Port ( clk : in  STD_LOGIC;
           gwe : in  STD_LOGIC;
           oen_n : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Qout : out  STD_LOGIC_VECTOR (7 downto 0));
end reg_74373;

architecture Behavioral of reg_74373 is

signal data_reg : STD_LOGIC_VECTOR (7 downto 0);

begin

   process(clk)
	begin
	   if clk'event and clk = '1' then
		   if gwe = '1' then
			   data_reg <= Din;
			end if;
		end if;
	end process;
	
	Qout <= data_reg when oen_n = '0' else "ZZZZZZZZ";

end Behavioral;

