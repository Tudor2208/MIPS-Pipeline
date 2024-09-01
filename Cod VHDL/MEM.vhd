library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM is
  Port (MemWrite, en, clk: IN std_logic;
        ALUres, RD2: IN std_logic_vector(15 downto 0);
        MemData: OUT std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type ram_type is array (0 to 64) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (
    x"0005", -- vect_len
    x"0000", -- max1
    x"0000", -- max2
    x"0000", -- cmmdc
    
    x"001E", -- 30
    x"000D", -- 13
    x"0023", -- 35
    x"000A", -- 10
    x"002A", -- 42
    others => x"0000"
);
begin
  
       process(clk)
        begin
            MemData <= RAM(conv_integer(ALUres));
            if rising_edge(clk) then
                if(MemWrite = '1' and en = '1') then
                    RAM(conv_integer(ALUres)) <= RD2;
                end if;   
            end if;
        end process;

end Behavioral;
