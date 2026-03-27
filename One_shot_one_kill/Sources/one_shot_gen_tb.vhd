library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_shot_gen_tb is
end one_shot_gen_tb;

architecture behavior of one_shot_gen_tb is

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

    component one_shot_gen
    generic (
        IMPULSE_LEN : POSITIVE := 4
    );
    port(
        CLK        : in  STD_LOGIC;
        SRST       : in  STD_LOGIC;
        CE         : in  STD_LOGIC;
        START_I    : in  STD_LOGIC;
        IMPULSE_O  : out STD_LOGIC;
        READY_O    : out STD_LOGIC;
        FINISHED_O : out STD_LOGIC
    );
    end component;

    signal CLK        : STD_LOGIC := '0';
    signal SRST       : STD_LOGIC := '1';
    signal START_I    : STD_LOGIC := '0';
    signal IMPULSE_O  : STD_LOGIC;
    signal READY_O    : STD_LOGIC;
    signal FINISHED_O : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: one_shot_gen
    generic map (
        IMPULSE_LEN => 4
    )
    port map (
        CLK        => CLK,
        SRST       => SRST,
        CE         => clock_en,
        START_I    => START_I,
        IMPULSE_O  => IMPULSE_O,
        READY_O    => READY_O,
        FINISHED_O => FINISHED_O
    );

    clk_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    ce_gen_i : ce_gen
       Generic map (
           G_DIV_FACT => 4
       )
       Port map (
           CLK        => CLK,
           SRST       => '0',
           CE         => '1',
           CE_O       => clock_en
       );

    stim_proc: process
    begin
        SRST <= '1';
        wait for 25 ns;
        
        SRST <= '0';
        wait for 20 ns;
        
        START_I <= '1';
        wait for 5 * CLK_PERIOD;
        START_I <= '0';
        
        wait for 100 ns;
        
        START_I <= '1';
        wait for 5 * CLK_PERIOD;
        START_I <= '0';
        
        wait for 1000 ns;
        
        START_I <= '1';
        wait for 5 * CLK_PERIOD;
        START_I <= '0';
        
        wait;
    end process;

end behavior;