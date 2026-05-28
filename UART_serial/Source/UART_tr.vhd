----------------------------------------------------------------------------------
-- Company:  Brno University of Technology
-- Engineer: Antonin Putala
-- 
-- Create Date: 28.05.2026 17:07:41
-- Design Name: 
-- Module Name: UART_tr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY UART_tr IS
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
END UART_tr;

ARCHITECTURE Behavioral OF UART_tr IS

    TYPE t_state IS (st_idle, st_write);
    
    CONSTANT CNT_MAX       : INTEGER := (LENGTH + 2);                 
    -- length + start_bit + stop_bit
    CONSTANT IDLE_VAL      : STD_LOGIC := '0'; 
    CONSTANT START_VAL     : STD_LOGIC := '1'; 
    CONSTANT STOP_VAL      : STD_LOGIC := '0';
    
    SIGNAL pres_st         : t_state := st_idle;
    SIGNAL next_st         : t_state;
    
    SIGNAL sig_sreg        : STD_LOGIC_VECTOR((LENGTH + 2) DOWNTO 0) := (OTHERS => IDLE_VAL); 
    -- length + start_bit + stop_bit + idle
    
    SIGNAL sig_shift       : STD_LOGIC := '0';
    SIGNAL sig_load        : STD_LOGIC := '0'; 
    SIGNAL sig_uart_txd    : STD_LOGIC := IDLE_VAL;
    SIGNAL sig_tx_busy     : STD_LOGIC;
    SIGNAL sig_tx_busy_reg : STD_LOGIC := '0';
    
    
    SIGNAL sig_cnt         : INTEGER := 0;  
    SIGNAL sig_cnt_next    : INTEGER;  

BEGIN

-- State register & counter
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            pres_st <= next_st;
            sig_cnt <= sig_cnt_next;
        END IF;
    END PROCESS;
    
-- Next state logic
    PROCESS (pres_st, TX_START, CLK_EN)
    BEGIN
    -- Default assignment
    next_st <= pres_st;
    
        CASE pres_st IS
            WHEN st_idle    => 
                IF  (TX_START = '1') THEN
                    next_st <= st_write;
                END IF;
            WHEN st_write   =>
                IF ((CLK_EN   = '1') AND (sig_cnt  >= CNT_MAX)) THEN
                    next_st <= st_idle;
                END IF;
        END CASE;
    END PROCESS;
    
-- Output logic
    PROCESS (pres_st, sig_cnt, CLK_EN, TX_START)
    BEGIN
    -- Default assignment
    sig_shift    <= '0';
    sig_cnt_next <= sig_cnt;
    sig_load     <= '0';
    sig_tx_busy  <= '0';
    
        IF (pres_st = st_write) THEN
            sig_tx_busy  <= '1';
            
            IF (CLK_EN   = '1') THEN
                sig_shift    <= '1';
                sig_cnt_next <= sig_cnt + 1;
                
                IF (sig_cnt >= CNT_MAX) THEN
                    sig_cnt_next <= 0;
                END IF;
            END IF;
        END IF;
        
        IF  (pres_st = st_idle) THEN
            sig_cnt_next <= 0;
            
            IF (TX_START = '1') THEN
                sig_load <= '1';
            END IF;
        END IF;
    END PROCESS;  
    
-- Shift register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF    (sig_load  = '1') THEN
                sig_sreg <= STOP_VAL & DATA_IN & START_VAL & IDLE_VAL;
            ELSIF (sig_shift = '1') THEN
                sig_sreg <= IDLE_VAL & sig_sreg((sig_sreg'HIGH) DOWNTO 1);
            END IF;
        END IF;
    END PROCESS;
    
-- Output register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            sig_tx_busy_reg <= sig_tx_busy;
            sig_uart_txd    <= sig_sreg(0);
        END IF;
    END PROCESS;
    
-- Assign signals to outputs
    TX_BUSY  <= sig_tx_busy_reg;
    UART_TXD <= sig_uart_txd;
END Behavioral;
