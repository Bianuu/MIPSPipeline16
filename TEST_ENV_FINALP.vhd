library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TEST_ENV_FINALP is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           anod : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
           );
end TEST_ENV_FINALP;

architecture TEST_ENV_FINALP_architecture of TEST_ENV_FINALP is

component mpg is
  Port ( clk : in std_logic;
        btn : in std_logic;
        en : out std_logic );
end component;

component SSD is
Port ( 

  cifra0 : in std_logic_vector(3 downto 0);
  cifra1 : in std_logic_vector(3 downto 0);
  cifra2 : in std_logic_vector(3 downto 0);
  cifra3 : in std_logic_vector(3 downto 0);
  clk : in std_logic;
  cat : out std_logic_vector(6 downto 0);
  anod : out std_logic_vector(3 downto 0)
  );
end component;

signal en : std_logic := '0';
signal en2 : std_logic := '0';

signal current_instr : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal PC_urmatoarei_instruct : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal semnalSSD : STD_LOGIC_VECTOR(15 downto 0) := x"0000";

--IF 
signal jmp_addr: STD_LOGIC_VECTOR (15 downto 0);

--semnale ID
signal rdata1:  STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal rdata2:  STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal wdata:   STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal func:    STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal extImm:  STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal sa:      STD_LOGIC := '0';
signal rd:      STD_LOGIC_VECTOR(2 downto 0) := "000";
signal rt:      STD_LOGIC_VECTOR(2 downto 0) := "000";

--semnale UC
signal regDst:   STD_LOGIC := '0';
signal extOp:    STD_LOGIC := '0';
signal aluSrc:   STD_LOGIC := '0';
signal branch:   STD_LOGIC := '0';
signal bgez:   STD_LOGIC := '0';
signal bltz:    STD_LOGIC := '0';
signal jump:     STD_LOGIC := '0';
signal memWrite: STD_LOGIC := '0';
signal memToReg: STD_LOGIC := '0';
signal regWrite: STD_LOGIC := '0';
signal aluOp:    STD_LOGIC_VECTOR(2 downto 0) := "000"; 
signal slt: STD_LOGIC := '0';

--ALU
signal sgn: std_logic := '0';
signal Zero: STD_LOGIC := '0';
signal outSemn: STD_LOGIC := '0';
signal out_adresaBranch: STD_LOGIC_VECTOR (15 downto 0) := X"0000";
signal outBgez_notSemn: STD_LOGIC := '0'; 
signal ALURes: STD_LOGIC_VECTOR (15 downto 0) := X"0000";

--EX
signal WriteAddress: std_logic_vector(2 downto 0) := "000";

--semnale MEM

signal r_data: std_logic_vector (15 downto 0) := X"0000";

--semnale WB
signal PCSrc: std_logic;

--Registri intermediari pipeline
signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(85 downto 0);
signal EX_MEM: std_logic_vector(58 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);

component Fetch_instruction is
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
end component;

component UnitControl is
  Port ( 
        Instr : in std_logic_vector(15 downto 0);
          RegDst : out std_logic;
          ExtOp : out std_logic;
          ALUSRC : out std_logic;
          Branch : out std_logic;
          Bgez : out std_logic;
          Bltz : out std_logic;
          Jump : out std_logic;
          MemWrite : out std_logic;
          MemtoReg : out std_logic;
          RegWrite : out std_logic;
          ALUOp : out std_logic_vector(2 downto 0);
          Slt : out std_logic
   );
end component;

component DecodifInstructiuni is
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
end component;

component UnitExecutie is
  Port (
       readData1 : in STD_LOGIC_VECTOR (15 downto 0);
       ALUSrc : in STD_LOGIC;
       readData2 : in STD_LOGIC_VECTOR (15 downto 0);
       ExtImm : in STD_LOGIC_VECTOR (15 downto 0);
       sa : in STD_LOGIC;
       operatie : in STD_LOGIC_VECTOR (2 downto 0);
       ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
       ALURes : out STD_LOGIC_VECTOR (15 downto 0);
       urmatorPC : in STD_LOGIC_VECTOR (15 downto 0);
       RegDst: in std_logic;
       rt: in std_logic_vector(2 downto 0);
       rd: in std_logic_vector(2 downto 0);
       Zero : out STD_LOGIC;
       outSemn : out STD_LOGIC;
       out_adresaBranch : out STD_LOGIC_VECTOR (15 downto 0);
       outBgez_notSemn : out STD_LOGIC;
       WriteAddress: out std_logic_vector(2 downto 0)
   );
end component;

component MEM is
  Port ( 
       clk :       in STD_LOGIC;
          en :    in STD_LOGIC;
          MemWrite :  in STD_LOGIC;
          adresa :      in STD_LOGIC_VECTOR (15 downto 0);
          writeData :    in STD_LOGIC_VECTOR (15 downto 0);
          readData :    out STD_LOGIC_VECTOR (15 downto 0);
          adr_rezultatALU : out STD_LOGIC_VECTOR (15 downto 0)
  );
end component;

begin
    
    debouncer1: Mpg port map(clk, btn(0), en);
    debouncer2: Mpg port map(clk, btn(1), en2);
    afisor: Ssd port map(clk => clk, anod => anod, cat => cat, cifra0 => semnalSSD(3 downto 0), cifra1 => semnalSSD(7 downto 4), cifra2 => semnalSSD(11 downto 8), cifra3 => semnalSSD(15 downto 12));
    instrfetch: Fetch_instruction port map(clk, en, en2, EX_MEM(21 downto 6), jmp_addr, jump, PCSrc, current_instr, PC_urmatoarei_instruct);
    ID: DecodifInstructiuni port map(clk => clk, en => en, RegWrite => MEM_WB(1), instr => IF_ID(31 downto 16), RegDst => regDst, writeData => wdata, ExtOp => extOp, WriteAddress => MEM_WB(36 downto 34), readData1 => rdata1, readData2 => rdata2, ExtImm => extImm, func => func, sa => sa, rt => rt, rd => rd);
    UC: UnitControl port map(Instr => IF_ID(31 downto 16), RegDst => regDst, ExtOp => extOp, ALUSrc => aluSrc, Branch => branch, Bgez => bgez, Bltz => bltz, Jump => jump, Slt => slt, MemWrite => memWrite, MemtoReg => memToReg, RegWrite => regWrite, ALUOp => aluOp);
    
   
    EX: UnitExecutie port map(readData1 => ID_EX(44 downto 29), ALUSrc => ID_EX(1), readData2 => ID_EX(60 downto 45), ExtImm => ID_EX(76 downto 61), sa => ID_EX(12), operatie => ID_EX(79 downto 77), ALUOp => ID_EX(8 downto 6), urmatorPC => ID_EX(28 downto 13), RegDst => ID_EX(0), rt => ID_EX(82 downto 80), rd => ID_EX(85 downto 83), Zero => Zero, outSemn => outSemn, out_adresaBranch => out_adresaBranch, outBgez_notSemn => outBgez_notSemn, ALURes => ALURes, WriteAddress => WriteAddress);
    
    memRam: MEM port map(clk, en, EX_MEM(2), EX_MEM(39 downto 24), EX_MEM(55 downto 40), r_data, EX_MEM(39 downto 24));
    
  -- executa beq, sau bgez, sau bltz
    PCSrc <= (EX_MEM(3) and EX_MEM(22)) or (EX_MEM(4) and (not EX_MEM(23))) or (EX_MEM(5) and EX_MEM(23));
    
    -- mux de la write-back
    wdata <= MEM_WB(17 downto 2) when MEM_WB(0) = '1' else MEM_WB(33 downto 18);
    --adresa unde se face jump
    jmp_addr <= "000" & IF_ID(28 downto 16);
    
    mux_afisare: process(sw(7 downto 5))
                         begin 
                         case sw(7 downto 5) is
                            when "000" => semnalSSD <= IF_ID(31 downto 16);
                            when "001" => semnalSSD <= IF_ID(15 downto 0);
                            when "010" => semnalSSD <= ID_EX(44 downto 29);
                            when "011" => semnalSSD <= EX_MEM(55 downto 40);
                            when "100" => semnalSSD <= ID_EX(76 downto 61);
                            when "101" => semnalSSD <= MEM_WB(33 downto 18);
                            when "110"=>  semnalSSD <= MEM_WB(17 downto 2);
                            when others=> semnalSSD <= wdata;
                         end case;
                         end process;
    
    -- proces registre intermediare
    process(clk, en)
        begin
            if(en = '1') then
                if(rising_edge(clk)) then
                    IF_ID(15 downto 0) <= PC_urmatoarei_instruct;
                    IF_ID(31 downto 16) <= current_instr;
                    
                    ID_EX(0) <= RegDst;
                    ID_EX(1) <= ALUSrc;
                    ID_EX(2) <= branch;
                    ID_EX(3) <= bgez;
                    ID_EX(4) <= bltz;
                    ID_EX(5) <= slt;
                    ID_EX(8 downto 6) <= aluOp;
                    ID_EX(9) <= memWrite;
                    ID_EX(10) <= memToReg;
                    ID_EX(11) <= regWrite;
                    ID_EX(12) <= sa;
                    ID_EX(28 downto 13) <= IF_ID(15 downto 0);
                    --rezultat dupa 2 operatii in plus
                    ID_EX(44 downto 29) <= rdata1;
                    ID_EX(60 downto 45) <= rdata2;
                    ID_EX(76 downto 61) <= extImm;
                    ID_EX(79 downto 77) <= func;
                    ID_EX(82 downto 80) <= rt;
                    ID_EX(85 downto 83) <= rd;
                    
                    EX_MEM(0) <= ID_EX(10);
                    EX_MEM(1) <= ID_EX(11);
                    EX_MEM(2) <= ID_EX(9);
                    EX_MEM(3) <= ID_EX(2);
                    EX_MEM(4) <= ID_EX(3);
                    EX_MEM(5) <= ID_EX(4);
                    EX_MEM(21 downto 6) <= out_adresaBranch;
                    EX_MEM(22) <= Zero;
                    EX_MEM(23) <= outSemn;
                    EX_MEM(39 downto 24) <= ALURes;
                    EX_MEM(55 downto 40) <= ID_EX(60 downto 45);
                    EX_MEM(58 downto 56) <= WriteAddress;    
                    
                    MEM_WB(0) <= EX_MEM(0);
                    MEM_WB(1) <= EX_MEM(1);
                    MEM_WB(17 downto 2) <= r_data;
                    MEM_WB(33 downto 18) <= EX_MEM(39 downto 24);
                    MEM_WB(36 downto 34) <= EX_MEM(58 downto 56);
                    
                end if;
            end if;
        end process;
    
end TEST_ENV_FINALP_architecture;