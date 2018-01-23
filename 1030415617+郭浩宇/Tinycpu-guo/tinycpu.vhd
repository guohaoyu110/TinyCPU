----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2017 02:39:42 PM
-- Design Name: 
-- Module Name: tinycpu - Behavioral
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
-- 顶层文件
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity tinycpu is
port ( 
    rst : in std_logic;
    clk : in std_logic;
    micro_ins1: out std_logic_vector(31 downto 0);
    A_port1 : out std_logic_vector(15 downto 0);
    B_port1 : out std_logic_vector(15 downto 0);
    PC_out1: out std_logic_vector(15 downto 0);
    IR1 : out std_logic_vector(15 downto 0);
    CU_entry1 : out std_logic_vector(15 downto 0);
    MPC_out1 : out std_logic_vector(15 downto 0);
    F1 : out std_logic_vector(15 downto 0);
    DBUS_out1 : out std_logic_vector(15 downto 0)
);
end tinycpu;

architecture Behavioral of tinycpu is
  signal Rd_used : std_logic;
  signal RsA_used : std_logic;
  signal RsB_used : std_logic;		
  signal Jmp : std_logic;
  signal PC_en : std_logic;
  signal PC_sel : std_logic_vector(1 downto 0);
  signal Imem_en : std_logic;
  signal MPC_en : std_logic;
  signal MPC_sel : std_logic_vector(1 downto 0);
  signal Dmem_cs : std_logic;
  signal Dmem_we : std_logic;
  signal Dmem_outenab : std_logic;
  signal AR_en : std_logic;
  signal ALU_out_en : std_logic;
  signal B_out_en : std_logic;
  signal Dmem_out_en : std_logic;
  signal IR_data_en : std_logic;
  signal DR_en : std_logic;
  signal R0_en : std_logic;
  signal R1_en : std_logic;
  signal R2_en : std_logic;
  signal R3_en : std_logic;
  signal A_sel : std_logic_vector(1 downto 0);
  signal B_sel : std_logic_vector(1 downto 0);
  signal S : STD_LOGIC_VECTOR (3 downto 0);
  signal M : STD_LOGIC;	   
   
 --signal PC_in :  STD_LOGIC_VECTOR (15 downto 0);
 --signal PC_branch :  STD_LOGIC_VECTOR (15 downto 0);
 signal PC_out :  STD_LOGIC_VECTOR (15 downto 0);
 signal IR :  STD_LOGIC_VECTOR (15 downto 0);
 signal CU_entry :  STD_LOGIC_VECTOR (15 downto 0);
 
 signal AR :  STD_LOGIC_VECTOR (15 downto 0);
 signal AR_in :  STD_LOGIC_VECTOR (15 downto 0);
 
 signal Next_addr :  STD_LOGIC_VECTOR (15 downto 0);
 signal MPC_out :  STD_LOGIC_VECTOR (15 downto 0);
 
 signal IR_data :  STD_LOGIC_VECTOR (15 downto 0);
 signal DBUS_out :  STD_LOGIC_VECTOR (15 downto 0); 
 
 signal Dio :  STD_LOGIC_VECTOR (15 downto 0);
 signal Dmem_in :  STD_LOGIC_VECTOR (15 downto 0);
 signal Dmem_out :  STD_LOGIC_VECTOR (15 downto 0);
 
 signal A :  STD_LOGIC_VECTOR (15 downto 0);
 signal B :  STD_LOGIC_VECTOR (15 downto 0);
 signal F :  STD_LOGIC_VECTOR (15 downto 0);
 
 signal Micro_ins : STD_LOGIC_VECTOR (31 downto 0);
 
 component Program_Counter
 Port (  clk : in  STD_LOGIC;
         rst : in  std_logic;
         en : in  STD_LOGIC;
         PC_sel : in std_logic_vector(1 downto 0);
         PC_in : in STD_LOGIC_VECTOR (15 downto 0);
         PC_branch : in STD_LOGIC_VECTOR (15 downto 0);
         PC_out : out  STD_LOGIC_VECTOR (15 downto 0)
         );
 end component;
 
 component Imem
     Port ( clk : in  STD_LOGIC;
            rst : in  std_logic;
            en : in  STD_LOGIC;
            Addr : in STD_LOGIC_VECTOR (15 downto 0);
            IR : out STD_LOGIC_VECTOR (15 downto 0)
            );
 end component;
 
 component Decoder
     Port ( 
            Opcode : in STD_LOGIC_VECTOR (5 downto 0);
            CU_entry : out STD_LOGIC_VECTOR (15 downto 0)
     );
 end component;
 
 component MPC
 Port ( 
         clk : in  STD_LOGIC;
         rst : in  std_logic;
         en : in  STD_LOGIC;
         MPC_sel : in std_logic_vector(1 downto 0);
         MPC_in : in STD_LOGIC_VECTOR (15 downto 0);
         Next_addr : in STD_LOGIC_VECTOR (15 downto 0);
         MPC_out : out  STD_LOGIC_VECTOR (15 downto 0)
  );
 end component ;
 
 component mem_256x16
     Port ( clk : in  STD_LOGIC;
            cs : in  STD_LOGIC;
            We : in  STD_LOGIC;
            Outenab : in  STD_LOGIC;
            Address : in  STD_LOGIC_VECTOR (15 downto 0);           
            Dio : inout  STD_LOGIC_VECTOR (15 downto 0));
 end component;

component DBUS
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
end component;

component Regsfile
    Port (
	   clk : in  STD_LOGIC;
	   rst : in  std_logic;
	   DR_in : in STD_LOGIC_VECTOR (15 downto 0);	
	   DR_en : in std_logic;
	   R0_en : in std_logic;
	   R1_en : in std_logic;
	   R2_en : in std_logic;
	   R3_en : in std_logic;
	   A_sel : in std_logic_vector(1 downto 0);
	   B_sel : in std_logic_vector(1 downto 0);
	   A_port : out std_logic_vector(15 downto 0);
       B_port : out std_logic_vector(15 downto 0)
	);
end component;

component alu_16bit
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           S : in  STD_LOGIC_VECTOR (3 downto 0);
           M : in  STD_LOGIC;
           C_n : in  STD_LOGIC;
           F : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end component;

component CUmem  
    Port ( 
           MPC_out : in STD_LOGIC_VECTOR (15 downto 0);
           Micro_ins : out STD_LOGIC_VECTOR (31 downto 0);  --Microinstrction
           Next_addr : out STD_LOGIC_VECTOR (15 downto 0)
    );
end component;
    
begin
 
   PC : Program_Counter
   port map (clk => clk,
             rst => rst,
             en => PC_en,
             PC_sel => PC_sel,
             PC_in => DBUS_out,
             PC_branch => DBUS_out,
             PC_out => PC_out			     
             ); 
  PC_out1 <= PC_out;

  ICache : Imem
    Port map( 
        clk => clk,
        rst => rst,
        en => Imem_en,
        Addr => PC_out,
        IR => IR 
        );
      IR1 <= IR;  

   ID : Decoder --CUmem entry for instructions based on Opcode
    Port map( 
             Opcode => IR(15 downto 10),
             CU_entry => CU_entry
            );
     CU_entry1 <= CU_entry;

   Microaddr : MPC
    Port map( 
             clk => clk,
             rst => rst,
             en => MPC_en,
             MPC_sel => MPC_sel,
             MPC_in => CU_entry,
             Next_addr => Next_addr,
             MPC_out => MPC_out
    );
     MPC_out1 <= MPC_out;

   CU : CUmem
        Port map( 
               MPC_out => MPC_out,
               Micro_ins => Micro_ins,
               Next_addr => Next_addr
        ); 
       micro_ins1 <= Micro_ins;
    
   Dmem : mem_256x16
        Port map (                 
               clk => clk,
               cs => Dmem_cs,
               We => Dmem_we,
               Outenab => Dmem_outenab,
               Address => AR,           
               Dio => Dio
        );
   Dmem_out <= Dio;
   Dio <= Dmem_in when (Dmem_cs = '1' and Dmem_we = '1' and Dmem_outenab = '0') else (others => 'Z');	
   Dmem_in <= DBUS_out;
  -- Dio1 <= Dio;

   process (clk,rst)
     begin  
      if (rst = '0') then
         AR <= (others => '0');   
      elsif (clk = '1' and clk'event) then
            if (AR_en = '1') then           
                    AR  <= AR_in;            
            end if;
      end if;
   end process;

   Databus : DBUS
       Port map(
          ALU_out => F,
          B_out => B,
          Dmem_out => Dmem_out,
          IR_data => IR_data,    
          ALU_out_en  => ALU_out_en,
          B_out_en  => B_out_en,
          Dmem_out_en  => Dmem_out_en,
          IR_data_en => IR_data_en,    
          DBUS_out => DBUS_out      
       );

   IR_data <= "000000" & IR(9 downto 0) when Jmp = '1' else "000000000" & IR(6 downto 0);	
   DBUS_out1 <= DBUS_out;

 General_Registers : Regsfile 
    Port map(
	   clk => clk,
	   rst => rst,
	   DR_in => DBUS_out,	
	   DR_en => '1',   
	   R0_en => R0_en,
	   R1_en => R1_en,
	   R2_en => R2_en,
	   R3_en => R3_en,		
	   A_sel => A_sel,
	   B_sel => B_sel,
	   A_port => A,
       B_port => B
    );
    A_port1 <= A;
    B_port1 <= B;
	
--Destination register selection 目标寄存器
    R0_en <= '1' when Rd_used = '1' and IR(9 downto 7) = "000" else '0';
    R1_en <= '1' when Rd_used = '1' and IR(9 downto 7) = "001" else '0';
    R2_en <= '1' when Rd_used = '1' and IR(9 downto 7) = "010" else '0';
    R3_en <= '1' when Rd_used = '1' and IR(9 downto 7) = "011" else '0';
--Source register selection  源寄存器
    A_sel <= IR(8 downto 7) when RsA_used = '1' else "00";	-- 表示用了A_port 
    B_sel <= IR(5 downto 4) when RsB_used = '1' else "00";	-- 表示用了B_port

  ALU : alu_16bit
    Port map( 
	       A => A,
           B => B,
           S => S,
           M => M,
           C_n => '1',
           F => F
           );
     F1 <= F;
    
--==All control signals generated by CU ================================
  --  DR_en <= Micro_ins(24);
    PC_en <= Micro_ins(23);
    PC_sel <= Micro_ins(22 downto 21);
    Imem_en <= Micro_ins(20);
    MPC_en <= Micro_ins(19);
    MPC_sel <= Micro_ins(18 downto 17);
    Dmem_cs <= Micro_ins(16);
    Dmem_we <= Micro_ins(15);
    Dmem_outenab <= Micro_ins(14);
    AR_en <= Micro_ins(13);
    ALU_out_en <= Micro_ins(12);
    B_out_en <= Micro_ins(11);
    Dmem_out_en <= Micro_ins(10);
    IR_data_en <= Micro_ins(9);    
	Jmp <= Micro_ins(8);	
	Rd_used <= Micro_ins(7);
	RsA_used <= Micro_ins(6);
	RsB_used <= Micro_ins(5);
	S <= Micro_ins(4 downto 1);
    M <= Micro_ins(0);
        
        

end Behavioral;
