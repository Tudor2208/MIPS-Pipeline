library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX is
  Port (RD1, RD2, Ext_imm: IN std_logic_vector(15 downto 0);
        ALUsrc, sa: IN std_logic;
        ALUctrl: IN std_logic_vector(2 downto 0);
        zero: out std_logic;
        ALURes: out std_logic_vector(15 downto 0));
end EX;

architecture Behavioral of EX is
signal A, B: std_logic_vector(15 downto 0);
signal result: std_logic_vector(15 downto 0);
begin

    A <= RD1;
    process(ALUsrc, RD2, Ext_imm)
    begin
       if(ALUsrc = '0') then
            B <= RD2;
       else
            B <= Ext_imm;     
       end if;
    end process;

    process(ALUctrl, A, B)
    begin
        case(ALUctrl) is
            when "000" => result <= A + B;
            when "100" => result <= A - B;
            when "010" => result <= A or B;
            when "001" => result <= A and B;
            when "110" => result <= A(14 downto 0) & '0';
            when "111" => result <= '0' & A(15 downto 1);
            when "101" => if(A(15) = '0') then
                            result <= '0' & A(15 downto 1);
                          else
                            result <= '0' & A(15 downto 1);
                          end if;
            when "011" => result <= A xor B;                
        end case;
    end process;
    
    zero <= '1' when result = x"0000" else '0';
    ALUres <= result;
end Behavioral;
