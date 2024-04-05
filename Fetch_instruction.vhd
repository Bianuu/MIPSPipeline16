library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Fetch_instruction is
  Port ( 
         clk : in STD_LOGIC;
         en : in STD_LOGIC;
         reset : in STD_LOGIC;
         adresaBranch : in STD_LOGIC_VECTOR (15 downto 0);
         jmp_addr : in STD_LOGIC_VECTOR (15 downto 0);
         jump : in STD_LOGIC;
         PCSrc : in STD_LOGIC;
         current_instr : out STD_LOGIC_VECTOR (15 downto 0);
         adresa_urmatoareiInstruct : out STD_LOGIC_VECTOR (15 downto 0)
         );
end Fetch_instruction;

architecture Fetch_instruction_architecture of Fetch_instruction is

signal pc_out : STD_LOGIC_VECTOR (15 DOWNTO 0) := X"0000";
signal sum_out : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
signal out_MUX_1 : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
signal out_MUX_2 : STD_LOGIC_VECTOR (15 downto 0) := X"0000";

type vectROM is array (0 to 255) of std_logic_vector(15 downto 0);

signal rom256x16: vectROM := (

--BINAR 
--R:opcode rs rt rd sa func
--I:opcode rs rt imm
--J:opcode targetAdress

   -- addi $4, $0, 10    ( rt rs imm )  -n
  B"001_000_100_0001010", 
   -- add $2, $0, $0    -i
  B"000_000_000_010_0_000",
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000", 
   --lw $5,0($2)   - max=a[i]
  B"010_010_101_0000000",
  ---------------
    -- beq $2, $4, 17   ( rs rt imm )  -for(index;index<n)     
  B"100_010_100_0010001",
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000", 
    -- lw $3, 0($2)     ( rt imm(rs) )    -aux=a[i]
  B"010_010_011_0000000", 
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000",
    -- sub $6, $5, $3    ( rd rs rt ) -aux2=max-aux
  B"000_101_011_110_0_001",
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000", 
  ---------
    -- bgez $6, 4  ( rs imm ) -- salt conditionat daca aux2>=0      
  B"101_110_000_0000100", 
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000",
  -- noop
  B"000_000_000_000_0_000",
    -- add $5, $0, $3     - max=aux
  B"000_000_011_101_0_000",
  -------
    -- addi $2, $2, 1       -i++
  B"001_010_010_0000001",  
    -- j 5                  
  B"111_0000000000101", 
  -- noop
  B"000_000_000_000_0_000",
  ------------
    -- sw $5, 20($0)  ( rt imm(rs) )  -- salveaza max la adresa 20 din memorie 
  B"011_000_101_0010100", 
  
 others => x"5555"
);

begin

    -- PC 
	-- pc_out ia valoarea de pe intrare daca en=1;
    process(clk, en, reset)
    begin
        if reset = '1' then
            pc_out <= x"0000";
        else
            if rising_edge(clk) then
                if en = '1' then
                    pc_out <= out_MUX_2;
                end if;
            end if;
        end if;
    end process;
    
    sum_out <= pc_out + 1;
    
    current_instr <= rom256x16(conv_integer(pc_out));
    
    adresa_urmatoareiInstruct <= sum_out;
    
    -- MUX_1 pentru branch
    out_MUX_1<= sum_out when PCSrc = '0'
                else adresaBranch;
    
    -- MUX_2 pentru jump
    out_MUX_2 <= out_MUX_1 when jump = '0'
                else jmp_addr;
    

end Fetch_instruction_architecture;