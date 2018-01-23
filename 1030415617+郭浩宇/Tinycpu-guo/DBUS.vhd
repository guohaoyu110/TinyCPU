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

entity DBUS is
    Port (
	   ALU_out : in STD_LOGIC_VECTOR (15 downto 0);
	   B_out : in STD_LOGIC_VECTOR (15 downto 0);
	   Dmem_out : in STD_LOGIC_VECTOR (15 downto 0);
	   IR_data : in STD_LOGIC_VECTOR (15 downto 0);	
	   ALU_out_en : in STD_LOGIC;
	   B_out_en : in STD_LOGIC;
	   Dmem_out_en : in STD_LOGIC;
	   IR_data_en : in STD_LOGIC;	
	   DBUS_out : out std_logic_vector(15 downto 0)	  
	);
end DBUS;

architecture Behavioral of DBUS is

begin

with ALU_out_en select
	DBUS_out <= ALU_out when '1',	
	            (others => 'Z') when others;

with B_out_en select
	DBUS_out <= B_out when '1',	
	            (others => 'Z') when others;

with Dmem_out_en select
	DBUS_out <= Dmem_out when '1',	
	            (others => 'Z') when others;

with IR_data_en select
	DBUS_out <= IR_data when '1',	
	            (others => 'Z') when others;

end Behavioral;

