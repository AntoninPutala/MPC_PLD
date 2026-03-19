library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer_tb is
end entity debouncer_tb;

architecture sim of debouncer_tb is

    constant CLK_PERIOD : time := 10 ns;
    constant G_DEB_PERIOD : positive := 5;

    -- Signály
    signal clk      : std_logic := '0';
    signal ce       : std_logic := '1';
    signal btn_in   : std_logic := '0';
    signal btn_out  : std_logic;
    
    COMPONENT debouncer
        GENERIC (
            G_DEB_PERIOD        : POSITIVE
        );    
        PORT ( 
            CLK                 : IN    STD_LOGIC;
            CE                  : IN    STD_LOGIC;
            BTN_IN              : IN    STD_LOGIC;
            BTN_OUT             : OUT   STD_LOGIC
        );
    END COMPONENT;

begin

    uut: debouncer
        generic map (
            G_DEB_PERIOD => G_DEB_PERIOD
        )
        port map (
            CLK     => clk,
            CE      => ce,
            BTN_IN  => btn_in,
            BTN_OUT => btn_out
        );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;

        report "Simulace stisku s zakmity...";
        btn_in <= '1'; wait for 15 ns; 
        btn_in <= '0'; wait for 12 ns;
        btn_in <= '1'; wait for 8 ns;  
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1';                 
        
        wait for 200 ns;

        report "Simulace uvolneni s zakmity...";
        btn_in <= '0'; wait for 10 ns;
        btn_in <= '1'; wait for 15 ns;
        btn_in <= '0'; wait for 5 ns;
        btn_in <= '1'; wait for 10 ns;
        btn_in <= '0';                
        
        wait for 200 ns;

        report "Test hotov. Sledujte prubeh BTN_OUT.";
        wait;
    end process;

end architecture;