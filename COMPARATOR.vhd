----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:17 09/27/2019 
-- Design Name: 
-- Module Name:    COMPARATOR - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COMPARATOR is
PORT (
		A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		CLK, EN : IN STD_LOGIC;
		STATUS : OUT STD_LOGIC_VECTOR(1 DOWNTO 0):= "00"	
		
);
end COMPARATOR;

architecture Behavioral of COMPARATOR is
CONSTANT ZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
begin
PROCESS(A, B, CLK , EN)
BEGIN
IF EN = '1' THEN
IF RISING_EDGE(CLK) THEN
IF A > ZERO AND B > ZERO AND A = B THEN STATUS <= "11";
ELSIF A > B THEN STATUS <= "10";
ELSIF A < B THEN STATUS <= "01";
ELSIF A = ZERO AND B = ZERO THEN STATUS <= "00";
END IF;


END IF;
END IF;
END PROCESS;

end Behavioral;

