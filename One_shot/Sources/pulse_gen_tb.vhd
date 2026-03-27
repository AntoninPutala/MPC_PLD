library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pulse_gen_tb is
end pulse_gen_tb;

architecture behavior of pulse_gen_tb is
    
    SIGNAL clock_en : STD_LOGIC := '0';

    COMPONENT ce_gen
        GENERIC (
            G_DIV_FACT          : POSITIVE := 2
        );
        PORT (
            CLK                 : IN  STD_LOGIC;
            SRST                : IN  STD_LOGIC;
            CE                  : IN  STD_LOGIC;
            CE_O                : OUT STD_LOGIC 
        );
    END COMPONENT;


    component pulse_gen
    generic (
        G_DIV_FACT : POSITIVE := 4
    );
    port(
        SRST   : in  STD_LOGIC;
        CE     : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        TRG    : in  STD_LOGIC;
        OVERFL : out STD_LOGIC
    );
    end component;

    signal SRST   : STD_LOGIC := '1';
    signal CLK    : STD_LOGIC := '0';
    signal TRG    : STD_LOGIC := '0';
    signal OVERFL : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: pulse_gen
    generic map (
        G_DIV_FACT => 4
    )
    port map (
        SRST   => SRST,
        CE     => clock_en,
        CLK    => CLK,
        TRG    => TRG,
        OVERFL => OVERFL
    );

    ce_gen_i : ce_gen
       Generic map (
           G_DIV_FACT => 3
       )
       Port map (
           CLK        => CLK,
           SRST       => '0',
           CE         => '1',
           CE_O       => clock_en
       );

    clk_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        SRST <= '1';
        wait for 25 ns;
        
        SRST <= '0';
        wait for 20 ns;
        
        TRG <= '1';
        wait for CLK_PERIOD;
        TRG <= '0';
        
        wait for 150 ns;
        
        TRG <= '1';
        wait for CLK_PERIOD;
        TRG <= '0';
        
        wait;
    end process;

end behavior;