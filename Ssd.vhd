library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Ssd is
  Port ( 
  cifra0 : in std_logic_vector(3 downto 0);
  cifra1 : in std_logic_vector(3 downto 0);
  cifra2 : in std_logic_vector(3 downto 0);
  cifra3 : in std_logic_vector(3 downto 0);
  clk : in std_logic;
  cat : out std_logic_vector(6 downto 0);
  anod : out std_logic_vector(3 downto 0)
  );
end Ssd;

architecture Ssd_architecture of Ssd is

signal out_numarator : std_logic_vector(15 downto 0) := (others => '0'); 
signal out_MUX_1 : std_logic_vector(3 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if clk'event and clk = '1' then
            out_numarator <= out_numarator + 1;
        end if;
    end process;
    
    -- MUX_1
    process(cifra0, cifra1, cifra2, cifra3, out_numarator(15 downto 14))
    begin
        case out_numarator(15 downto 14) is
            when "00" => out_MUX_1 <= cifra0;
            when "01" => out_MUX_1 <= cifra1;
            when "10" => out_MUX_1 <= cifra2;
            when others => out_MUX_1 <= cifra3;
        end case;
    end process;
    
    -- MUX_2
    process(out_numarator(15 downto 14))
    begin
        case out_numarator(15 downto 14) is
            when "00" => anod <= "1110";
            when "01" => anod <= "1101";
            when "10" => anod <= "1011";
            when others => anod <= "0111";
        end case;
    end process;
      
          with out_MUX_1 select
       cat <=
                       --1
                       "1111001" when "0001",  
                       --2
                       "0100100" when "0010",  
                       --3
                       "0110000" when "0011",   
                       --4
                       "0011001" when "0100",   
                       --5
                       "0010010" when "0101",   
                       --6
                       "0000010" when "0110",   
                       --7
                       "1111000" when "0111",   
                       --8
                       "0000000" when "1000",   
                       --9
                       "0010000" when "1001",   
                       --A
                       "0001000" when "1010",   
                       --b
                       "0000011" when "1011",   
                       --C
                       "1000110" when "1100",   
                       --d
                       "0100001" when "1101",   
                       --E
                       "0000110" when "1110",   
                       --F
                       "0001110" when "1111",   
                       --0
                       "1000000" when others;   


end Ssd_architecture;