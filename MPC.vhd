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
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPC is
Port ( 
        clk : in  STD_LOGIC;
	    rst : in  std_logic;
        en : in  STD_LOGIC;
        MPC_sel : in std_logic_vector(1 downto 0);
        MPC_in : in STD_LOGIC_VECTOR (15 downto 0);
        Next_addr : in STD_LOGIC_VECTOR (15 downto 0);
        MPC_out : out  STD_LOGIC_VECTOR (15 downto 0)
 );
end MPC ;

architecture Behavioral of MPC is

 signal MPC : std_logic_vector (15 downto 0);

begin

    --MPC_out <= MPC;

 process (clk,rst,MPC_sel)
 begin
  
  if (rst = '0') then
     MPC <= (others => '0');
  elsif (clk = '1' and clk'event) then
        if (en = '1') then
            if (MPC_sel = "11") then           --go to different entries for instrction execution 
                MPC  <= MPC_in;   
            elsif (MPC_sel = "10") then     --next address for microinstrction
                MPC <= Next_addr;       
            else
               MPC <= (others => '0');      --go to 0 address for microinstrction of fetching instrctions 
            end if;
        end if;
  end if;
 end process;
MPC_out <= MPC;
end Behavioral;

