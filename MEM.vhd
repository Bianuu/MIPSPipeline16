library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
  Port ( 
        clk :       in STD_LOGIC;
        en :    in STD_LOGIC;
        MemWrite :  in STD_LOGIC;
        adresa :      in STD_LOGIC_VECTOR (15 downto 0);
        writeData :    in STD_LOGIC_VECTOR (15 downto 0);
        readData :    out STD_LOGIC_VECTOR (15 downto 0);
        adr_rezultatALU : out STD_LOGIC_VECTOR (15 downto 0)
  );
end MEM;

architecture MEM_architecture of MEM is

    type vectRAM is array (0 to 31) of std_logic_vector(15 downto 0);
    signal RAM : vectRAM := (X"000A",X"0001",X"0010",X"0012",X"0009",X"0015",X"0031",X"0003",X"0064",X"004C", 
        -- 10 1 16 18 9 21 49 3 100 76
        others => x"0000"
    );
begin
    -- asincrona
    readData <= RAM(conv_integer(adresa(7 downto 0)));
    process (clk) 
    begin
        if en = '1' then
            -- scrierea-sincrona
            if rising_edge(clk) and MemWrite = '1' then
                RAM(conv_integer(adresa(7 downto 0))) <= writeData;
            end if;
        end if;
    end process;
    
    adr_rezultatALU <= adresa;

end MEM_architecture;