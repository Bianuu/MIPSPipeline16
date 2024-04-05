library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DecodifInstructiuni is
  Port (
        clk : in std_logic;
        en : in std_logic;
        RegWrite : in std_logic;
        instr : in std_logic_vector(15 downto 0);
        RegDst : in std_logic;
        writeData : in std_logic_vector(15 downto 0);
        ExtOp : in std_logic;
        WriteAddress: in std_logic_vector(2 downto 0);
        readData1 : out std_logic_vector(15 downto 0);
        readData2 : out std_logic_vector(15 downto 0);
        ExtImm : out std_logic_vector(15 downto 0);
        func : out std_logic_vector(2 downto 0);
        sa : out std_logic;
        rt: out std_logic_vector(2 downto 0);
        rd: out std_logic_vector(2 downto 0)
   );
end DecodifInstructiuni;

architecture DecodifInstructiuni_architecture of DecodifInstructiuni is

component RegFilemips16 is
  Port ( 
        clk : in std_logic;
        en : in std_logic;
        RegWrite : in std_logic;
        readAdresa1 : in std_logic_vector(2 downto 0);
        readAdresa2 : in std_logic_vector(2 downto 0);
        writeAdresa : in std_logic_vector(2 downto 0);
        writeData : in std_logic_vector(15 downto 0);
        readData1 : out std_logic_vector(15 downto 0);
        readData2 : out std_logic_vector(15 downto 0)
  );
end component;

signal wrAddr : std_logic_vector(2 downto 0) := ( others => '0' );

begin
	
    regFile: RegFilemips16 port map( clk => clk, en => en, RegWrite => RegWrite,  readAdresa1 => instr(12 downto 10), readAdresa2 => instr(9 downto 7), writeAdresa => WriteAddress, writeData => writeData, readData1 => readData1, readData2 => readData2 );
   
   --MUX_2_1 care iti alege daca folosesti rt sau rd
   wrAddr <= instr(9 downto 7) when RegDst = '0' else instr(6 downto 4);
    
    sa <= instr(3);
    
    func <= instr(2 downto 0);
     --face extinsul imediat 
    ExtImm <= B"000_000_000" & instr(6 downto 0) when ExtOp = '0'
        else instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6) & instr(6 downto 0);
    
     rt <= instr(9 downto 7);
     rd <= instr(6 downto 4);
    
end DecodifInstructiuni_architecture;