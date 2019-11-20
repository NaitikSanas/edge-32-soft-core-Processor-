----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:13 09/26/2019 
-- Design Name: 
-- Module Name:    Register_file - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.NUMERIC_STD.ALL;

entity Register_file is
port (
		DATA0, DATA1 : in std_logic_Vector(31 downto 0);
		WDest, op_a, op_b, CMP_R0, CMP_R1, RDST: in std_logic_Vector(4 downto 0);
		clk, en, SEL : in std_logic;
		a, b, CMP_OPA, CMP_OPB, DOUT: OUT std_logic_Vector(31 downto 0)

);
end Register_file;

architecture Behavioral of Register_file is


COMPONENT MUX32L
	PORT(
		D0 : IN std_logic_vector(31 downto 0);
		D1 : IN std_logic_vector(31 downto 0);
		D2 : IN std_logic_vector(31 downto 0);
		D3 : IN std_logic_vector(31 downto 0);
		D4 : IN std_logic_vector(31 downto 0);
		D5 : IN std_logic_vector(31 downto 0);
		D6 : IN std_logic_vector(31 downto 0);
		D7 : IN std_logic_vector(31 downto 0);
		D8 : IN std_logic_vector(31 downto 0);
		D9 : IN std_logic_vector(31 downto 0);
		D10 : IN std_logic_vector(31 downto 0);
		D11 : IN std_logic_vector(31 downto 0);
		D12 : IN std_logic_vector(31 downto 0);
		D13 : IN std_logic_vector(31 downto 0);
		D14 : IN std_logic_vector(31 downto 0);
		D15 : IN std_logic_vector(31 downto 0);
		D16 : IN std_logic_vector(31 downto 0);
		D17 : IN std_logic_vector(31 downto 0);
		D18 : IN std_logic_vector(31 downto 0);
		D19 : IN std_logic_vector(31 downto 0);
		D20 : IN std_logic_vector(31 downto 0);
		D21 : IN std_logic_vector(31 downto 0);
		D22 : IN std_logic_vector(31 downto 0);
		D23 : IN std_logic_vector(31 downto 0);
		D24 : IN std_logic_vector(31 downto 0);
		D25 : IN std_logic_vector(31 downto 0);
		D26 : IN std_logic_vector(31 downto 0);
		D27 : IN std_logic_vector(31 downto 0);
		D28 : IN std_logic_vector(31 downto 0);
		D29 : IN std_logic_vector(31 downto 0);
		D30 : IN std_logic_vector(31 downto 0);
		D31 : IN std_logic_vector(31 downto 0);
		PTR : IN std_logic_vector(4 downto 0);          
		DOUT : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;


SIGNAL DIN : STD_LOGIC_VECTOR(31 DOWNTO 0):="00000000000000000000000000000000";
signal D0, D1, D2, D3, D4, D5, D6, D7, D8, D9 , D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28 ,D29, D30, D31 :  std_logic_Vector(31 downto 0):= "00000000000000000000000000000000";
begin
WITH SEL SELECT DIN <= DATA0 WHEN '0', DATA1 WHEN '1', "00000000000000000000000000000000" WHEN OTHERS;

	
	MUX32L_OUT: MUX32L PORT MAP(
		D0 => D0 ,
		D1 => D1 ,
		D2 => D2,
		D3 => D3,
		D4 => D4,
		D5 => D5,
		D6 => D6,
		D7 => D7,
		D8 => D8,
		D9 => D9,
		D10 => D10,
		D11 => D11,
		D12 => D12,
		D13 => D13,
		D14 => D14,
		D15 => D15,
		D16 => D16,
		D17 => D17,
		D18 => D18,
		D19 => D19,
		D20 => D20,
		D21 => D21,
		D22 => D22,
		D23 => D23,
		D24 => D24,
		D25 => D25,
		D26 => D26,
		D27 => D27,
		D28 => D28,
		D29 => D29,
		D30 => D30,
		D31 => D31,
		PTR => RDST,
		DOUT => DOUT
	);
	
	MUX32L_A: MUX32L PORT MAP(
		D0 => D0 ,
		D1 => D1 ,
		D2 => D2,
		D3 => D3,
		D4 => D4,
		D5 => D5,
		D6 => D6,
		D7 => D7,
		D8 => D8,
		D9 => D9,
		D10 => D10,
		D11 => D11,
		D12 => D12,
		D13 => D13,
		D14 => D14,
		D15 => D15,
		D16 => D16,
		D17 => D17,
		D18 => D18,
		D19 => D19,
		D20 => D20,
		D21 => D21,
		D22 => D22,
		D23 => D23,
		D24 => D24,
		D25 => D25,
		D26 => D26,
		D27 => D27,
		D28 => D28,
		D29 => D29,
		D30 => D30,
		D31 => D31,
		PTR => OP_A,
		DOUT => A
	);
MUX32L_B: MUX32L PORT MAP(
		D0 =>D0 ,
		D1 =>D1 ,
		D2 =>D2 ,
		D3 =>D3 ,
		D4 =>D4 ,
		D5 =>D5 ,
		D6 =>D6 ,
		D7 =>D7 ,
		D8 =>D8 ,
		D9 =>D9,
		D10 =>D10 ,
		D11 => D11,
		D12 =>D12 ,
		D13 =>D13 ,
		D14 =>D14 ,
		D15 =>D15 ,
		D16 =>D16 ,
		D17 =>D17 ,
		D18 =>D18,
		D19 =>D19 ,
		D20 =>D20 ,
		D21 =>D21,
		D22 =>D22 ,
		D23 =>D23 ,
		D24 =>D24 ,
		D25 =>D25 ,
		D26 =>D26 ,
		D27 =>D27 ,
		D28 =>D28 ,
		D29 =>D29 ,
		D30 =>D30 ,
		D31 =>D31 ,
		PTR => OP_B,
		DOUT => B 
	);
MUX32L_CMP_A: MUX32L PORT MAP(
		D0 =>D0 ,
		D1 =>D1 ,
		D2 =>D2 ,
		D3 =>D3 ,
		D4 =>D4 ,
		D5 =>D5 ,
		D6 =>D6 ,
		D7 =>D7 ,
		D8 =>D8 ,
		D9 =>D9,
		D10 =>D10 ,
		D11 => D11,
		D12 =>D12 ,
		D13 =>D13 ,
		D14 =>D14 ,
		D15 =>D15 ,
		D16 =>D16 ,
		D17 =>D17 ,
		D18 =>D18,
		D19 =>D19 ,
		D20 =>D20 ,
		D21 =>D21,
		D22 =>D22 ,
		D23 =>D23 ,
		D24 =>D24 ,
		D25 =>D25 ,
		D26 =>D26 ,
		D27 =>D27 ,
		D28 =>D28 ,
		D29 =>D29 ,
		D30 =>D30 ,
		D31 =>D31 ,
		PTR => CMP_R0,
		DOUT => CMP_OPA 
	);
MUX32L_CMP_B: MUX32L PORT MAP(
		D0 =>D0 ,
		D1 =>D1 ,
		D2 =>D2 ,
		D3 =>D3 ,
		D4 =>D4 ,
		D5 =>D5 ,
		D6 =>D6 ,
		D7 =>D7 ,
		D8 =>D8 ,
		D9 =>D9,
		D10 =>D10 ,
		D11 => D11,
		D12 =>D12 ,
		D13 =>D13 ,
		D14 =>D14 ,
		D15 =>D15 ,
		D16 =>D16 ,
		D17 =>D17 ,
		D18 =>D18,
		D19 =>D19 ,
		D20 =>D20 ,
		D21 =>D21,
		D22 =>D22 ,
		D23 =>D23 ,
		D24 =>D24 ,
		D25 =>D25 ,
		D26 =>D26 ,
		D27 =>D27 ,
		D28 =>D28 ,
		D29 =>D29 ,
		D30 =>D30 ,
		D31 =>D31 ,
		PTR => CMP_R1,
		DOUT => CMP_OPB 
	);

WRITE_DATA:PROCESS(CLK, EN)
BEGIN
IF EN = '1' THEN
IF RISING_EDGE(CLK) THEN
	IF WDEST = "00000" THEN D0 <= DIN;
	ELSIF WDEST = "00001" THEN D1 <= DIN;
	ELSIF WDEST = "00010" THEN D2 <= DIN;
	ELSIF WDEST = "00011" THEN D3 <= DIN;
	ELSIF WDEST = "00100" THEN D4 <= DIN;
	ELSIF WDEST = "00101" THEN D5 <= DIN;
	ELSIF WDEST = "00110" THEN D6 <= DIN;
	ELSIF WDEST = "00111" THEN D7 <= DIN;
	ELSIF WDEST = "01000" THEN D8 <= DIN;
	
	ELSIF WDEST = "01001" THEN D9 <= DIN;
	ELSIF WDEST = "01010" THEN D10 <= DIN;
	ELSIF WDEST = "01011" THEN D11 <= DIN;
	ELSIF WDEST = "01100" THEN D12 <= DIN;
	ELSIF WDEST = "01101" THEN D13 <= DIN;
	ELSIF WDEST = "01110" THEN D14 <= DIN;
	ELSIF WDEST = "01111" THEN D15 <= DIN;
	
	ELSIF WDEST = "10000" THEN D16 <= DIN;
	ELSIF WDEST = "10001" THEN D17 <= DIN;
	ELSIF WDEST = "10010" THEN D18 <= DIN;
	ELSIF WDEST = "10011" THEN D19 <= DIN;
	ELSIF WDEST = "10100" THEN D20 <= DIN;
	ELSIF WDEST = "10101" THEN D21 <= DIN;
	ELSIF WDEST = "10110" THEN D22 <= DIN;
	ELSIF WDEST = "10111" THEN D23 <= DIN;
	
	ELSIF WDEST = "11000" THEN D24 <= DIN;
	ELSIF WDEST = "11001" THEN D25 <= DIN;
	ELSIF WDEST = "11010" THEN D26 <= DIN;
	ELSIF WDEST = "11011" THEN D27 <= DIN;
	ELSIF WDEST = "11100" THEN D28 <= DIN;
	ELSIF WDEST = "11101" THEN D29 <= DIN;
	ELSIF WDEST = "11110" THEN D30 <= DIN;
	ELSIF WDEST = "11111" THEN D31 <= DIN;
	
END IF;
END IF;
END IF;
END PROCESS;

end Behavioral;

