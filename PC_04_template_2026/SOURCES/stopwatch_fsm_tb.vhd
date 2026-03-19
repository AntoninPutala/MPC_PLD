library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY stopwatch_fsm_tb IS

END ENTITY stopwatch_fsm_tb;

ARCHITECTURE sim OF stopwatch_fsm_tb IS

    COMPONENT stopwatch_fsm
        PORT (
            CLK         : IN    STD_LOGIC;
            BTN_S_S     : IN    STD_LOGIC;
            BTN_L_C     : IN    STD_LOGIC;
            CNT_RESET   : OUT   STD_LOGIC;
            CNT_ENABLE  : OUT   STD_LOGIC;
            DISP_ENABLE : OUT   STD_LOGIC
        );
    END COMPONENT;

    signal clk_tb         : std_logic := '0';
    signal btn_s_s_tb     : std_logic := '0';
    signal btn_l_c_tb     : std_logic := '0';
    signal cnt_reset_tb   : std_logic;
    signal cnt_enable_tb  : std_logic;
    signal disp_enable_tb : std_logic;

    constant CLK_PERIOD : time := 10 ns;

BEGIN

    uut: stopwatch_fsm
        PORT MAP (
            CLK         => clk_tb,
            BTN_S_S     => btn_s_s_tb,
            BTN_L_C     => btn_l_c_tb,
            CNT_RESET   => cnt_reset_tb,
            CNT_ENABLE  => cnt_enable_tb,
            DISP_ENABLE => disp_enable_tb
        );

    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for 20 ns;

        -- RUN
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;
        
        -- STOP
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;

        -- IDLE
        btn_l_c_tb <= '1';
        wait for CLK_PERIOD;
        btn_l_c_tb <= '0';
        wait for 40 ns;
        
        -- RUN
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;

        -- STOP
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;
        
        -- RUN
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;
        
        -- LAP
        btn_l_c_tb <= '1';
        wait for CLK_PERIOD;
        btn_l_c_tb <= '0';
        wait for 40 ns;
        
        -- REFRESH
        btn_l_c_tb <= '1';
        wait for CLK_PERIOD;
        btn_l_c_tb <= '0';
        wait for 40 ns;

        -- RUN
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;

        -- STOP
        btn_s_s_tb <= '1';
        wait for CLK_PERIOD;
        btn_s_s_tb <= '0';
        wait for 40 ns;

        btn_l_c_tb <= '1';
        wait for CLK_PERIOD;
        btn_l_c_tb <= '0';

        wait for 100 ns;
        assert false report "Simulace uspesne dokoncena" severity note;
        wait;
    end process;

END ARCHITECTURE sim;