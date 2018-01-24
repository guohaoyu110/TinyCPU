----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:56:32 03/08/2013 
-- Design Name: 
-- Module Name:    data_bus - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_bus is
    Port ( 
		   clk   : in STD_LOGIC;
	       data_in1  : in   STD_LOGIC_VECTOR (7 downto 0);
           data_in2  : in   STD_LOGIC_VECTOR (7 downto 0);
           data_in3  : in   STD_LOGIC_VECTOR (7 downto 0);
           data_in4  : in   STD_LOGIC_VECTOR (7 downto 0);
		   data_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out3 : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out4 : out  STD_LOGIC_VECTOR (7 downto 0);
		   data_io1  : inout  STD_LOGIC_VECTOR (7 downto 0);
		   data_io2  : inout  STD_LOGIC_VECTOR (7 downto 0);
           we1 : in  STD_LOGIC;
           we2 : in  STD_LOGIC;
           we3 : in  STD_LOGIC;
           we4 : in  STD_LOGIC;
		   we_io1: in  STD_LOGIC;
		   we_io2: in  STD_LOGIC);
end data_bus;

architecture Behavioral of data_bus is

signal bus_data_reg : STD_LOGIC_VECTOR (7 downto 0);

signal out_en : STD_LOGIC;

begin

   out_en <= '0' when (we1='1' or we2='1' or we3='1' or we4='1' or we_io1 = '1' or we_io2 = '1') else '1';
	
	data_io1 <= bus_data_reg when out_en = '1' else "ZZZZZZZZ";
	data_io2 <= bus_data_reg when out_en = '1' else "ZZZZZZZZ";
	data_out1 <= bus_data_reg;
	data_out2 <= bus_data_reg;
	data_out3 <= bus_data_reg;
	data_out4 <= bus_data_reg;

   process(clk)
	begin
	   if clk'event and clk = '1' then
		   if we1 = '1' then
			   bus_data_reg <= data_in1;
			elsif we2 = '1' then
			   bus_data_reg <= data_in2;
			elsif we3 = '1' then
			   bus_data_reg <= data_in3;
			elsif we4 = '1' then
			   bus_data_reg <= data_in4;
			elsif we_io1 = '1' then
			   bus_data_reg <= data_io1;
			elsif we_io2 = '1' then
			   bus_data_reg <= data_io2;
			end if;
		end if;
	end process;

end Behavioral;

