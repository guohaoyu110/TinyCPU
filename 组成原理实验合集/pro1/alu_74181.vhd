----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:42 03/06/2013 
-- Design Name: 
-- Module Name:    alu_74181 - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_74181 is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           S : in  STD_LOGIC_VECTOR (3 downto 0);
           M : in  STD_LOGIC;
           C_n : in  STD_LOGIC;
           F : out  STD_LOGIC_VECTOR (3 downto 0);
           C_n_plus4 : out  STD_LOGIC);
end alu_74181;

architecture Behavioral of alu_74181 is

signal data_o_logic : STD_LOGIC_VECTOR (3 downto 0);
signal data_o_arith : STD_LOGIC_VECTOR (4 downto 0);

signal data_sub_tmp : STD_LOGIC_VECTOR (4 downto 0);

signal C_n_arith : STD_LOGIC_VECTOR (4 downto 0);

begin

	F <= data_o_logic when M = '1' else
		  data_o_arith(3 downto 0);
	-- carry out	  
	C_n_plus4 <= not data_o_arith(4) when M = '0' else '1';
	
	C_n_arith <= "0000" & (not C_n);

   -- 74181 logic operation
	process(A,B,S,M)
	begin
		case (S) is 
			when "0000" =>
				data_o_logic <= not A;
			when "0001" =>
				data_o_logic <= not (A or B);
			when "0010" =>
				data_o_logic <= (not A) and B;
			when "0011" =>
				data_o_logic <= (others => '0');
			when "0100" =>
				data_o_logic <= not (A and B);
			when "0101" =>
				data_o_logic <= not B;
			when "0110" =>
				data_o_logic <= (A xor B);
			when "0111" =>
				data_o_logic <= A and (not B);
			when "1000" =>
				data_o_logic <= (not A) or B;
			when "1001" =>
				data_o_logic <= (A xnor B);
			when "1010" =>
				data_o_logic <= B;
			when "1011" =>
				data_o_logic <= A and B;
			when "1100" =>
				data_o_logic <= "0001";
			when "1101" =>
				data_o_logic <= A or (not B);
			when "1110" =>
				data_o_logic <= A or B;
			when "1111" =>
				data_o_logic <= A;
			when others =>
				data_o_logic <= (others => '0');
		end case;
	end process;

   -- 74181 arithmetic operation
	process(A,B,S,M,C_n_arith)
	begin
		case (S) is 
			when "0000" =>
				data_o_arith <= ('0'&A) + C_n_arith;
			when "0001" =>
				data_o_arith <= '0'&(A or B) + C_n_arith;
			when "0010" =>
				data_o_arith <= '0'&(A or (not B)) + C_n_arith;
			when "0011" =>
			   -- if C_n = 0, minus 1,carry bit is 0; if C_n = 1,carry bit is 1;invert
				data_o_arith <= "01111" + C_n_arith; 
			when "0100" =>
				data_o_arith <= ('0'&A) + ('0'&(A and (not B))) + C_n_arith;
			when "0101" =>
				data_o_arith <= ('0'&(A or B))+('0'&(A and (not B)))+ C_n_arith;
			when "0110" =>
			   -- if sub function, carry bit is different from add function
				data_sub_tmp <= ('0'&A) - ('0'&B) - 1 + C_n_arith;
				data_o_arith <= not data_sub_tmp(4) & data_sub_tmp(3 downto 0);
			when "0111" =>
			   -- if sub function, carry bit is different from add function
				data_sub_tmp <= ('0'&(A and (not B)))- 1 + C_n_arith;
				data_o_arith <= not data_sub_tmp(4) & data_sub_tmp(3 downto 0);
			when "1000" =>
				data_o_arith <= ('0'&A) +('0'&(A and B))+ C_n_arith;
			when "1001" =>
				data_o_arith <= ('0'&A) + ('0'&B) + C_n_arith;
			when "1010" =>
				data_o_arith <= ('0'&(A or (not B))) + ('0'&(A and B))+ C_n_arith;
			when "1011" =>
			   -- if sub function, carry bit is different from add function
				data_sub_tmp <= ('0'&(A and B)) - 1 + C_n_arith;
				data_o_arith <= not data_sub_tmp(4) & data_sub_tmp(3 downto 0);
			when "1100" =>
				data_o_arith <= ('0'&A) + ('0'&A) + C_n_arith;
			when "1101" =>
				data_o_arith <= ('0'&(A or B)) + ('0'&A) + C_n_arith;
			when "1110" =>
				data_o_arith <= ('0'&(A or (not B))) + ('0'&A) + C_n_arith;
			when "1111" =>
			   -- if sub function, carry bit is different from add function
				data_sub_tmp <= ('0'&A) - 1 + C_n_arith;
				data_o_arith <= not data_sub_tmp(4) & data_sub_tmp(3 downto 0);
		
			when others =>
				data_o_arith <= (others => '0');
		end case;
   end process;

end Behavioral;

