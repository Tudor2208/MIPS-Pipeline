library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           
           led : out STD_LOGIC_VECTOR(15 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG1
    Port ( clk : in STD_LOGIC;
           btn: in STD_LOGIC;
           en: out STD_LOGIC);
end component;

component IFetch
  Port (clk, jump, PCSrc, jrsel, bltzsel, rst, en: IN std_logic;
        branch_addr, jump_addr, jr_addr: IN std_logic_vector(15 downto 0);
        instruction, next_addr: OUT std_logic_vector(15 downto 0));
end component;

component SSD
    Port ( clk : in STD_LOGIC;
           number: in STD_LOGIC_VECTOR(15 downto 0);
           cat: out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0));
end component;

component IDecode
  Port (
         Clk, RegWrite, RegDst, ExtOp, en: IN std_logic;
         Instruction, WD: IN std_logic_vector(15 downto 0);
         RD1, RD2, ExtImm: OUT std_logic_vector(15 downto 0);
         WA: IN std_logic_vector(2 downto 0);
         Sa: OUT std_logic;
         func: OUT std_logic_vector(2 downto 0));
end component;

component UC
 Port (opcode, func: IN std_logic_vector(2 downto 0);
       ALUctrl: OUT std_logic_vector(2 downto 0);
       RegDst, RegWrite, ALUSrc, ExtOp, MemWrite, MemtoReg, Branch, Jump, JRsel, BLTZsel: out std_logic);
end component;

component EX
  Port (RD1, RD2, Ext_imm: IN std_logic_vector(15 downto 0);
        ALUsrc, sa: IN std_logic;
        ALUctrl: IN std_logic_vector(2 downto 0);
        zero: out std_logic;
        ALURes: out std_logic_vector(15 downto 0));
end component;

component MEM
  Port (MemWrite, en, clk: IN std_logic;
        ALUres, RD2: IN std_logic_vector(15 downto 0);
        MemData: OUT std_logic_vector(15 downto 0));
end component;

signal digits, instr, nextadr, num1, num2, ext, result, mem_data, write_data, br_address, j_address: std_logic_vector(15 downto 0);
signal en0, en1, jmps, branchs, regwrs, regdsts, extops, jrsels, bltzsels, bltzsels_aux, memtoregs, alusrcs, memwrites, zeros, pcsrcs, sas: std_logic;
signal aluctrls, funcs: std_logic_vector(2 downto 0);
signal writeadress_temp: std_logic_vector(2 downto 0);

-- PIPELINE REGISTERS
-- IF/ID
signal instr_IF_ID, nextadr_IF_ID: std_logic_vector(15 downto 0);

-- ID/EX
signal writeadress_ID_EX:std_logic_vector(2 downto 0);
signal nextadr_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX: std_logic_vector(15 downto 0);
signal aluctrl_ID_EX: std_logic_vector(2 downto 0);
signal memtoreg_ID_EX, regwrite_ID_EX, memwrite_ID_EX, branch_ID_EX, bltzsel_ID_EX, alusrc_ID_EX: std_logic;

-- EX/MEM
signal branchAddr_EX_MEM, alures_EX_MEM, RD1_EX_MEM, RD2_EX_MEM: std_logic_vector(15 downto 0);
signal zero_EX_MEM, memtoreg_EX_MEM, regwrite_EX_MEM, memwrite_EX_MEM, branch_EX_MEM, bltzsel_EX_MEM: std_logic;
signal writeadress_EX_MEM:std_logic_vector(2 downto 0);

-- MEM/WB
signal writeadress_MEM_WB:std_logic_vector(2 downto 0);
signal alures_MEM_WB, readdata_MEM_WB: std_logic_vector(15 downto 0);
signal memtoreg_MEM_WB, regwrite_MEM_WB: std_logic;


begin
 
    display: SSD port map (clk => clk, number => digits, cat => cat, an => an);
    instr_fetch: IFetch port map (clk => clk, jump => jmps, PCSrc => pcsrcs, rst => en1, en => en0, branch_addr => branchAddr_EX_MEM, jump_addr => j_address, instruction => instr, next_addr => nextadr, jrsel => jrsels, bltzsel => bltzsels, jr_addr => num1);
    instr_decode: IDecode port map (en => en0, clk => clk, regWrite => regwrite_MEM_WB, RegDst => regdsts, ExtOp => extops, Instruction => instr_IF_ID, WD => write_data, RD1 => num1, RD2 => num2, extimm => ext, sa => sas, func => funcs, WA => writeadress_MEM_WB);
    unit_control: UC port map (opcode => instr_IF_ID(15 downto 13), func => funcs, ALUctrl => aluctrls, RegDst => regdsts, RegWrite => regwrs, ALUsrc => alusrcs, ExtOp => extops, MemWrite => memwrites, MemtoReg => memtoregs, Branch => branchs, Jump => jmps, Jrsel => jrsels, BLTZsel => bltzsels_aux);
    ALU: EX port map(RD1 => RD1_ID_EX, RD2 => RD2_ID_EX, Ext_imm => Ext_imm_ID_EX, ALUsrc => alusrc_ID_EX, sa => sas, ALUctrl => aluctrl_ID_EX, zero => zeros, ALUres => result);
    RAM: MEM port map(MemWrite => memwrite_EX_MEM, en => en0, clk => clk, ALUres => alures_EX_MEM, RD2 => RD2_EX_MEM, MemData => mem_data); 
    
    monopuls: MPG1 port map (clk => clk, btn => btn(0), en => en0); 
    monopuls2: MPG1 port map (clk => clk, btn => btn(1), en => en1); 
    
    pcsrcs <= branch_EX_MEM and zero_EX_MEM;
    bltzsels <= RD1_EX_MEM(15) and bltzsel_EX_MEM;
    
    j_address <= "000" & instr_IF_ID(12 downto 0);
    
    
    process(memtoreg_MEM_WB, alures_MEM_WB, readdata_MEM_WB)
    begin
        if(memtoreg_MEM_WB = '0') then write_data <= alures_MEM_WB;
            else write_data <= readdata_MEM_WB;
        end if; 
    end process;
    
    process(sw, instr_IF_ID, nextadr_IF_ID, RD1_ID_EX, RD2_ID_EX, writeadress_EX_MEM)
    begin
        case sw(7 downto 5) is
            when "000" => digits <= instr_IF_ID;
            when "001" => digits <= nextadr_IF_ID;
            when "010" => digits <= RD1_ID_EX;
            when "011" => digits <= RD2_ID_EX;
            when "100" => digits <= Ext_imm_ID_EX;
            when "101" => digits <= alures_EX_MEM;
            when "110" => digits <= readdata_MEM_WB;
            when "111" => digits <= x"000" & '0' & writeadress_EX_MEM;
        end case;
    end process;
    
    led <= "000" & regdsts & regwrite_ID_EX & alusrc_ID_EX & extops & memwrites & memtoregs & branch_EX_MEM & jmps & jrsels & bltzsel_EX_MEM & aluctrls;
    
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en0 = '1' then
                -- IF/ID
                instr_IF_ID <= instr;
                nextadr_IF_ID <= nextadr;
                
                -- ID/EX
                nextadr_ID_EX <= nextadr_IF_ID;
                RD1_ID_EX <= num1;
                RD2_ID_EX <= num2;
                Ext_imm_ID_EX <= ext;
                aluctrl_ID_EX <= aluctrls;
                writeadress_ID_EX <= writeadress_temp;
                memtoreg_ID_EX <= memtoregs;
                regwrite_ID_EX <= regwrs;
                memwrite_ID_EX <= memwrites;
                branch_ID_EX <= branchs;
                bltzsel_ID_EX <= bltzsels;
                alusrc_ID_EX <= alusrcs;
                
                
                -- EX/MEM
                alures_EX_MEM <= result;
                branchAddr_EX_MEM <= Ext_imm_ID_EX + nextadr_ID_EX;
                zero_EX_MEM <= zeros;
                writeadress_EX_MEM <= writeadress_ID_EX;
                RD2_EX_MEM <= RD2_ID_EX;
                RD1_EX_MEM <= RD1_ID_EX;
                memtoreg_EX_MEM <= memtoreg_ID_EX;
                regwrite_EX_MEM <= regwrite_ID_EX;
                memwrite_EX_MEM <= memwrite_ID_EX;
                branch_EX_MEM <= branch_ID_EX;
                bltzsel_EX_MEM <= bltzsel_ID_EX;
                
                
                -- MEM/WB
                memtoreg_MEM_WB <= memtoreg_EX_MEM;
                regwrite_MEM_WB <= regwrite_EX_MEM;
                alures_MEM_WB <= alures_EX_MEM;
                writeadress_MEM_WB <= writeadress_EX_MEM;
                readdata_MEM_WB <= mem_data;
                
            end if;
        end if;
    end process;
    
    process(regdsts, writeadress_ID_EX, instr_IF_ID)
    begin
        if(regdsts = '0') then writeadress_temp <= instr_IF_ID(9 downto 7);
         else writeadress_temp <= instr_IF_ID(6 downto 4);
        end if; 
    end process;
    
end Behavioral;
