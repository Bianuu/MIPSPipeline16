library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UnitControl is
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
end UnitControl;

architecture UnitControl_architecture of UnitControl is

begin
    process(Instr)
    begin
    
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Bgez <= '0';
        Bltz <= '0';
        Jump <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        ALUOp <= "000";
        RegWrite <= '0';
        Slt <= '0';
        --case in functie de opcode
        case (Instr(15 downto 13)) is
         -- tip R
            when "000" =>
                RegDst <= '1'; RegWrite <= '1'; ALUOp <= "000";
                if Instr(2 downto 0) = "111" then 
                    Slt <= '1';
                end if;
                
                -- addi
            when "001" => 
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "001";
                
                -- lw
            when "010" => 
                ALUOp <= "001";
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                MemtoReg <= '1';
                
                -- sw
            when "011" => 
                ALUSrc <= '1';
                ExtOp <= '1';
                MemWrite <= '1';
                ALUOp <= "001";
                
                -- beq
            when "100" => 
                ExtOp <= '1';
                ALUOp <= "010";
                Branch <= '1';
                
                -- bgez
            when "101" => 
                Bgez <= '1';
                ExtOp <= '1';
                ALUOp <= "010";
                
                -- bltz
            when "110" => 
                Bltz <= '1';
                ExtOp <= '1';
                ALUOp <= "010";
                
                 -- j
            when "111" =>
                Jump <= '1';
                
            when others =>
                RegDst <= 'X';
                ExtOp <= 'X';
                ALUSrc <= 'X';
                Branch <= 'X';
                Bgez <= 'X';
                Bltz <= 'X';
                Jump <= 'X';
                MemWrite <= 'X';
                MemtoReg <= 'X';
                ALUOp <= "XXX";
                RegWrite <= 'X';
                Slt <= 'X';
        end case;
    end process;

end UnitControl_architecture;