
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:01 07/19/2019 
-- Design Name: 
-- Module Name:    mux - Behavioral 
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

entity mux81 is
port (
a : in std_logic_vector(7 downto 0);
b : in std_logic_vector(7 downto 0);
c : in std_logic_vector(7 downto 0);
d : in std_logic_vector(7 downto 0);
sel: in std_logic_Vector(1 downto 0);
y : out std_logic_vector(7 downto 0)
);
end mux81;

architecture Behavioral of mux81 is
CONSTANT ZERO : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

begin
WITH SEL SELECT Y <= A WHEN "00", B WHEN "01", C when "10", D when "11",  ZERO WHEN OTHERS;
end Behavioral;

