----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
    PORT(
        CLK                     : IN  STD_LOGIC;
        BTN                     : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW                      : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        UART_TXD                : OUT STD_LOGIC;
        LED                     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_SEG                : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG                : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------
    
    signal CE_UART              : STD_LOGIC;
    signal CE_1000HZ            : STD_LOGIC;
    signal TX_START             : STD_LOGIC;
    signal DATA_IN              : STD_LOGIC_VECTOR (7 DOWNTO 0);
    
    constant CLOCK_FREQ         : INTEGER := 50000000;
    constant BAUD_RATE          : INTEGER := 115200;
    
    constant BAUD_PERIOD        : INTEGER := (CLOCK_FREQ / BAUD_RATE);
    constant DEBOUNCE_TIME      : INTEGER := 40;

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
    
    COMPONENT uart_tx
        Port ( 
            CLK                 : in  STD_LOGIC;
            TX_START            : in  STD_LOGIC;
            CLK_EN              : in  STD_LOGIC;
            DATA_IN             : in  STD_LOGIC_VECTOR (7 downto 0);
            TX_BUSY             : out STD_LOGIC;
            TX_DATA_OUT         : out STD_LOGIC
        );
    END COMPONENT uart_tx;  
    
    COMPONENT btn_in
        GENERIC (
            G_DEB_PERIOD        : POSITIVE := 3
        );
        PORT (
            CLK                 : IN    STD_LOGIC;
            CE                  : IN    STD_LOGIC;
            BTN                 : IN    STD_LOGIC;
            BTN_DEBOUNCED       : OUT   STD_LOGIC;
            BTN_EDGE_POS        : OUT   STD_LOGIC;
            BTN_EDGE_NEG        : OUT   STD_LOGIC;
            BTN_EDGE_ANY        : OUT   STD_LOGIC
        );
    END COMPONENT btn_in;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  -- clock enable generator
    ce_gen_1 : ce_gen
        GENERIC MAP (
            G_DIV_FACT         => BAUD_PERIOD
        )
        PORT MAP  (
            CLK                => CLK,
            SRST               => '0',
            CE                 => '1',
            CE_O               => CE_UART
        );
     
    ce_gen_2 : ce_gen
        GENERIC MAP (
            G_DIV_FACT         => 50000
        )
        PORT MAP (
            CLK                => CLK,
            SRST               => '0',
            CE                 => '1',
            CE_O               => CE_1000HZ
        );

  --------------------------------------------------------------------------------
  -- button input module
    btn_in_1 : btn_in
        GENERIC MAP (
            G_DEB_PERIOD       => DEBOUNCE_TIME
        )
        PORT MAP (
            CLK                => CLK,
            CE                 => CE_1000HZ,
            BTN                => BTN(0),
            BTN_DEBOUNCED      => open,
            BTN_EDGE_POS       => open,
            BTN_EDGE_NEG       => TX_START,
            BTN_EDGE_ANY       => open
        );

  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  uart_tx_i : uart_tx
      PORT MAP (
           CLK                 => CLK,
           TX_START            => TX_START,
           CLK_EN              => CE_UART,
           DATA_IN             => DATA_IN,
           TX_BUSY             => LED(0),
           TX_DATA_OUT         => UART_TXD
      ); 
      
   DISP_SEG        <= (OTHERS => '1');
   DISP_DIG        <= (OTHERS => '1');
   LED(7 DOWNTO 1) <= (OTHERS => '0');
   DATA_IN         <= x"4" & SW;
      
----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
