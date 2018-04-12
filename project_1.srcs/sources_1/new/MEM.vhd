----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2017 05:01:50 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
 Port (
 
    clk:in std_logic;
    
    MemWriteCtrl:in std_logic;
    MemWrite:in std_logic;
    ALURes:in std_logic_vector (15 downto 0);
    RD2:in std_logic_vector (15 downto 0);
    
    MemData:out std_logic_vector(15 downto 0);
    ALUResOut:out std_logic_vector(15 downto 0)
    
  );
end MEM;

architecture Behavioral of MEM is

signal Address:std_logic_vector(3 downto 0);

type mem is array(0 to 15) of std_logic_vector(15 downto 0);

signal RAM: mem:=(
        x"000A",
        x"000B",
        x"000C",
        x"000D",
        x"000E",
        x"000F",
        x"0008",
        x"0009",
        others=>x"0000"
);
begin

Address<=ALURes(3 downto 0);


process(clk,MemWrite)
begin
    if rising_edge(clk) then
    if memWriteCtrl='1' then 
        if MemWrite='1' then
            RAM(conv_integer(Address))<=RD2;
        end if;
      end if;
    end if;
    
end process;
 MemData<=RAM(conv_integer(Address));
ALUResOut<=ALURes;

end Behavioral;
