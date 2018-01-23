----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2017 04:10:54 PM
-- Design Name: 
-- Module Name: Imem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( 
           Opcode : in STD_LOGIC_VECTOR (5 downto 0);
           CU_entry : out STD_LOGIC_VECTOR (15 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is

begin

    
 process(Opcode)
 begin
  case (Opcode) is
    -- 操作码过来生成控存的地址
    --控制存储器进入的地址
    when "000000" => CU_entry <= "000000" & "000" & "0000010";--  mov 
    when "001000" => CU_entry <= "001000" & "001" & "0000010";--  lad
    when "001001" => CU_entry <= "001001" & "000" & "0000101";--  ladi
    when "001010" => CU_entry <= "001010" & "011" & "0000000";-- 6010 sto
    when "010000" => CU_entry <= "001010" & "000" & "0000001";-- 2980 add 
    when "011000" => CU_entry <= "011000" & "000" & "0000001";-- 2082 and 
    when "100000" => CU_entry <= "100000" & "000" & "0000010";-- JMP指令 8001 JMP 1
    when "111111" => CU_entry <= "111111" & "000" & "0000000";-- fc00 hlt 终止指令
    when others => CU_entry <= "111111" & "000" & "0000000"; 
  end case;
 end process;
 
      
end Behavioral;
