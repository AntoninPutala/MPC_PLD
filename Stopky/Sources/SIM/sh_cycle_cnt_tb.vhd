LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY sh_cycle_cnt_tb IS
END ENTITY sh_cycle_cnt_tb;

ARCHITECTURE sim OF sh_cycle_cnt_tb IS

    CONSTANT N_CYCLE : INTEGER := 10;

    SIGNAL clk       : STD_LOGIC := '0';
    SIGNAL ce        : STD_LOGIC := '0';
    SIGNAL srst      : STD_LOGIC := '0';
    SIGNAL carry     : STD_LOGIC;
    SIGNAL cnt       : STD_LOGIC_VECTOR((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) DOWNTO 0);
    SIGNAL sim_done  : STD_LOGIC := '0';
    
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

BEGIN

    uut: sh_cycle_cnt
        GENERIC MAP (
            N_CYCLE => N_CYCLE
        )
        PORT MAP (
            CLK   => clk,
            CE    => ce,
            SRST  => srst,
            CARRY => carry,
            CNT   => cnt
        );

    clk_process : PROCESS
    BEGIN
        WHILE (sim_done = '0') 
        LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT;
    END PROCESS;

    stim_process : PROCESS
    BEGIN
        srst <= '1';
        ce   <= '0';
        WAIT FOR 20 ns;
        
        WAIT UNTIL falling_edge(CLK);
        srst <= '0';
        ce   <= '1';
        
        WAIT FOR 250 ns;
        
        WAIT UNTIL falling_edge(CLK);
        ce   <= '0';
        WAIT FOR 40 ns;
        
        sim_done <= '1';
        WAIT;
    END PROCESS;

END ARCHITECTURE sim;