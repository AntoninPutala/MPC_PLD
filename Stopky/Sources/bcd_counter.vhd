----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
----------------------------------------------------------------------------------
ENTITY bcd_counter IS
    PORT(
        CLK                 : IN    STD_LOGIC;      -- clock signal
        CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
        CNT_RESET           : IN    STD_LOGIC;      -- counter reset
        CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
        DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
        CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY bcd_counter;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bcd_counter IS
----------------------------------------------------------------------------------

    COMPONENT sh_cycle_cnt
        GENERIC (
            N_CYCLE : INTEGER := 10
        );
	    PORT (
		    CLK        : IN  STD_LOGIC;
		    CE         : IN  STD_LOGIC;
		    SRST       : IN  STD_LOGIC;
		    CARRY      : OUT STD_LOGIC;
		    CNT        : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) DOWNTO 0)
	    );
    END COMPONENT;
    
    SIGNAL sig_ce_1  : STD_LOGIC := '0';
    SIGNAL sig_ce_2  : STD_LOGIC := '0';
    SIGNAL sig_ce_3  : STD_LOGIC := '0';
    SIGNAL sig_ce_4  : STD_LOGIC := '0';
    
    SIGNAL sig_car_1 : STD_LOGIC := '0';
    SIGNAL sig_car_2 : STD_LOGIC := '0';
    SIGNAL sig_car_3 : STD_LOGIC := '0';
    
    SIGNAL cnt_0_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cnt_1_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cnt_2_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL cnt_3_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL cnt_0_out : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cnt_1_out : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cnt_2_out : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cnt_3_out : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    -- BCD counter
    cnt_hunth: sh_cycle_cnt
        GENERIC MAP (
            N_CYCLE => 10
        )
        PORT MAP (
            CLK   => CLK,
            CE    => sig_ce_1,
            SRST  => CNT_RESET,
            CARRY => sig_car_1,
            CNT   => cnt_0_reg
        );
        
    cnt_tenth: sh_cycle_cnt
        GENERIC MAP (
            N_CYCLE => 10
        )
        PORT MAP (
            CLK   => CLK,
            CE    => sig_ce_2,
            SRST  => CNT_RESET,
            CARRY => sig_car_2,
            CNT   => cnt_1_reg
        );  
              
    cnt_secs: sh_cycle_cnt
        GENERIC MAP (
            N_CYCLE => 10
        )
        PORT MAP (
            CLK   => CLK,
            CE    => sig_ce_3,
            SRST  => CNT_RESET,
            CARRY => sig_car_3,
            CNT   => cnt_2_reg
        ); 
                     
    cnt_tens: sh_cycle_cnt
        GENERIC MAP (
            N_CYCLE => 6
        )
        PORT MAP (
            CLK   => CLK,
            CE    => sig_ce_4,
            SRST  => CNT_RESET,
            CARRY => open,
            CNT   => cnt_3_reg(2 DOWNTO 0)
        );

    cnt_3_reg(3) <= '0';

    sig_ce_1 <=  CE_100HZ AND CNT_ENABLE;
    sig_ce_2 <=  sig_ce_1 AND sig_car_1;
    sig_ce_3 <=  sig_ce_2 AND sig_car_2;
    sig_ce_4 <=  sig_ce_3 AND sig_car_3;
    
    --------------------------------------------------------------------------------
    -- Output (display) register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (DISP_ENABLE = '1') THEN
                cnt_0_out <= cnt_0_reg;
                cnt_1_out <= cnt_1_reg;
                cnt_2_out <= cnt_2_reg;
                cnt_3_out <= cnt_3_reg;
            END IF;
        END IF;
    END PROCESS;

    CNT_0 <= cnt_0_out;
    CNT_1 <= cnt_1_out;
    CNT_2 <= cnt_2_out;
    CNT_3 <= cnt_3_out;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
