library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFetch is
  Port (clk, jump, PCSrc, jrsel, bltzsel, rst, en: IN std_logic;
        branch_addr, jump_addr, jr_addr: IN std_logic_vector(15 downto 0);
        instruction, next_addr: OUT std_logic_vector(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal inPC, outPC: std_logic_vector(15 downto 0);
signal adder_result: std_logic_vector(15 downto 0);
signal outMUX1, outMUX2, outMUX3: std_logic_vector(15 downto 0);

type mem_ROM is array(0 to 255) of std_logic_vector(15 downto 0);
signal ROM: mem_ROM := (
    -- cmmdc cele mai mari 2 nr pare
    B"000_000_000_001_0_000", -- add $1, $0, $0
    B"010_000_010_0000000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"100_010_001_0101010",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"010_001_011_0000100",
    B"001_000_101_0000001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_011_101_100_0_100",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"100_101_100_0011100",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"010_000_100_0000001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_011_100_101_0_001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"101_101_000_0000111",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"011_000_100_0000010",
    B"011_000_011_0000001",
    B"111_0000000101100",
    B"000_000_000_000_0_000",
    B"010_000_100_0000010",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_011_100_101_0_001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"101_101_000_0000100",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"011_000_011_0000010",
    B"001_001_001_0000001",
    B"111_0000000000100",
    B"000_000_000_000_0_000",
    B"010_000_001_0000001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"010_000_010_0000010",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"100_010_001_0010011",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_001_010_011_0_001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"101_011_000_0000110",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"011_000_011_0000001",
    B"111_0000000101111",
    B"000_000_000_000_0_000",
    B"000_010_001_010_0_001",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    B"011_000_010_0000010",
    B"111_0000000101111",
    B"000_000_000_000_0_000",
    B"011_000_001_0000011",
    B"000_000_000_000_0_000",
    B"000_000_000_000_0_000",
    others => x"FFFF"
);
begin

 PC:process(clk)
    begin
        if(rst = '1') then
            outPC <= x"0000";
        end if;
        
        if rising_edge(clk) then
            if(en = '1') then
              outPC <= inPC;
            end if;      
        end if;
    end process;
    
    instruction <= ROM(conv_integer(outPC));
    next_addr <= adder_result;
    adder_result <= outPC + 1;
    
MUX1:process(adder_result, branch_addr, PCSrc)
     begin
        if(PCSrc = '0') then
            outMUX1 <= adder_result;
        else
            outMUX1 <= branch_addr;    
        end if;
     end process;
     
MUX2: process(jump_addr, outMUX1, jump)
      begin
        if(jump = '0') then
            outMUX2 <= outMUX1;
        else
            outMUX2 <= jump_addr;    
        end if;
      end process;
      
      
MUX3: process(jr_addr, outMUX2, jrsel)
      begin
        if(jrsel = '0') then
            outMUX3 <= outMUX2;
        else
            outMUX3 <= jr_addr;    
        end if;
      end process;
      
      
MUX4: process(branch_addr, outMUX3, bltzsel)
      begin
        if(bltzsel = '0') then
            inPC <= outMUX3;
        else
            inPC <= branch_addr;    
        end if;
      end process;
      
                              
end Behavioral;
