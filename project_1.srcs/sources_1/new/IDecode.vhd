----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2017 01:26:00 PM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;                          
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecode is
 Port ( 
    clk:in std_logic;
    instruction:in std_logic_vector (15 downto 0);
    regdst:in std_logic;
    regwrite:in std_logic;
    extop:in std_logic;
    wd:in std_logic_vector( 15 downto 0);
    
    rd1:out std_logic_vector (15 downto 0);
    rd2:out std_logic_vector (15 downto 0);
    ext_imm:out std_logic_vector(15 downto 0);
    func:out std_logic_vector(2 downto 0);
    sa: out std_logic
    
 );
end IDecode;

architecture Behavioral of IDecode is


signal RA1:std_logic_vector(2 downto 0);
signal RA2:std_logic_vector(2 downto 0);
signal wa:std_logic_vector(2 downto 0);

signal ALUOp:std_logic_vector(2 downto 0);

signal RegDst_uc,ExtOp_uc,ALUSrc_uc,Branch_uc,Jump_uc,MemWrite_uc,MemtoReg_uc,RegWrite_uc:std_logic;

signal sum:std_logic_vector (15 downto 0);

type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file_mem:reg_array:=(
x"0001",
x"0010",
x"0011",
x"0100",
others =>x"0000");



begin

 

    
    RA1<=instruction(12 downto 10);  --rs
    RA2<=instruction(9 downto 7);   --rt
   
  
  process(clk,regwrite)
  begin
    if clk='1' and clk'event then
        if regwrite='1' then
            reg_file_mem(conv_integer(wa))<=wd;
         end if;
    end if;
  end process;
  
  rd1<=reg_file_mem(conv_integer (RA1));
  rd2<=reg_file_mem(conv_integer(RA2));
  
  ---mux rt/rd
  process(regdst,instruction)
  begin
    case regdst is
        when '0'=> wa<=RA2;
        when others=> wa<= instruction(6 downto 4);
     end case;
  end process;
  
  --sign extend
  process(extop)
  begin
    if extop='0' then
        ext_imm<="000000000" & instruction (6 downto 0);
        else
            if instruction(6) = '1' then
                ext_imm<="111111111" & instruction(6 downto 0);
             else ext_imm<="000000000" & instruction(6 downto 0);
             end if;
             end if;
             
  end process;
  
  
  func<=instruction (2 downto 0);
  sa<=instruction (3);
  
end Behavioral;
