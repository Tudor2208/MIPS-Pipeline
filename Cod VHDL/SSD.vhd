----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2022 12:23:24
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( clk : in STD_LOGIC;
           number: in STD_LOGIC_VECTOR(15 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal outmux1: STD_LOGIC_VECTOR(3 downto 0);
signal nr: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

begin
    -- MUX 4:1 (primul)
    process(number, nr)
	begin
		if nr(15 downto 14) = "00" then outmux1 <= number(3 downto 0);
		elsif nr(15 downto 14) = "01" then outmux1 <= number(7 downto 4);
		elsif nr(15 downto 14) = "10" then outmux1 <= number(11 downto 8);
		else outmux1 <= number(15 downto 12);
		end if;	
	end process;


    --  COUNTER
    process(clk)
    begin
        if(clk = '1' and clk'event) then
          nr <= nr + 1;
        end if;
    end process;


    -- MUX 4:1 (al doilea)
    process(nr)
	begin
		if nr(15 downto 14) = "00" then an <= "1110";
		elsif nr(15 downto 14) = "01" then an <= "1101";
		elsif nr(15 downto 14) = "10" then an <= "1011";
		else an <= "0111";
		end if;	
	end process;
	
	
	process(outmux1)
    begin
    case outmux1 is
        when x"0" => cat<="1000000";
        when x"1" => cat<="1111001";
        when x"2"=> cat<="0100100";
        when x"3" => cat<="0110000";
        when x"4" => cat<="0011001";
        when x"5" => cat<="0010010";
        when x"6" => cat<="0000010";
        when x"7" => cat<="1111000";
        when x"8" => cat<="0000000";
        when x"9" => cat<= "0010000";
        when x"A" => cat <= "0001000";
        when x"B" => cat <= "0000011";
        when x"C" => cat <= "1000110";
        when x"D" => cat <= "0100001";
        when x"E" => cat <= "0000110";
        when x"F" => cat <= "0001110"; 
        when others => cat <= "1111111";
    end case;
    end process;
end Behavioral;
