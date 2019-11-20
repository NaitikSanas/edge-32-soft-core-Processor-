----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:04 09/26/2019 
-- Design Name: 
-- Module Name:    MUX32L - Behavioral 
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


entity MUX32L is
PORT (	
	D0, D1, D2, D3, D4, D5, D6, D7, D8, D9 , D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28 ,D29, D30, D31 : IN std_logic_Vector(31 downto 0);
	PTR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end MUX32L;

architecture Behavioral of MUX32L is

begin
WITH PTR SELECT DOUT <= D0 WHEN "00000",
								D1 WHEN "00001",
								D2 WHEN "00010",
								D3 WHEN "00011",
								D4 WHEN "00100",
								D5 WHEN "00101",
								D6 WHEN "00110",
								D7 WHEN "00111",
								
								D8 WHEN  "01000",
								D9 WHEN  "01001",
								D10 WHEN "01010",
								D11 WHEN "01011",
								D12 WHEN "01100",
								D13 WHEN "01101",
								D14 WHEN "01110",
								D15 WHEN "01111",
								
								D16 WHEN "10000",
								D17 WHEN "10001",
								D18 WHEN "10010",
								D19 WHEN "10011",
								D20 WHEN "10100",
								D21 WHEN "10101",
								D22 WHEN "10110",
								D23 WHEN "10111",
								
								D24 WHEN "11000",
								D25 WHEN "11001",
								D26 WHEN "11010",
								D27 WHEN "11011",
								D28 WHEN "11100",
								D29 WHEN "11101",
								D30 WHEN "11110",
								D31 WHEN "11111",
								"00000000000000000000000000000000" WHEN OTHERS;
end Behavioral;

