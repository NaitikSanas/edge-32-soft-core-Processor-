----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:00 09/26/2019 
-- Design Name: 
-- Module Name:    EXECUTION_ENGINE - Behavioral 
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

entity EXECUTION_ENGINE is
PORT(
	  CLK, EN, SEL, CMP_EN: IN STD_LOGIC;
	  OP_A, OP_B, WDST, RDST, CMP_R0, CMP_R1: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	  FUNCT: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	  DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	  DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	  STATUS : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	  	


);
end EXECUTION_ENGINE;

architecture Behavioral of EXECUTION_ENGINE is
	COMPONENT ALU
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		FUNCT : IN std_logic_vector(3 downto 0);          
		R : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	
	COMPONENT Register_file
	PORT(
		DATA0 : IN std_logic_vector(31 downto 0);
		DATA1 : IN std_logic_vector(31 downto 0);
		WDest : IN std_logic_vector(4 downto 0);
		op_a, RDST : IN std_logic_vector(4 downto 0);
		op_b : IN std_logic_vector(4 downto 0);
		CMP_R0 : IN std_logic_vector(4 downto 0);
		CMP_R1 : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;
		en : IN std_logic;
		SEL : IN std_logic;          
		a : OUT std_logic_vector(31 downto 0);
		b : OUT std_logic_vector(31 downto 0);
		CMP_OPA, DOUT : OUT std_logic_vector(31 downto 0);
		CMP_OPB : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;


	COMPONENT COMPARATOR
	PORT(
		A : IN std_logic_vector(31 downto 0);
		B : IN std_logic_vector(31 downto 0);
		CLK : IN std_logic;
		EN : IN std_logic;          
		STATUS : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;




SIGNAL A, B, RESULT, CMP_OPA, CMP_OPB: std_logic_vector(31 downto 0);
SIGNAL CLOCK : STD_LOGIC;
--SIGNAL STATUS: std_logic_vector(1 downto 0);
begin
	CLOCK <=  CLK;
	COMPARATOR_UNIT: COMPARATOR PORT MAP(
		A => CMP_OPA,
		B => CMP_OPB,
		CLK => CLOCK,
		EN => CMP_EN ,
		STATUS => STATUS
	);

	ALU32_BLOCK: ALU PORT MAP(
		A => A ,
		B => B,
		FUNCT => FUNCT ,
		R => RESULT
	);
	

	Register_file_32X32: Register_file PORT MAP(
		DATA0 => RESULT,
		DATA1 => DATA_IN,
		WDest => WDST,
		op_a => OP_A,
		op_b => OP_B,
		RDST => RDST,
		DOUT => DATA_OUT,
		CMP_R0 => CMP_R0 ,
		CMP_R1 => CMP_R1,
		clk => CLOCK,
		en => EN,
		SEL => SEL,
		a => A,
		b => B,
		CMP_OPA => CMP_OPA,
		CMP_OPB => CMP_OPB 
	);



end Behavioral;

