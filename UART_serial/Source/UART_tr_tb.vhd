library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY UART_tx_tb IS
END UART_tx_tb;

ARCHITECTURE Behavioral OF UART_tx_tb IS

    COMPONENT UART_tr
        GENERIC (
            LENGTH      : INTEGER := 8
        );
        PORT (
            CLK         : IN  STD_LOGIC;                      
            TX_START    : IN  STD_LOGIC;                      
            CLK_EN      : IN  STD_LOGIC;                      
            DATA_IN     : IN  STD_LOGIC_VECTOR((LENGTH - 1) DOWNTO 0);   
            TX_BUSY     : OUT STD_LOGIC;                      
            UART_TXD    : OUT STD_LOGIC 
        );                      
    END COMPONENT;
    
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

    CONSTANT LENGTH_TB : integer := 8;

    SIGNAL clk         : STD_LOGIC := '0';
    SIGNAL tx_start    : STD_LOGIC := '0';
    SIGNAL clk_en      : STD_LOGIC := '0';
    SIGNAL data_in     : STD_LOGIC_VECTOR(LENGTH_TB - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tx_busy     : STD_LOGIC;
    SIGNAL uart_txd    : STD_LOGIC;

    CONSTANT CLK_PERIOD : TIME := 20 ns;

begin

    uut: UART_tr
        GENERIC MAP (
            LENGTH => LENGTH_TB 
        )
        PORT MAP (
            CLK      => clk,
            TX_START => tx_start,
            CLK_EN   => clk_en,
            DATA_IN  => data_in,
            TX_BUSY  => tx_busy,
            UART_TXD => uart_txd
        );
        
    ce_gen_i: ce_gen
        GENERIC MAP (
            G_DIV_FACT => 5
        )
        PORT MAP (
            CLK    => clk,
            SRST   => '0',
            CE     => '1',
            CE_O   => clk_en
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
        tx_start <= '0';
        data_in <= (OTHERS => '0');
        WAIT FOR CLK_PERIOD * 10;

        data_in  <= "00100101";
        tx_start <= '1';
        WAIT FOR CLK_PERIOD;
        tx_start <= '0';

        WAIT UNTIL tx_busy = '0';
        --WAIT FOR CLK_PERIOD * 20;
        --WAIT FOR 1080 ns;

        data_in <= "11001100";
        tx_start <= '1';
        WAIT FOR CLK_PERIOD;
        tx_start <= '0';

        WAIT UNTIL tx_busy = '0';
        
        data_in <= "10010101";
        tx_start <= '1';
        WAIT FOR CLK_PERIOD;
        tx_start <= '0';

        WAIT UNTIL tx_busy = '0';
        WAIT FOR CLK_PERIOD * 20;

        WAIT;
    END PROCESS;

END Behavioral;