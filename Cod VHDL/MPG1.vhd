----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2022 12:59:30
-- Design Name: 
-- Module Name: MPG1 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG1 is
    Port ( clk : in STD_LOGIC;
           btn: in STD_LOGIC;
           en: out STD_LOGIC);
end MPG1;

architecture Behavioral of MPG1 is
signal count_int: std_logic_vector(31 downto 0):= x"00000000";
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;
begin

    en <= Q2 and (not Q3);
    process(clk)
    begin
        if(clk = '1' and clk'event) then
          if count_int(15 downto 0) = "1111111111111111" then
            Q1 <= btn;
            end if;
         end if; 
    end process;
    
    
    process(clk)
    begin
        if(clk'event and clk = '1') then
            count_int <= count_int + 1;
        end if;
    end process;
    
    
    process(clk)
    begin
        if(clk = '1' and clk'event) then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
    
    
end Behavioral;
