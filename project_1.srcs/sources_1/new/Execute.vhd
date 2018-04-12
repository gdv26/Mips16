----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2017 01:29:29 PM
-- Design Name: 
-- Module Name: Execute - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Execute is
  Port (
    nextPC:in std_logic_vector (15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2:in std_logic_vector(15 downto 0);
    ext_imm:in std_logic_vector(15 downto 0);
    sa:in std_logic;
    func:in std_logic_vector (2 downto 0);
    ALUOp:in std_logic_vector(2 downto 0);
    ALUSrc:in std_logic;
    
    BranchAddress:out std_logic_vector (15 downto 0);
    ALURes:out std_logic_vector(15 downto 0);
    Zero:out std_logic
   );
end Execute;

architecture Behavioral of Execute is

signal intrare2:std_logic_vector(15 downto 0);
signal ALUControl:std_logic_vector(3 downto 0);
signal ZeroAux:std_logic;
signal ALUResAux:std_logic_vector(15 downto 0);


begin


--calcul branch addr
BranchAddress<=nextPC+ext_imm;




--MUX intrare 2 ALU
process(ALUSrc)
begin

    case ALUSrc is
    when '0' =>intrare2<=RD2;
    when others =>intrare2<=ext_imm;
    end case;
end process;


--ALU pentru ALUOP si func
process(ALUOp,func)
begin
    case ALUOp is
    --pentru operatii de tip R ALUOp are aceeasi valoare
        when "000"=>
            case func is
                when "000" => ALUControl<="0000"; --add
                when "001" => ALUControl<="0001"; --sub
                when "010" => ALUControl<="0010"; --sll
                when "011" => ALUControl<="0011"; --srl
                when "100" => ALUControl<="0100"; --and
                when "101" => ALUControl<="0101"; --or
                when "110" => ALUControl<="0110"; --xor
                when "111" => ALUControl<="0111"; --SetOnLessThan
                when others => ALUControl<="0000"; --other
             end case;
     --pentru instructiuni de tip I ALUControl depinde de val lui ALUOp
      when "001"=>ALUControl<="0000"; --addi
      when "010"=>ALUControl<="0001"; --beq
      when "101"=>ALUControl<="0100"; --andi
      when "110"=>ALUControl<="0101"; --ori
      when "111"=>ALUControl<="1000"; --jump
      when others=>ALUControl<="0000";
      end case;          
    

end process;




--Proces pentru operatii si un case suplimentar pentru verificarea ALUResAux daca e 0 sau nu
process(ALUControl,RD1,intrare2,sa)
begin
    case ALUControl is
        when "0000" => ALUResAux<=RD1+intrare2; --add
        when "0001" => ALUResAux<=RD1-intrare2; --sub
        when "0010" =>
            case sa is  --SLL
                when '1'=> ALUResAux<=RD1(14 downto 0)& "0";
                when others => ALUResAux<=RD1;
            end case;
        when "0011"=>
            case sa is --SRL
                when '1'=> ALUResAux<="0"&RD1(15 downto 1);
                when others=> ALUResAux<=RD1;
            end case;
        when "0100"=> ALUResAux<=RD1 and intrare2; --and
        when "0101"=> ALUResAux<=RD1 or intrare2; --or
        when "0110"=> ALUResAux<=RD1 xor intrare2; --xor
        when "0111"=>  --SetONLessThan
            if( RD1<intrare2) then
                ALUResAux<=x"0001";
            else ALUResAux<=x"0000";
            end if;
        when "1000"=> ALUResAux<=x"0000"; --JUMP
        when others => ALUResAux<=x"0000";
   end case;
    case ALUResAux is  --Zero Flag
        when x"0000" => ZeroAux<='1'; 
        when others => ZeroAux<='0';
        end case;
end process;

Zero<=ZeroAux;
ALURes<=ALUResAux;

end Behavioral;
