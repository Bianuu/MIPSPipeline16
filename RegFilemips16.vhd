library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegFilemips16 is
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
end RegFilemips16;

architecture RegFilemips16_architecture of RegFilemips16 is

    type vectRegistru is array (0 to 7) of std_logic_vector(15 downto 0);
    signal reg_file : vectRegistru := (
        others=>x"0000"
    );
begin
    process (clk) 
    begin
       if falling_edge(clk) then
            if RegWrite = '1' then
                if en = '1' then
                    reg_file(conv_integer(writeAdresa)) <= writeData;
                end if;
            end if;
        end if;
    end process;
    
    readData1 <= reg_file(conv_integer(readAdresa1));
    readData2 <= reg_file(conv_integer(readAdresa2));

end RegFilemips16_architecture;