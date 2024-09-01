library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC is
 Port (opcode, func: IN std_logic_vector(2 downto 0);
       ALUctrl: OUT std_logic_vector(2 downto 0);
       RegDst, RegWrite, ALUSrc, ExtOp, MemWrite, MemtoReg, Branch, Jump, JRsel, BLTZsel: out std_logic);
end UC;

architecture Behavioral of UC is
signal ALUop: std_logic_vector(1 downto 0);
begin

    process(opcode)
    begin
       RegDst <= '0'; RegWrite <= '0'; ALUSrc <= '0'; ExtOp <= '0'; MemWrite <= '0';
       MemtoReg <= '0'; Branch <= '0'; Jump <= '0'; JRsel <= '0'; BLTZsel <= '0';
       case opcode is
            when "001" => RegWrite <= '1'; ALUsrc <= '1'; EXTOp <= '1'; ALUop <= "00"; -- ADDI
            when "010" => RegWrite <= '1'; ALUsrc <= '1'; ExtOp <= '1'; MemtoReg <= '1'; ALUop <= "00"; -- LW
            when "011" => ALUsrc <= '1';  ExtOp <= '1'; MemWrite <= '1'; AluOp <= "00"; -- SW
            when "100" => ExtOp <= '1'; Branch <= '1'; ALUop <= "01"; -- BEQ
            when "101" => ExtOp <= '1'; BLTZsel <= '1'; -- BLTZ
            when "110" => jrsel <= '1'; -- JR
            when "111" => jump <= '1'; -- J
            when "000" => RegDst <= '1'; RegWrite <= '1'; ALUop <= "10"; -- Instr de tip R
       end case;
      end process;
       
      process(func, ALUop)
      begin
       if(ALUOp = "10") then
            case func is
                when "000" => ALUctrl <= "000"; -- adunare
                when "001" => ALUctrl <= "100"; -- scadere
                when "101" => ALUctrl <= "010"; -- OR
                when "100" => ALUctrl <= "001"; -- AND
                when "010" => ALUctrl <= "110"; -- sll
                when "011" => ALUctrl <= "111"; -- srl
                when "110" => ALUctrl <= "101"; -- sra (shiftare cu semn)
                when "111" => ALUctrl <= "011"; -- XOR
            end case;
            
        elsif ALUop = "00" then ALUctrl <= "000";
        elsif ALUOp = "01" then ALUctrl <= "100";    
            
       end if;
      end process;

end Behavioral;
