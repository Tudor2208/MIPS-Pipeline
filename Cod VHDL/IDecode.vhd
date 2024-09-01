library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IDecode is
  Port (
         Clk, RegWrite, RegDst, ExtOp, en: IN std_logic;
         Instruction, WD: IN std_logic_vector(15 downto 0);
         RD1, RD2, ExtImm: OUT std_logic_vector(15 downto 0);
         WA: IN std_logic_vector(2 downto 0);
         Sa: OUT std_logic;
         func: OUT std_logic_vector(2 downto 0));
end IDecode;

architecture Behavioral of IDecode is
component REG_FILE
  Port (clk, en: in STD_LOGIC;
        RA1, RA2, WA: in STD_LOGIC_VECTOR(2 downto 0);
        WD: in STD_LOGIC_VECTOR(15 downto 0);
        RegWR: in STD_LOGIC;
        RD1, RD2: out STD_LOGIC_VECTOR(15 downto 0)
        );
end component;

begin

    RF: REG_FILE port map(clk => clk, en => en, RA1 => Instruction(12 downto 10), RA2 => Instruction(9 downto 7), WA => WA, WD => WD, RegWR => RegWrite, RD1 => RD1, RD2 => RD2);  

    process(Instruction, ExtOP)
    begin
        case ExtOP is
            when '0' => ExtImm <= "000000000" & Instruction(6 downto 0);
            when '1' => 
                        if(Instruction(6) = '1') then
                            ExtImm <= "111111111" & Instruction(6 downto 0);
                        else
                            ExtImm <= "000000000" & Instruction(6 downto 0);
                        end if;  
        end case;
    end process;
    
    func <= Instruction(2 downto 0);
    sa <= Instruction(3);

end Behavioral;
