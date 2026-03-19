library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync_reg_tb is
end entity sync_reg_tb;

architecture sim of sync_reg_tb is

    signal clk     : std_logic := '0';
    signal sig_in  : std_logic := '0';
    signal sig_out : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: entity work.sync_reg
        port map (
            CLK     => clk,
            SIG_IN  => sig_in,
            SIG_OUT => sig_out
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;

        sig_in <= '1';
        wait for CLK_PERIOD;
        sig_in <= '0';
        wait for CLK_PERIOD;

        wait until rising_edge(clk);
        wait for 0.5 ns; 
        sig_in <= 'X';
        
        wait for CLK_PERIOD * 0.8; 
        sig_in <= '1';
        
        wait for CLK_PERIOD * 5;
        report "Simulace dokoncena";
        wait;
    end process;

end architecture;