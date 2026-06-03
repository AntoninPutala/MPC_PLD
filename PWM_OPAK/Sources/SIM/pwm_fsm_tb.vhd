LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PKG_CONSTANTS.ALL;
USE WORK.PKG_TYPES.ALL;

ENTITY pwm_fsm_tb IS
END pwm_fsm_tb;

ARCHITECTURE Behavioral OF pwm_fsm_tb IS

    CONSTANT CLK_PERIOD : TIME := 10 ns;

    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL ce      : STD_LOGIC := '0';
    SIGNAL dir     : STD_LOGIC := '0';
    SIGNAL pwm_ref : type_pwm_ref;
    
    COMPONENT pwm_fsm
       	PORT (
		    CLK     : IN  STD_LOGIC;
		    CE      : IN  STD_LOGIC;
		    DIR     : IN  STD_LOGIC;
		    PWM_REF : OUT type_pwm_ref
	    ); 
    END COMPONENT;

BEGIN

    uut: pwm_fsm
        PORT MAP (
            CLK     => clk,
            CE      => ce,
            DIR     => dir,
            PWM_REF => pwm_ref
        );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD/2;
        clk <= '1';
        WAIT FOR CLK_PERIOD/2;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        ce  <= '0';
        dir <= '0';
        WAIT FOR CLK_PERIOD * 2;

        ce <= '1';
        WAIT FOR CLK_PERIOD * 10;

        dir <= '1';
        WAIT FOR CLK_PERIOD * 10;

        ce <= '0';
        WAIT FOR CLK_PERIOD * 3;

        ce <= '1';
        dir <= '0';
        WAIT FOR CLK_PERIOD * 5;

        WAIT;
    END PROCESS;

END Behavioral;