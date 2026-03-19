library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_tb is
end entity edge_detector_tb;

architecture sim of edge_detector_tb is

    signal clk      : std_logic := '0';
    signal sig_in   : std_logic := '0';
    signal edge_pos : std_logic;
    signal edge_neg : std_logic;
    signal edge_any : std_logic;

    constant CLK_PERIOD : time := 10 ns;
    
    COMPONENT edge_detector
        PORT (
            CLK                 : IN    STD_LOGIC;
            SIG_IN              : IN    STD_LOGIC;
            EDGE_POS            : OUT   STD_LOGIC;
            EDGE_NEG            : OUT   STD_LOGIC;
            EDGE_ANY            : OUT   STD_LOGIC
        );
    END COMPONENT;

begin

    uut: edge_detector
        port map (
            CLK      => clk,
            SIG_IN   => sig_in,
            EDGE_POS => edge_pos,
            EDGE_NEG => edge_neg,
            EDGE_ANY => edge_any
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;

        wait until falling_edge(clk);
        sig_in <= '1'; 
        
        wait for 3 * CLK_PERIOD;

        sig_in <= '0';
        
        wait for 3 * CLK_PERIOD;

        sig_in <= '1';
        wait for CLK_PERIOD / 4; 
        sig_in <= '0';

        wait for 100 ns;
        report "Simulace hran hotova.";
        wait;
    end process;

end architecture;