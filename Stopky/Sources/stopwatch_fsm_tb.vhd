LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY stopwatch_fsm_tb IS
END ENTITY stopwatch_fsm_tb;

ARCHITECTURE sim OF stopwatch_fsm_tb IS

    SIGNAL clk         : STD_LOGIC := '0';
    SIGNAL btn_s_s     : STD_LOGIC := '0';
    SIGNAL btn_l_c     : STD_LOGIC := '0';
    SIGNAL cnt_reset   : STD_LOGIC;
    SIGNAL cnt_enable  : STD_LOGIC;
    SIGNAL disp_enable : STD_LOGIC;
    SIGNAL sim_done    : STD_LOGIC := '0';

BEGIN

    uut: ENTITY work.stopwatch_fsm
        PORT MAP (
            CLK         => clk,
            BTN_S_S     => btn_s_s,
            BTN_L_C     => btn_l_c,
            CNT_RESET   => cnt_reset,
            CNT_ENABLE  => cnt_enable,
            DISP_ENABLE => disp_enable
        );

    clk_process : PROCESS
    BEGIN
        WHILE sim_done = '0' LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT;
    END PROCESS;

    stim_process : PROCESS
    BEGIN
        btn_s_s <= '0';
        btn_l_c <= '0';
        WAIT FOR 20 ns;

        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '0';
        WAIT FOR 40 ns;

        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '0';
        WAIT FOR 40 ns;

        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '0';
        WAIT FOR 40 ns;

        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '0';
        WAIT FOR 40 ns;

        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_s_s <= '0';
        WAIT FOR 40 ns;

        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '1';
        WAIT UNTIL falling_edge(clk);
        btn_l_c <= '0';
        WAIT FOR 40 ns;

        sim_done <= '1';
        WAIT;
    END PROCESS;

END ARCHITECTURE sim;