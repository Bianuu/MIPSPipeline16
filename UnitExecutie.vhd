library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UnitExecutie is
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
end UnitExecutie;

architecture UnitExecutie_architecture of UnitExecutie is
	--intrare alu ->
    signal ALUIn2 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
	signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    --out aluSrc mux
	signal auxaluRes : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
begin
    -- ALUCtrl
    process(ALUOp, operatie)
    begin
        case ALUOp is
		-- pt instructiunuile de tip R
            when "000" =>
                case operatie is 
                     -- add
                    when "000" => ALUCtrl <= "000";
                     -- sub
                    when "001" => ALUCtrl <= "001"; 
                     -- sll
                    when "010" => ALUCtrl <= "010"; 
                     -- srl
                    when "011" => ALUCtrl <= "011";
                    -- and
                    when "100" => ALUCtrl <= "100"; 
                    -- or
                    when "101" => ALUCtrl <= "101"; 
                    -- xor
                    when "110" => ALUCtrl <= "110"; 
                    -- slt - se face o comparatie in ALU
                    when "111" => ALUCtrl <= "111"; 
					when others => ALUCtrl <= (others => '0'); 
                end case;
                
                -- addi, lw, sw
            when "001" => 
                ALUCtrl <= "000"; -- adunare in ALU
                -- beq, bgez, bltz
            when "010" => 
                ALUCtrl <= "001"; -- scadere in ALU
                -- j
            when others => 
                ALUCtrl <= "XXX";
        end case;
    end process;
    
    -- MUX de la AluSrc 
    MUX2_1: ALUIn2 <= readData2 when ALUSrc = '0' else ExtImm;
    
    outSemn <= readData1(15);
    
    -- ALU
    process(readData1, ALUIn2, ALUCtrl, sa)
    begin
        case ALUCtrl is
            when "000" => auxaluRes <= readData1 + ALUIn2;
            when "001" => auxaluRes <= readData1 - ALUIn2;
            
            when "010" => if sa = '1' then
                                auxaluRes <= readData1(14 downto 0) & '0';
                          else
                                auxaluRes <= readData1;
                          end if;
                          
            when "011" => if sa = '1' then
                                auxaluRes <= '0' & readData1(15 downto 1);
                          else
                                auxaluRes <= readData1;
                          end if;
                          
            when "100" => auxaluRes <= readData1 and ALUIn2;
            when "101" => auxaluRes <= readData1 or ALUIn2;
            when "110" => auxaluRes <= readData1 xor ALUIn2;
            
            when others => if readData1 < ALUIn2 then
                                auxaluRes <= X"0001";
                           else
                                auxaluRes <= X"0000";
                           end if;
        end case;
    end process;
    --zero de la alu branch
    Zero <= '1' when auxaluRes = X"0000" else '0';
    
    ALURes <= auxaluRes;
    
    outBgez_notSemn <= not auxaluRes(15);
    
    out_adresaBranch <= urmatorPC + ExtImm;
    
        -- pentru stabilirea adresei de scriere
    process(RegDst, rd, rt)
    begin
        if RegDst = '0' then
            WriteAddress <= rt;
        else
            WriteAddress <= rd;
        end if;
    end process;

end UnitExecutie_architecture;