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
-- 控制存储器 发出控制指令
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

entity CUmem is
    Port ( 
           MPC_out : in STD_LOGIC_VECTOR (15 downto 0);
           Micro_ins : out STD_LOGIC_VECTOR (31 downto 0);  --Microinstrction
           Next_addr : out STD_LOGIC_VECTOR (15 downto 0)
    );
end CUmem;

architecture Behavioral of CUmem is

 signal CU_data : STD_LOGIC_VECTOR (39 downto 0);
 
begin

 Micro_ins <= "00000000" & CU_data(39 downto 16);      --expand to 32-bit for flexibility
 Next_addr <= CU_data(15 downto 0);
        
    
 process(MPC_out)
 begin
  case (MPC_out) is                 --  PC_en PC_sel Imem_en MPC_en MPC_sel cs/we/oe AR_en ALU/B/Dmem_out_en IR_data_en Jmp Rd_used RsA/B_used   S     M     Next_addr
    -- Instruction fetching 要执行的微指令地址
    -- MPC_out 是入口地址吗
    -- Rd_used 是选用哪个寄存器
    -- RsA_used 是选用A端口输出与否
    when "0000000000000000" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "011" &  '1'  & '0' & '1' & "00"  & "0000" &'0' & "0000000000000001"; 
    -- LADI R0, 5
    when "0000000000000001" => CU_data <= '1' & "10"  &  '1'  & '1' &  "11" & "111"  & '1' &  "011" &  '1'  & '1' & '0' & "00"  & "0000" &'0' & "0000000000000010";
    -- JMP 2   
    when "0000000000000010" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "011" &  '1'  & '0' & '1' & "00"  & "0000" &'0' & "0000000000000011";
    -- LADI R3,2 
    when "0000000000000011" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "111" &  '1'  & '0' & '1' & "11"  & "1011" &'1' & "0000000000000100";
    -- AND R0, R1
    when "0000000000000100" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "011" &  '1'  & '0' & '1' & "00"  & "0000" &'0' & "0000000000000101";
    -- STO (R3), R0
    when "0000000000000101" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "011" &  '1'  & '0' & '1' & "00"  & "0000" &'0' & "0000000000000110";
    -- LAD R1, 2
    when "0000000000000110" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "111" &  '1'  & '0' & '1' & "11"  & "0001" &'0' & "0000000000000111";
    -- ADD R0,R1 
    when "0000000000000111" => CU_data <= '1' & "00"  &  '1'  & '1' &  "10" & "111"  & '1' &  "011" &  '1'  & '0' & '1' & "11"  & "0000" &'0' & "0000000000001000";
    -- LADI R1, 6
    when "0000000000001000" => CU_data <= '0' & "00"  &  '0'  & '0' &  "00" & "000"  & '0' &  "000"  &  '0'  & '0' & '0'   & "00"  & "0000" &'0' & "0000000000001001";
    -- hlt 终止
    when others => CU_data <= '0' & "00"  &  '0'  & '0' &  "00" & "000"  & '0' &  "000" &  '0'  & '0' & '0'   & "00"  & "0000" &'0' & "0000000000000000";
  end case;
 end process;
 
      
end Behavioral;
