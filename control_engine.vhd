library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
entity ALU_inst_executer is
port (
		inst_in : in std_logic_vector(31 downto 0);
		 pc_restore : in std_logic_vector(15 downto 0);
		status : in std_logic_vector(1 downto 0);
		clk, tx_busy, rx_busy, rx_error, timer_ack : in std_logic;
		toggle,EN, SEL, CMP_EN, buf_en, we,ALE, RE,tx_en, RS, timer_rst, ack_clr, ctrl, timer_en: out std_logic;
		OP_A, OP_B, WDST, RDST, CMP_R0, CMP_R1: out STD_LOGIC_VECTOR(4 DOWNTO 0);
	   FUNCT: out STD_LOGIC_VECTOR(3 DOWNTO 0);
	   mode, BFI, tctrl: out STD_LOGIC_VECTOR(1 DOWNTO 0);
	   DSS: out STD_LOGIC_VECTOR(2 DOWNTO 0);
	   DATA_to_alu : out STD_LOGIC_VECTOR(31 DOWNTO 0);
	   pc: out STD_LOGIC_VECTOR(15 DOWNTO 0)
		
	--   clk_rate : out STD_LOGIC_VECTOR(19 DOWNTO 0)

);
end ALU_inst_executer;

architecture Behavioral of ALU_inst_executer is

constant hold, external, D16: std_logic := '1';
constant released, internal, D8 : std_logic := '0';

constant io_device: std_logic_vector(2 downto 0):= "000";
constant program: std_logic_vector(2 downto 0):= "001";
constant UART_rx: std_logic_vector(2 downto 0):= "010";
constant memory: std_logic_vector(2 downto 0):= "011";
constant timer: std_logic_vector(2 downto 0):= "100";
constant PCount: std_logic_vector(2 downto 0):= "101";
constant ISR_vector : std_logic_vector(15 downto 0) := "0000000000111111";
signal index: std_logic_vector(1 downto 0);
signal timer_intruppt, halt : boolean := false;
constant zero : std_logic_vector(31 downto 0):="00000000000000000000000000000000";

signal ihld : std_logic;
signal state, istate, state_store : integer range 0 to 3;

signal PCNT : integer range 0 to 65535;

signal RCM : std_logic;
signal ENT : std_logic;
signal dtype : std_logic;
signal ack_toggle : std_logic := '0';
signal tff_clr : std_logic := '0';

signal inst: std_logic_vector(31 downto 0);

signal goto_location, imm_pc, PC_store: std_logic_vector(15 downto 0);
signal byte, word, dword: std_logic_vector(31 downto 0);
signal opcode : std_logic_vector(5 downto 0);
signal R0, R1, R2 : std_logic_vector(4 downto 0);
signal fx : std_logic_vector(3 downto 0);
--31 30 29 28 27 26| 25 24 23 22 21 | 20 19 18 17 16 |15 14 13, 12  11| 10 9 8 7 | 6 5 ,4 3 2 1
function inc (var : integer) return integer is
begin
 return var + 1;
end inc;

begin
sel <= RCM;
pc <= conv_std_logic_vector(pcnt, 16);
opcode <= inst(31 downto 26);
R0 <= inst(25 downto 21);  
R1 <= inst(20 downto 16);
r2 <= inst(15 downto 11);
Fx <= inst(10 downto 7);
byte(7 downto 0) <=inst(20 downto 13);
word(15 downto 0) <= inst(20 downto 5);
goto_location <= inst(15 downto 0);
imm_pc <= inst(25 downto 10);
with Dtype select data_to_alu <= byte when '0', word when '1';
toggle <= ack_toggle;
process(timer_ack, TFF_clr, timer_intruppt)
begin
if(timer_intruppt) then
   if tff_clr = '1' then 
      ack_toggle <= '0';
	else
     if rising_edge(timer_ack) then
	      ack_toggle <= not ack_toggle;
     end if;
   end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then 
  if Ihld = released then
	 inst <= inst_in;
	 end if;
	
	 end if;
	
	  
if falling_edge(clk) then 
--------------on timer intruppt enabled-------------------
if (timer_intruppt) then	
	  if ack_toggle = '1' then ---when ack flag set to high 
		IF ihld <= released then
	     if istate = 0 then
		     --state_store <= state;
			  halt <= true;---halt current execution
			  state <= 0;---reset to idle state
		     pc_store <= conv_std_logic_vector(pcnt, 16);---store current pc in PC_store register				  
		     istate <= inc(istate);--goto next IState 
			end if;
	  end if;
	  end if;
		  if istate = 1 then
			  inst <= zero;
			  istate <= inc(istate);
			  tff_clr <= '1'; --- strobe clear ack flag pulse
			  ack_clr <= '1';
			  timer_rst <= '1';
			  pcnt <= conv_integer(isr_vector);--goto inturrept vector location of program memory
			  
		  elsif istate = 2 then
			  istate <= 0;
			  ihld <= released; --release current instruction executing
		     tff_clr <= '0';
			  timer_rst <= '0';
			  ack_clr <= '0';
			  halt <= false;---enable Control engine FSM to execute instruction 
		  end if;
		  
end if;
if (halt = true) then 
 EN <= '0';
 rcm <= '0'; 
 CMP_EN <= '0';
 buf_en<= '0'; 
 we<= '0';
 ALE<= '0';
 RE<= '0';
 tx_en<= '0';
end if;

if(halt = false)then 		
------------instruction execution--------------------        
  if opcode = "000001" then  --function r0, r1, r2 function_type
  if state = 0 then
	    ihld <= hold;
		 en <= '1';
		 op_a <= r0;
       op_b <= r1;
		 wdst <= r2;
		 funct <= fx;
		 state <= inc(state);
		 RCM <= internal;
   elsif state =1 then 
		 en <= '0';
		 state <= 0;
		 ihld <= released;
		 pcnt <= inc(pcnt);
    end if;
	 
 elsif opcode = "000011" then --imm_byte R0:write_register, #value
	if state = 0 then
		ihld <= hold;
		RCM <= external;
		DSS <= PROGRAM;
		dtype <= D8;
		en <= '1';
		wdst <= r0;
		state <= inc(state);
	elsif state = 1 then
		en <= '0';
		ihld <= released;
		pcnt <= inc(pcnt);
		state <= 0;
	end if;
		
 elsif opcode = "000100" then --imm_word R0 #VALUE 
   if state = 0 then
		ihld <= hold;
		RCM <= external;
		DSS <= PROGRAM;
		dtype <= D16;
		en <= '1';
	elsif state = 1 then
	  ihld <= released;
	  en <= '0';
	  pcnt <= inc(pcnt);
	  state <= 0;
	 end if;
	 
 elsif opcode = "000101" then --goto #Location_X
		pcnt <= conv_integer(imm_pc);
 
 elsif opcode = "000110" then --BEQ r0,r1, location
	if state = 0 then 
	   ihld <= hold; --hold instruction
		cmp_r0 <= r0;
      cmp_r1 <= r1;
		cmp_en <= '1'; --enable comparator
	   state <= inc(state); -- goto next state
	elsif state = 1 then
	   cmp_en <= '0'; --disable comparators	
		ihld <= released;--release inst
		state <= 0; 	
--state <= inc(state);  
--	elsif state = 2 then 
 	   if status = "11" then --if r0 is equal to r1
	      pcnt <= conv_integer(goto_location);--load location to service rout		
		else 
		   pcnt <= inc(pcnt);--else increment 	
		end if;
	end if;
	
 elsif opcode = "000111" then --read_register:Rindex
	  if state = 0 then
	     ihld <= hold;
	     buf_en <= '1';
		  rdst <= r0;
		  state <= inc(state);
	  elsif state = 1 then
	     ihld <= released;
	     buf_en <= '0';
		  state <= 0;
	     pcnt <= inc(pcnt);
	  end if;
	  
 elsif opcode = "001000" then --LDAD #value // load address latch 
	  if state = 0 then
	    ihld <= hold;
	    ale <= '1';
		 mode <= "01"; --load imm address
		 state <= inc(state);
	  elsif state = 1 then
	    ihld <= released;
	    ale <= '0';
		 state <= 0;
		 pcnt <= inc(pcnt);
		end if; 
		
 elsif opcode = "001001" then --INC_ADL // INCREMENT address latch 
	  if state = 0 then
	    ihld <= hold;
	    ale <= '1';
		 mode <= "10"; -- INC address
		 state <= inc(state);
	  elsif state = 1 then
	    ihld <= released;
	    ale <= '0';
		 state <= 0;
		 pcnt <= inc(pcnt);
		end if; 
		
 elsif opcode = "001010" then --dec_ADL // INCREMENT address latch 
	  if state = 0 then
	    ihld <= hold;
	    ale <= '1';
		 mode <= "11"; -- dec address
		 state <= inc(state);
	  elsif state = 1 then
	    ihld <= released;
	    ale <= '0';
		 state <= 0;
		 pcnt <= inc(pcnt);
		 END IF;
		 
 elsif opcode = "001011" then --load r0, #location//load data from io device from specified loacation	 
		if state = 0 then 
		  ihld <= hold;
		  ale <= '1';
		  DSS <= memory;
		  mode <= "01";
		  state <= inc(state);
		  
		elsif state = 1 then
		  ale <= '0';
		  state <= inc(state);
		  re <= '1';
		  
      elsif state = 2 then 
        re <= '0';
		  rcm <= external;
		  en <= '1';
		  state <=inc(state);
		  
		elsif state = 3 then 
		  en <= '0';
		  ihld <= released;
		  pcnt <= inc(pcnt);
		  state <= 0;
		end if;
		
 elsif opcode = "001100" then --write rx, #location 
     if state = 0 then 
        ihld <= hold;
		  buf_en <= '1'; --strobe buffer reg to store rx value
		  rdst <= r0; --point to targer register
		  ale <= '1'; --enable address latch
		  mode <= "01";--set mode to load address
		  state <= inc(state); --goto next state
		  
	 elsif state = 1 then
		  buf_en <= '0'; --disable buffer en
		  ale <= '0'; --disable addr latch 
		  we <= '1'; --strobe write enable 
		  state <= inc(state);
		  
	elsif state = 2 then 
		  we <= '0';
		  ihld <= released;
		  pcnt <= inc(pcnt);
		  state <= 0;
	end if;
	
elsif opcode = "001101" then ---UART_TX Rx, BFI // transmit data from the Rx register
	if state = 0 then 
	   ihld <= hold;
		
		if tx_busy = '0' then 
			tx_en <= '1';
		   state <= inc(state);
			end if;
		BFI <= inst(20 downto 19); 
		
		elsif state = 1 then
    		tx_en <= '0';
		   ihld <= released;
			state <= 0;
			pcnt <= inc(pcnt);
		  
	end if;	
	
elsif opcode = "001110" then --UART_RX Rx, BFI //recieve byte and store into register		 
	if state = 0 then 
	 dss <= uart_rx;
		if rx_busy = '0'  then
		   bfi <= inst(20 downto 19);
			state <= inc(state);
		end if;
    elsif state = 1 then 
      ihld <= released;
		pcnt <= inc(pcnt);
		state <= 0;
	end if;
	
 elsif opcode = "001111" then --read_phy_io r0, #location//load data from io device from specified loacation	 
		if state = 0 then 
		  ihld <= hold;
		  ale <= '1';
		  DSS <= io_device;
		  mode <= "01";
		  state <= inc(state);
		  
		elsif state = 1 then
		  ale <= '0';
		  state <= inc(state);
		  re <= '1';
		  
      elsif state = 2 then 
        re <= '0';
		  rcm <= external;
		  en <= '1';
		  state <=inc(state);
		  
		elsif state = 3 then 
		  en <= '0';
		  ihld <= released;
		  pcnt <= inc(pcnt);
		  state <= 0;
		end if;
elsif opcode = "010000" then --read_sequential Rx
		if state = 0 then 
		  ihld <= hold;
		  DSS <= memory;
		  
		  state <= inc(state);
		  wdst <= r0;
		  re <= '1';
      elsif state = 1 then
		  re<= '0';
		  rcm <= external;
		  en <= '1';
        state <= inc(state);
      elsif state = 2 then
		  ihld <= released;
        en <= '0';
		  state <= 0;
		  pcnt <= inc(pcnt);
		 end if;
		 
elsif opcode = "010001" then --write_sequential Rx
    if state = 0 then 
		 ihld <= hold;
		 rdst <= r0;
		 state <= inc(state);
		 we <= '1';
	elsif state = 1 then
	   ihld <= released;
		state <= 0;
		we <= '0';
		pcnt <= inc(pcnt);
    end if;
	 --timer_en, ctrl, tcr0_clr,timer_reset,rs
elsif opcode = "010010" then --Timer Rx, (SetTimer/set auto clear flags )
    if state = 0 then
		ihld <= hold;
		ctrl <= '1';
		tctrl <= inst(20 downto 19);
		rdst <= R0;
	   state <= inc(state);
	elsif state = 1 then 
	   ctrl <= '0';
		ihld <= released;
		state <=0;
		pcnt <= inc(pcnt);
	end if;

elsif opcode = "010011" then --get_timer Rx
	 if state = 0 then
		ihld <= hold;
		Rs <= '0';
		rcm <= external;
		dss <= timer;
		wdst <= R0;
		en <= '1';
	   state <= inc(state);
	elsif state = 1 then 
	   en <= '0';
		ihld <= released;
		state <=0;
		pcnt <= inc(pcnt);
	end if;
elsif opcode = "010100" then --clear ack flag
	if state = 0 then
		ihld <= hold;
		ack_clr <= '1';
	   state <= inc(state);
	elsif state = 1 then 
	   ack_clr <= '0';
		ihld <= released;
		state <=0;
		pcnt <= inc(pcnt);
	end if;
elsif opcode = "010101" then --reset timer
	if state = 0 then
		ihld <= hold;
		timer_rst <= '1';
	   state <= inc(state);
	elsif state = 1 then 
	   timer_rst <= '0';
		ihld <= released;
		state <= 0;
		pcnt <= inc(pcnt);
	end if; 
elsif opcode = "010110" then --enable_timer_intrrupt
  timer_intruppt <= true;
  pcnt <= inc(pcnt);
  
elsif opcode = "010111" then --reset intrrupt state counter
   istate <= 0;
   pcnt <= inc(pcnt);
	
elsif opcode = "011100" then ---restore PC to normal execution route
	pcnt <= conv_integer(pc_store);

elsif opcode = "011101" then
  timer_intruppt <= false;
   pcnt <= inc(pcnt); 

elsif opcode = "011110" then 
   timer_en <= '1';
   pcnt <= inc(pcnt);  

elsif opcode = "011111" then 
   timer_en <= '0';
   pcnt <= inc(pcnt);  
elsif opcode = "100000" then --continue 
   pcnt <= inc(pcnt);  
end if;
end if;
end if;
end process;



end Behavioral;

