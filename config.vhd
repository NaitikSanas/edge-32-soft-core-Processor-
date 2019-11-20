LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CONFIG_CORE IS
PORT(--INST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
CLK, RXD :IN STD_LOGIC;
DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
W_EN, R_EN : OUT STD_LOGIC;
DOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
IO_P1 : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
ADDRESS_BUS : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
 TXD, timeout, toggle : OUT STD_LOGIC
);
END CONFIG_CORE;

ARCHITECTURE BEHAVIORAL OF CONFIG_CORE IS
	
	COMPONENT ALU_inst_executer
	PORT(
		inst_in : IN std_logic_vector(31 downto 0);
		 pc_restore : IN std_logic_vector(15 downto 0);
		status : IN std_logic_vector(1 downto 0);
		clk : IN std_logic;
		tx_busy : IN std_logic;
		rx_busy : IN std_logic;
		rx_error : IN std_logic;          
		 timer_ack  : IN std_logic;          
		EN : OUT std_logic;
		SEL : OUT std_logic;
		CMP_EN : OUT std_logic;
		buf_en, toggle : OUT std_logic;
		we : OUT std_logic;
		ALE : OUT std_logic;
		RE : OUT std_logic;
		tx_en : OUT std_logic;
		timer_en : OUT std_logic;
		RS : OUT std_logic;
		timer_rst : OUT std_logic;
		ack_clr : OUT std_logic;
		ctrl : OUT std_logic;
		OP_A : OUT std_logic_vector(4 downto 0);
		OP_B : OUT std_logic_vector(4 downto 0);
		WDST : OUT std_logic_vector(4 downto 0);
		RDST : OUT std_logic_vector(4 downto 0);
		CMP_R0 : OUT std_logic_vector(4 downto 0);
		CMP_R1 : OUT std_logic_vector(4 downto 0);
		FUNCT : OUT std_logic_vector(3 downto 0);
		mode : OUT std_logic_vector(1 downto 0);
		BFI : OUT std_logic_vector(1 downto 0);
		tctrl : OUT std_logic_vector(1 downto 0);
		DSS : OUT std_logic_vector(2 downto 0);
		DATA_to_alu : OUT std_logic_vector(31 downto 0);
		pc : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;


	COMPONENT EXECUTION_ENGINE
	PORT(
		CLK : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		SEL : IN STD_LOGIC;
		CMP_EN : IN STD_LOGIC;
		OP_A : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		OP_B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		WDST : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RDST : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		CMP_R0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		CMP_R1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		FUNCT : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);          
		DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		STATUS : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;


	COMPONENT ROM
	PORT(
		ADDRESS : IN STD_LOGIC_VECTOR(5 DOWNTO 0);          
		DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;



	COMPONENT CLOCK_DIVIDER
      port (clk: in std_logic;	
		clk_out, display_clk, UART_CLK, tclk : out std_logic := '0'
		);
  	END COMPONENT;


COMPONENT ADDRES_LATCH
	PORT(
		CLK : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		SET_ADDR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);          
		ADDRESS : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT MUX
   PORT (  
         A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         C : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Y : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT UART
	PORT(
		CLK : IN STD_LOGIC;
		RESET_N : IN STD_LOGIC;
		TX_ENA : IN STD_LOGIC;
		TX_DATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		RX : IN STD_LOGIC;          
		RX_BUSY : OUT STD_LOGIC;
		RX_ERROR : OUT STD_LOGIC;
		RX_DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		TX_BUSY : OUT STD_LOGIC;
		TX : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT MUX81
	PORT(
		A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		C : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		SEL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);          
		Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	
	COMPONENT MEMORY
	PORT(
		DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		WP : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		RP : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		WCLK : IN STD_LOGIC;
		RCLK : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		WE : IN STD_LOGIC;
		RE : IN STD_LOGIC;          
		DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	END COMPONENT;

COMPONENT timer
	PORT(
		data_in : IN std_logic_vector(25 downto 0);
		tctrl : IN std_logic_vector(1 downto 0);
		sys_clk : IN std_logic;
		timer_clk : IN std_logic;
		timer_en : IN std_logic;
		ctrl : IN std_logic;
		tcr0_clr : IN std_logic;
		timer_reset : IN std_logic;
		rs : IN std_logic;          
		time_out_Ack0 : OUT std_logic;
		data_out : OUT std_logic_vector(25 downto 0)
		);
	END COMPONENT;


	COMPONENT dss_mux
	PORT(
		a : IN std_logic_vector(31 downto 0);
		b : IN std_logic_vector(31 downto 0);
		c : IN std_logic_vector(31 downto 0);
		d : IN std_logic_vector(31 downto 0);
		e : IN std_logic_vector(31 downto 0);
		f : IN std_logic_vector(31 downto 0);
		g : IN std_logic_vector(31 downto 0);
		h : IN std_logic_vector(31 downto 0);
		sel : IN std_logic_vector(2 downto 0);          
		y : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;





	
SIGNAL EN, RCM, CMP_EN, BUF_EN, SYS_CLK, ALE, TX_EN, RX_BUSY, RX_ERROR, TX_BUSY, UART_CLK, WE, RE : STD_LOGIC;
signal timer_clk,timer_rst, ack_clr, ctrl, rs, timer_ack,timer_en : std_logic; 
SIGNAL OPA, OPB, WDST, RDST, CMPR0, CMPR1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL FUNCT : STD_LOGIC_VECTOR(3 DOWNTO 0);	
SIGNAL  RX_DATA, UART_TXD : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL STATUS, MODE, BFI, tctrl : STD_LOGIC_VECTOR(1 DOWNTO 0);	
SIGNAL DSS : STD_LOGIC_VECTOR(2 DOWNTO 0);	
SIGNAL DIN, DBUF, DATA_TO_EE, UART_RXD, DATA_FROM_MEMORY, ad, bd, cd, dd :STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL INSTRUCTION, timer_data, pc32 :STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PC, SADDR, ADDRESS :STD_LOGIC_VECTOR(15 DOWNTO 0);
CONSTANT ZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";

BEGIN
timeout <= timer_ack;	
W_EN <= WE;
R_EN <= RE;
ADDRESS_BUS <= ADDRESS;
 DATA_MEMORY: MEMORY PORT MAP(
		DIN => DBUF ,
		WP => ADDRESS(11 DOWNTO 0),
		RP => ADDRESS(11 DOWNTO 0),
		WCLK =>SYS_CLK ,
		RCLK =>SYS_CLK ,
		EN => '1',
		WE => WE ,
		RE => RE,
		DOUT => DATA_FROM_MEMORY 
	);

 UART_BLOCK: UART PORT MAP(
		CLK => UART_CLK ,
		RESET_N => '1',
		TX_ENA => TX_EN,
		TX_DATA =>UART_TXD ,
		RX => RXD ,
		RX_BUSY => RX_BUSY ,
		RX_ERROR => RX_ERROR ,
		RX_DATA => RX_DATA,
		TX_BUSY => TX_BUSY ,
		TX => TXD
	);
	ad <= "000000000000000000000000" & RX_DATA;
	bd <= "0000000000000000" & RX_DATA & "00000000";
	cd <=  "00000000" & RX_DATA & "0000000000000000";
	dd <= RX_DATA  &"000000000000000000000000";
	
  UART_RX_FRAMMING: MUX PORT MAP(
		A => ad,
		B => bd,
		C => cd,
		D => dd,
		SEL => BFI,
		Y => UART_RXD
	);
  
	UART_TX_FRAMMING: MUX81 PORT MAP(
		A => DBUF(7 DOWNTO 0) ,
		B => DBUF(15 DOWNTO 8),
		C => DBUF(23 DOWNTO 16) ,
		D => DBUF(31 DOWNTO 24) ,
		SEL => BFI,
		Y => UART_TXD
	);
	

	Inst_timer: timer PORT MAP(
		data_in => dbuf(25 downto 0) ,
		tctrl => tctrl,
		sys_clk => sys_clk,
		timer_clk =>timer_clk ,
		timer_en => timer_en,
		ctrl => ctrl,
		tcr0_clr => ack_clr,
		timer_reset =>timer_rst ,
		rs => rs,
		time_out_Ack0 =>timer_ack ,
		data_out => timer_data(25 downto 0)
	);
	pc32 <= "0000000000000000"&pc;
	Inst_dss_mux: dss_mux PORT MAP(
		a => data_in,
		b => din,
		c => uart_rxd,
		d => data_from_memory,
		e => timer_data,
		f => pc32 ,
		g => zero ,
		h => zero ,
		sel => DSS ,
		y => data_to_ee
	);


  ADDRESS_HOLDING_LATCH: ADDRES_LATCH PORT MAP(
		CLK => SYS_CLK ,
		EN => ALE,
		MODE => MODE ,
		SET_ADDR => INSTRUCTION(15 DOWNTO 0),
		ADDRESS => ADDRESS
	);



	CPU_CLOCK_DIVIDER: CLOCK_DIVIDER PORT MAP(
		CLK => CLK,
		CLK_OUT => SYS_CLK,
		UART_CLK => UART_CLK,
		tclk => timer_clk);


	PROGRAM_ROM: ROM PORT MAP(
		ADDRESS =>PC(5 DOWNTO 0),
		DATA => INSTRUCTION 
	);

DATA_EXECUTION_ENGINE: EXECUTION_ENGINE PORT MAP(
		
		CLK =>  SYS_CLK ,
		EN => EN ,
		SEL => RCM ,
		CMP_EN => CMP_EN ,
		OP_A => OPA ,
		OP_B => OPB ,
		WDST => WDST,
		RDST => RDST,
		CMP_R0 => CMPR0,
		CMP_R1 => CMPR1,
		FUNCT => FUNCT,
		DATA_IN => DATA_TO_EE,
		DATA_OUT => DBUF,
		STATUS => STATUS
	);


	CONTROL_ENGINE: ALU_INST_EXECUTER PORT MAP(
		INST_IN => INSTRUCTION ,
		TX_BUSY => TX_BUSY ,
		RX_BUSY =>RX_BUSY ,
		timer_en=> timer_en,
		toggle=> toggle,
		pc_restore => dbuf(15 downto 0),
		RS => rs,
		timer_ack => timer_ack,
		timer_rst =>timer_rst ,
		ack_clr =>ack_clr ,
		ctrl => ctrl,
		tctrl => tctrl,
		RX_ERROR =>RX_ERROR ,
		TX_EN =>TX_EN,
		STATUS =>STATUS ,
		BFI => BFI,
		MODE => MODE,
		ALE => ALE,
		DSS => DSS,
		WE => WE,
		RE => RE,
		CLK => SYS_CLK ,
		EN =>EN ,
		BUF_EN =>BUF_EN ,
		SEL => RCM,
		CMP_EN =>CMP_EN ,
		OP_A => OPA,
		OP_B => OPB,
		WDST => WDST,
		RDST => RDST,
		CMP_R0 => CMPR0,
		CMP_R1 => CMPR1,
		FUNCT => FUNCT,
		DATA_TO_ALU => DIN,
		PC => PC
	);
	
--S <= STATUS;
PROCESS( SYS_CLK, BUF_EN)
BEGIN

IF BUF_EN = '1' THEN
IF RISING_EDGE( SYS_CLK) THEN 
		DOUT <= DBUF(7 DOWNTO 0); 
		IO_P1 <= DBUF(31 DOWNTO 8);
END IF;
END IF;

END PROCESS;
END BEHAVIORAL;

