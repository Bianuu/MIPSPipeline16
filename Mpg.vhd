library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mpg is
  Port ( 
        clk : in std_logic;
        btn : in std_logic;
        en : out std_logic 
        );
end Mpg;

architecture Mpg_architecture of Mpg is

signal count : std_logic_vector(17 downto 0) := (others => '0');
signal q1 : std_logic:='0';
signal q2 : std_logic:='0';
signal q3 : std_logic:='0';

begin

process(clk)
begin
    if rising_edge(clk) then
        count <= count + 1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if count(17 downto 0) = "111111111111111111" then
            q1 <= btn;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        q2 <= q1;
        q3 <= q2;
    end if;
end process;

en <= q2 and (not q3);

end Mpg_architecture;