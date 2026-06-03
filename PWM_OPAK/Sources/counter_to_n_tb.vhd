LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY counter_to_n_tb IS
END counter_to_n_tb;

ARCHITECTURE Behavioral OF counter_to_n_tb IS

    CONSTANT NCYCLE_TB  : INTEGER := 5;
    CONSTANT CLK_PERIOD : TIME := 10 ns;

    SIGNAL clk  : STD_LOGIC := '0';
    SIGNAL srst : STD_LOGIC := '0';
    SIGNAL ce   : STD_LOGIC := '0';
    SIGNAL cnt  : STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(NCYCLE_TB)))) - 1) DOWNTO 0);
    
    SIGNAL done : BOOLEAN := FALSE;
    
    COMPONENT counter_to_n
        GENERIC (
            NCYCLE : INTEGER := 255
        );
	    PORT (
		    CLK    : IN  STD_LOGIC;
		    SRST   : IN  STD_LOGIC;
		    CE     : IN  STD_LOGIC;
		    CNT    : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(NCYCLE)))) - 1) DOWNTO 0)
	   );
    END COMPONENT;

BEGIN

    uut: counter_to_n
    generic map (
        NCYCLE => NCYCLE_TB
    )
    port map (
        CLK   => clk,
        SRST  => srst,
        CE    => ce,
        CNT   => cnt
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD/2;
        clk <= '1';
        WAIT FOR CLK_PERIOD/2;
        
        IF done THEN
            WAIT;
        END IF;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        srst <= '1';
        ce   <= '0';
        WAIT FOR CLK_PERIOD * 2;
        
        srst <= '0';
        WAIT FOR CLK_PERIOD;
        
        ce <= '1';
        WAIT FOR CLK_PERIOD * 8;
        
        ce <= '0';
        WAIT FOR CLK_PERIOD * 3;
        
        ce <= '1';
        WAIT FOR CLK_PERIOD * 2;
        
        srst <= '1';
        WAIT FOR CLK_PERIOD * 2;
        
        srst <= '0';
        WAIT FOR CLK_PERIOD * 30;
        
        done <= TRUE;
        
        WAIT;
    END PROCESS;

END Behavioral;