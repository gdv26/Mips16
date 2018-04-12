----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
--  Istrate Vlad
-- Create Date: 03/28/2017 02:09:04 PM
-- Design Name: 
-- Module Name: test_env_1 - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is


component MPG1 is
 port( btn: in STD_LOGIC;
       clk: in STD_LOGIC;
       en: out STD_LOGIC);
end component;

component SSD1 is
    Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component IFetch is
 Port (
           clk:in std_logic;
           we:in std_logic;
           reset:in std_logic;
           branchAdr: in std_logic_vector(15 downto 0);
           jumpAdr: in std_logic_vector (15 downto 0);
         
           PCSrc:in std_logic;
           jump:in std_logic;
           
           instruction : out std_logic_vector(15 downto 0);
           nextPC:out std_logic_vector(15 downto 0)
     );
end component;

component UC is
 Port (
    instruction: in std_logic_vector(2 downto 0);
    
    RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    Branch: out std_logic;
    Jump:out std_logic;
    ALUOp:out std_logic_vector (2 downto 0);
    MemWrite: out std_logic;
    MemtoReg:out std_logic;
    RegWrite: out std_logic
     );
end component;


component IDecode is
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
end component;


component Execute is
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
end component;

component MEM is
 Port (
 
    clk:in std_logic;
    
    MemWriteCtrl:in std_logic;
    MemWrite:in std_logic;
    ALURes:in std_logic_vector (15 downto 0);
    RD2:in std_logic_vector (15 downto 0);
    
    MemData:out std_logic_vector(15 downto 0);
    ALUResOut:out std_logic_vector(15 downto 0)
    
  );
end component;


signal enable1,reset,PCSrc_if,jump_if:std_logic; ---signal IF
signal   branchAdr_if,jumpAdr_if,instruction_if,nextPC_if: std_logic_vector(15 downto 0);
        
--signal IDecode
signal  regdst_id,regwrite_id,extop_id,sa_id: std_logic;
signal wd_id,rd1_id,rd2_id,ext_imm_id:std_logic_vector(15 downto 0);
signal func_id:std_logic_vector(2 downto 0);  

--signal UC

signal RegDst_uc,ExtOp_uc,ALUSrc_uc,Branch_uc,Jump_uc,MemWrite_uc,MemtoReg_uc,RegWrite_uc:std_logic;
signal   ALUOp_uc: std_logic_vector (2 downto 0);

--signal ex
signal ALURes_ex:std_logic_vector(15 downto 0);
signal zero_ex:std_logic;

--signal MEM
signal memData_m:std_logic_vector(15 downto 0);


signal rez1:std_logic_vector (15 downto 0); ---afisare pe SSD

begin


--calcul jumpadress
    jumpAdr_if<=nextPC_if(15 downto 14)&instruction_if(13 downto 0);
    
    
    
    deb1: MPG1 port map (btn(0),clk,enable1);
    deb2: MPG1 port map(btn(2),clk,reset);
    fetch1: IFetch port map(clk,enable1,reset,branchAdr_if,jumpAdr_if,PCSrc_if,jump_if,instruction_if,nextPC_if);
    decode: IDecode port map( clk,instruction_if,regdst_id,regwrite_id,extop_id,wd_id,rd1_id,rd2_id,ext_imm_id,func_id,sa_id);
   -- exec: Execute port map(nextPC_if,rd1_id,rd2_id,ext_imm_id,sa_id,func_id,ALUOp_ex,ALUSrc_ex,branchAdr_if,ALURes_ex,zero_ex);
    UnitateControl: UC port map(instruction_if(15 downto 13),regdst_id,extop_id,ALUSrc_uc,Branch_uc,Jump_uc,ALUOp_uc,MemWrite_uc,MemtoReg_uc,regwrite_id);
    exec: Execute port map(nextPC_if,rd1_id,rd2_id,ext_imm_id,sa_id,func_id,ALUOp_uc,ALUSrc_uc,branchAdr_if,ALURes_ex,zero_ex);
    Memorie: MEM port map(clk,enable1,MemWrite_uc,ALURes_ex,RD2_id,memData_m,ALURes_ex);


    PCSrc_if<=Branch_uc and zero_ex;
    
    process(ALURes_ex,memToReg_uc,memData_m)
    begin
        case memToReg_uc is
            when '1'=> wd_id<=memData_m;
            when '0'=> wd_id<=ALURes_ex;
            when others => wd_id<=x"0000";
        end case;
    end process;
   --wd_d<=rd1_d+rd2_d;
    
process(sw(7 downto 5))
begin
   case sw(7 downto 5) is
       when "000"=> rez1<=instruction_if;
       
       when "001"=> rez1<=nextPC_if;
       
       when"010" => rez1<=rd1_id;
       
       when"011" => rez1<=rd2_id;
        
       when "100" =>rez1<=ext_imm_id;
       
       when "101" => rez1<=ALURes_ex;
       
       when "110" => rez1<=memData_m;
       
       when "111" => rez1<=wd_id;
       
       when others => rez1<=x"AAAA";
       end case;
      
 end process;
 
 --process(sw(7))
 --begin
--     if sw(7)='0' then
--       rez1<=instruction;
--         else
--         rez1<=nextPC;
--         end if;
--        end process;
         
  process(regdst_id,ExtOp_uc,ALUSrc_uc,Branch_uc,Jump_uc,MemWrite_uc,MemtoReg_uc,regwrite_id,ALUOp_uc)
begin
	if sw(0)='0' then		
		led(7)<=regdst_id;
		led(6)<=ExtOp_uc;
		led(5)<=ALUSrc_uc;
		led(4)<=Branch_uc;
		led(3)<=Jump_uc;
		led(2)<=MemWrite_uc;
		led(1)<=MemtoReg_uc;
		led(0)<=RegWrite_id;
		
	else
		led(2 downto 0)<=ALUOp_uc(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;

  rez_ssd: SSD1 port map(rez1,clk,an,cat);      

end Behavioral;
