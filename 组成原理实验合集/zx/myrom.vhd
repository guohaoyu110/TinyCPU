library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity myrom is
    Port ( s0 : in  STD_LOGIC;
	        s1 : in  STD_LOGIC;
			  s2 : in  STD_LOGIC;
			  
           c1 : out  STD_LOGIC;
           c2 : out  STD_LOGIC;
           c3 : out  STD_LOGIC;
           c4 : out  STD_LOGIC;
		   c5 : out  STD_LOGIC;
           c6 : out  STD_LOGIC;
           c7 : out  STD_LOGIC;
           c8 : out  STD_LOGIC;
			  c9 : out  STD_LOGIC;
           c10 : out  STD_LOGIC
           
			  );
end myrom;

architecture Behavioral of myrom is

	 signal addr  : std_logic_vector(2 downto 0);  --input
    signal rdata : std_logic_vector(9 downto 0);  --output
	 
begin

	addr <= s2 & s1 & s0 ;
	
    process(addr)
	 begin
		case (addr) is
			when "000" => rdata <= "0000000001";
			when "001" => rdata <= "0000000010";
			when "010" => rdata <= "0000000100";
			when "011" => rdata <= "0000001000";
			when "100" => rdata <= "0000010000";
			when "101" => rdata <= "0000100000";
			when "110" => rdata <= "0001000000";
			when "111" => rdata <= "0010000000";
			when others => rdata <= "0000000000";
		end case;
	 end process;
	 
	 c1 <= rdata(0);
	 c2 <= rdata(1);
	 c3 <= rdata(2);
	 c4 <= rdata(3);
	 c5 <= rdata(4);
	 c6 <= rdata(5);
	 c7 <= rdata(6);
	 c8 <= rdata(7);
	 c9 <= rdata(8);
	 c10 <= rdata(9);

end Behavioral;

