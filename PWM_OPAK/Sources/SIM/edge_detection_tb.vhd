LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY edge_detector_tb IS
END ENTITY edge_detector_tb;

ARCHITECTURE sim OF edge_detector_tb IS

    SIGNAL clk          : STD_LOGIC := '0';
    SIGNAL sig_in       : STD_LOGIC := '0';
    SIGNAL edge_pos     : STD_LOGIC;
    SIGNAL edge_neg     : STD_LOGIC;
    SIGNAL edge_any     : STD_LOGIC;
    SIGNAL sim_done     : STD_LOGIC := '0';
    
    COMPONENT edge_detector
        PORT (
        CLK                 : IN    STD_LOGIC;
        SIG_IN              : IN    STD_LOGIC;
        EDGE_POS            : OUT   STD_LOGIC;
        EDGE_NEG            : OUT   STD_LOGIC;
        EDGE_ANY            : OUT   STD_LOGIC
    );
    END COMPONENT;

BEGIN

    uut: edge_detector
        PORT MAP (
            CLK      => clk,
            SIG_IN   => sig_in,
            EDGE_POS => edge_pos,
            EDGE_NEG => edge_neg,
            EDGE_ANY => edge_any
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
        sig_in <= '0';
        WAIT FOR 25 ns;
        
        WAIT UNTIL falling_edge(clk);
        sig_in <= '1';
        
        WAIT FOR 40 ns;
        
        WAIT UNTIL falling_edge(clk);
        sig_in <= '0';
        
        WAIT FOR 40 ns;
        
        WAIT UNTIL falling_edge(clk);
        sig_in <= '1';
        WAIT FOR 30 ns;
        
        sim_done <= '1';
        WAIT;
    END PROCESS;

END ARCHITECTURE sim;