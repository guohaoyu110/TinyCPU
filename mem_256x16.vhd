----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:43 03/08/2013 
-- Design Name: 
-- Module Name:    mem_256x8 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- 用VHDL的方式描述RAM 
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_256x16 is
    Port ( clk : in  STD_LOGIC;
           cs : in  STD_LOGIC; -- 片选信号
           We : in  STD_LOGIC; -- 写信号
           Outenab : in  STD_LOGIC; -- 读信号
           Address : in  STD_LOGIC_VECTOR (15 downto 0);           
           Dio : inout  STD_LOGIC_VECTOR (15 downto 0));
end mem_256x16;

architecture Behavioral of mem_256x16 is

	type ram_type is array (255 downto 0) of std_logic_vector (15 downto 0);
	signal RAM: ram_type;

begin

	Dio <= RAM(conv_integer(Address)) when Outenab = '1' and cs = '1' else (others => 'Z');
	process (clk)
	begin
	  if clk'event and clk = '1' then
			if cs = '1' then
				 if We = '1' and Outenab = '0' then
					  RAM(conv_integer(Address)) <= Dio;
				 end if;
			end if;
	  end if;
	end process;

end Behavioral;

