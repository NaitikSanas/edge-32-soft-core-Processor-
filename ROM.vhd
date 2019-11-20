library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ROM is
port (
address : in std_logic_vector(5 downto 0);
data : out std_logic_vector(31 downto 0)
);
end ROM;

architecture Behavioral of ROM is
type PROM is array(0 to 63) of std_logic_vector(31 downto 0);
---immidiate data declaration 
constant imm_byte : std_logic_vector(5 downto 0):="000011";
constant imm_word : std_logic_vector(5 downto 0):="000100";

---control execution flow
constant goto : std_logic_vector(5 downto 0):="000101";
constant BEQ : std_logic_vector(5 downto 0):="000110";

---uart transmission
constant uart_tx : std_logic_vector(5 downto 0):="001101";
constant uart_rx : std_logic_vector(5 downto 0):="001110";

--data read write operation to memory and IO----
constant write_buffer : std_logic_vector(5 downto 0):="000111";
constant write_data : std_logic_vector(5 downto 0):="001100";
constant read_data : std_logic_vector(5 downto 0):="001011";
constant inc_addr : std_logic_vector(5 downto 0):="001001";
constant dec_addr : std_logic_vector(5 downto 0):="001010";
constant read_seq : std_logic_vector(5 downto 0):="010000";
constant write_seq : std_logic_vector(5 downto 0):="010001";

-------timer instructions
constant timer : std_logic_vector(5 downto 0):="010010";
constant get_time : std_logic_vector(5 downto 0):="010011";
constant glr_Ack_flag : std_logic_vector(5 downto 0):="010100";
constant reset_timer: std_logic_vector(5 downto 0):="010101";
constant enable_timer_interrupt: std_logic_vector(5 downto 0):="010110";
constant disable_timer_interrupt: std_logic_vector(5 downto 0):="011101";
constant rst_isc: std_logic_vector(5 downto 0):="010111";
constant set_creg: std_logic_vector(1 downto 0):="01";
constant enable_timer: std_logic_vector(5 downto 0):=  "011110";
constant disable_timer: std_logic_vector(5 downto 0):= "011111";
constant restore_pc: std_logic_vector(5 downto 0):=    "011100";

---alu operation 
constant FunctionX : std_logic_vector(5 downto 0):="000001";
constant ADD : std_logic_vector(3 downto 0):="0000";
constant inc : std_logic_vector(3 downto 0):="1001";
constant not_X : std_logic_vector(3 downto 0):="1000";
constant nop : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
constant continue: std_logic_vector(5 downto 0):= "100000";

----blanking constants
constant imm_byte_blank : std_logic_vector(12 downto 0):="0000000000000";
constant fx_blank : std_logic_vector(6 downto 0):="0000000";
constant Wbuf_blank : std_logic_vector(20 downto 0):= "000000000000000000000";
constant goto_blank : std_logic_vector(9 downto 0):= "0000000000";
constant uart_blank : std_logic_vector(18 downto 0):= "0000000000000000000" ;
constant write_blank : std_logic_vector(4 downto 0):= "00000";
constant read_blank : std_logic_vector(4 downto 0):= "00000";
constant id_blank : std_logic_vector(25 downto 0):= "00000000000000000000000000";
constant wrseq_blank: std_logic_vector(20 downto 0):= "000000000000000000000";
constant eti_blank: std_logic_vector(25 downto 0):=   "00000000000000000000000000";
constant timer_blank: std_logic_vector(18 downto 0):= "0000000000000000000";

----program execution Routes-------------
constant main_route : std_logic_vector(15 downto 0):=         "0000000000001000";
constant route1 : std_logic_vector(15 downto 0):=             "0000000000001101";
constant timer_isr_main : std_logic_vector(15 downto 0):=     "0000000000010101";
constant restore_route : std_logic_vector(15 downto 0):=      "0000000000011010";
constant timer_isr : std_logic_vector(15 downto 0):=          "0000000000010010";
constant var_initialization : std_logic_vector(15 downto 0):= "0000000000000010";

---register file access pointers
constant R0 : std_logic_vector(4 downto 0):= "00000";
constant R1 : std_logic_vector(4 downto 0):= "00001";
constant R2 : std_logic_vector(4 downto 0):= "00010";
constant R3 : std_logic_vector(4 downto 0):= "00011";
constant R4 : std_logic_vector(4 downto 0):= "00100";
constant R5 : std_logic_vector(4 downto 0):= "00101";
constant R6 : std_logic_vector(4 downto 0):= "00110";
constant R7 : std_logic_vector(4 downto 0):= "00111";
constant R8 : std_logic_vector(4 downto 0):= "01000";
constant R9 : std_logic_vector(4 downto 0):= "01001";
constant R10 : std_logic_vector(4 downto 0):="01010";

--31 30 29 28 27 26| 25 24 23 22 21 | 20 19 18 17 16 |15 14 13 12  11| 10 9 8 7 | 6 5 4 3 2 1 0
constant program :PROM := (
---boot initialization---
goto & var_initialization & goto_blank,       ---00000
goto & timer_ISR & goto_blank,                ---00001

---program variables initialization--
imm_byte & R7 & "00000001" & imm_byte_blank,   --00010
imm_byte & R6 & "11110000" & imm_Byte_blank,   --00011
imm_byte & R2 & "00011111" & imm_byte_blank,   --00100

---interrupt initialization---
timer & R2 & Set_Creg & timer_blank,           --00101
enable_timer_interrupt & ETI_blank,            --00110
enable_timer & eti_blank,                      --00111

------general tasks-----------
---main route---
functionX & R0 & R7& R0 & add & fx_blank,      --01000
write_seq & r0 &  wrseq_blank,                 --01001
inc_addr & ID_blank,                           --01010
beq & r0 & r6 & route1,                        --01011
goto& main_route & goto_blank,                 --01100

--sub route 1---
read_seq & R3 & wRseq_blank,                   --01101
write_buffer & r3 & wbuf_blank,                --01110
dec_addr & id_blank,                           --01111
goto & route1 & goto_blank,                    --10000
---------------------------------


--------timer ISR---------------
---timer intrrupt reset handler
continue & eti_blank,                   --10001
                          
---timer ISR Var Initialization------
imm_byte & R8 & "00001111" & imm_byte_blank,   --10010
imm_byte & R9 & "00000111" & imm_byte_blank,   --10011
imm_byte & r10& "00000000" & imm_byte_blank,--10100
---timer ISR main
write_buffer & r8 & wbuf_blank,                --10101
functionX & r8 & r1 & R8 & inc &fx_blank,     --10110

functionX & R10 & R0 & R10 & inc & fx_blank,     --10111
beq & R9 & R10 & restore_route,                 --11000
goto & timer_isr_main& goto_blank,             --11001

--timer ISR return address restore
restore_pc & eti_blank,                        --11010

------end timer ISR ------


---unallocated sector--
nop, --11011
nop,--11100
nop,--11101
nop,--11110
nop,--11111
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
nop,
goto & timer_ISR & goto_blank
);
begin


process(address)
begin
data <= Program(conv_integer(address));
end process;
end Behavioral;

