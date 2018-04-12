
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD1 is
    Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD1;

architecture Behavioral of SSD1 is

signal digit0,digit1,digit2,digit3,hex: STD_LOGIC_VECTOR(3 downto 0);
signal num: STD_LOGIC_VECTOR(15 downto 0);
signal mux: STD_LOGIC_VECTOR(1 downto 0);
begin
--atribuim digit-urile din input
digit3<=input(15 downto 12);
digit2<=input(11 downto 8);
digit1<=input(7 downto 4);
digit0<=input(3 downto 0);

--Numaratorul
Numarator: process(clk)
begin
  if rising_edge(clk) then
      num<=num+1;
  end if;
end process;
mux<=num(15 downto 14);

--Multiplexorul pt digit
MuxDigit: process(mux,digit0,digit1,digit2,digit3)
begin
   case(mux) is
      when "00"=>hex<=digit0;
      when "01"=>hex<=digit1;
      when "10"=>hex<=digit2;
      when others=>hex<=digit3;
   end case;
end process;

--Multiplexor pt anod
MuxAn: process(mux)
begin
   case(mux) is
      when "00"=>an<="1110";
      when "01"=>an<="1101";
      when "10"=>an<="1011";
      when others=>an<="0111";
   end case;
end process;

--Hexazecimal to BCD
Hexa: process(hex)
begin
  case(hex) is
      when "0001"=>cat<="1111001";
      when "0010"=>cat<="0100100";
      when "0011"=>cat<="0110000";
      when "0100"=>cat<="0011001";
      when "0101"=>cat<="0010010";
      when "0110"=>cat<="0000010";
      when "0111"=>cat<="1111000";
      when "1000"=>cat<="0000000";
      when "1001"=>cat<="0010000";
      when "1010"=>cat<="0001000";
      when "1011"=>cat<="0000011";
      when "1100"=>cat<="1000110";
      when "1101"=>cat<="0100001";
      when "1110"=>cat<="0000110";
      when "1111"=>cat<="0001110";
      when others=>cat<="1000000";
  end case;
end process;
end Behavioral;
