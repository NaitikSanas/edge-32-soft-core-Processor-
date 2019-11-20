library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity timer is
port(
      data_in : in std_logic_vector(25 downto 0);
		tctrl : in std_logic_vector(1 downto 0);
		sys_clk,timer_clk, timer_en, ctrl, tcr0_clr,timer_reset,rs: in std_logic;
	   time_out_Ack0: out std_logic;
		data_out: out std_logic_vector(25 downto 0)
		
);
end timer;

architecture Behavioral of timer is

signal timer_reg : integer range 0 to 67_108_863; 
signal trst_cnt : integer range 0 to 65535;
signal tcr0 : integer range 0 to  67_108_863;
signal aclr_flags : boolean := false;
constant time_threshold : integer := 49_999_999;
signal a, b : std_logic_Vector(25 downto 0);
begin
a <= conv_std_logic_vector(timer_reg, 26);
b(15 downto 0) <= conv_std_logic_vector(trst_cnt, 16);
b(25 downto 16) <= "0000000000";
with RS select data_out <=a when '0', b when '1'; 
process(sys_clk, ctrl)
begin
----control modes---
----set time compare registers R0, R1, R2, R3.
----capture timer value.
----enable/disable time out acknowlegment for multiple channels
if ctrl = '1' then
   if rising_edge(sys_clk) then
      if tctrl = "01" then
			TCR0 <= conv_integer(data_in);
		elsif tctrl = "10" then
		  ACLR_flags <= true;
		elsif tctrl = "11" then
		  ACLR_flags <= false;
		end if;
	end if;
end if;
end process;

process(timer_clk, timer_en,timer_reset, tcr0_clr)
begin	   
if timer_reset = '1' then 
	  timer_reg <= 0;
	  trst_cnt <= 0;
	  else	
     if timer_en = '1' then	
        if rising_edge(timer_clk) then
		     if timer_reg =  time_threshold then
		        trst_cnt <= trst_cnt+1;	
			     timer_reg <= 0;
		        if (aclr_flags) then 
				      time_out_ack0 <= '0';
		        end if; 
		     else			
			     timer_Reg <= timer_reg + 1;
		     end if;
		
			    if timer_reg = TCR0 then 
			    time_out_ack0 <= '1'; 
			    end if;	
		  end if;
     end if;
end if;

if tcr0_clr = '1' then time_out_ack0 <= '0'; end if;

end process;


end Behavioral;

