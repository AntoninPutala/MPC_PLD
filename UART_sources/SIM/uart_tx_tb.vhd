-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 25 Mar 2026 21:53:19 GMT
-- Request id : cfwk-fed377c2-69c4594f95cdb

library ieee;
use ieee.std_logic_1164.all;

entity uart_tx_tb is
end uart_tx_tb;

architecture tb of uart_tx_tb is

    component uart_tx
        port (CLK         : in std_logic;
              TX_START    : in std_logic;
              CLK_EN      : in std_logic;
              DATA_IN     : in std_logic_vector (7 downto 0);
              TX_BUSY     : out std_logic;
              TX_DATA_OUT : out std_logic);
    end component;
    
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
    END COMPONENT ce_gen;

    signal CLK         : std_logic;
    signal TX_START    : std_logic;
    signal CLK_EN      : std_logic;
    signal DATA_IN     : std_logic_vector (7 downto 0);
    signal TX_BUSY     : std_logic;
    signal TX_DATA_OUT : std_logic;

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    ce_gen_i : ce_gen
        GENERIC MAP(
            G_DIV_FACT                  => 5
        )
        PORT MAP(
            CLK                         => CLK,
            SRST                        => '0',
            CE                          => '1',
            CE_O                        => CLK_EN
        );

    dut : uart_tx
    port map (CLK         => CLK,
              TX_START    => TX_START,
              CLK_EN      => CLK_EN,
              DATA_IN     => DATA_IN,
              TX_BUSY     => TX_BUSY,
              TX_DATA_OUT => TX_DATA_OUT);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        TX_START <= '0';
        DATA_IN <= x"6a";

        wait for 500 ns;
        
        TX_START <= '1';
        
        wait for 200 ns;
        
        TX_START <= '0';
        
        wait for 2000 ns;
        
        TX_START <= '1';
        
        wait for 200 ns;
        
        TX_START <= '0';
        

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_uart_tx_tb of uart_tx_tb is
    for tb
    end for;
end cfg_uart_tx_tb;