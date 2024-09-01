
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity REG_FILE is
  Port (clk, en: in STD_LOGIC;
        RA1, RA2, WA: in STD_LOGIC_VECTOR(2 downto 0);
        WD: in STD_LOGIC_VECTOR(15 downto 0);
        RegWR: in STD_LOGIC;
        RD1, RD2: out STD_LOGIC_VECTOR(15 downto 0)
        );
end REG_FILE;

architecture Behavioral of REG_FILE is
type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
 x"0000",
 others => x"0000"
);
begin

write:process(clk) --scriere sincrona
      begin
        if falling_edge(clk) then
            if(RegWr = '1' and en = '1') then
                reg_file(conv_integer(WA)) <= WD;
            end if;
        end if;
      end process;

    -- citire asincrona
    RD1 <= reg_file(conv_integer(RA1));
    RD2 <= reg_file(conv_integer(RA2));
end Behavioral;
