
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MPG1 is
 port( btn: in STD_LOGIC;
       clk: in STD_LOGIC;
       en: out STD_LOGIC);
end MPG1;

architecture Behavioral of MPG1 is
signal num: STD_LOGIC_VECTOR(15 downto 0);
signal Q1: STD_LOGIC;
signal Q2: STD_LOGIC;
signal Q3: STD_LOGIC;
begin
--numaratorul
process(clk)
begin
   if rising_edge(clk) then 
       num<=num+1;
   end if;
end process;

--primul bistabil
process(clk)
begin
  if rising_edge(clk) then
     if num=x"FFFF" then 
        Q1<=btn; --numaratorul are capcitatea maxima, se transmite valoarea de la btn
     end if;
   end if;
end process;

--al treilea bistabil
process(clk)
begin
  if rising_edge(clk) then 
      Q2<=Q1;
      Q3<=Q2;
  end if;
end process;

EN<=Q2 and(not Q3);

end Behavioral;
