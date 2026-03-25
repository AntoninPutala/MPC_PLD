
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2026 21:42:35
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
    Port ( 
        CLK         : in  STD_LOGIC;
        TX_START    : in  STD_LOGIC;
        CLK_EN      : in  STD_LOGIC;
        DATA_IN     : in  STD_LOGIC_VECTOR (7 downto 0);
        TX_BUSY     : out STD_LOGIC;
        TX_DATA_OUT : out STD_LOGIC
    );
end uart_tx;

architecture Behavioral of uart_tx is

TYPE t_state IS (ST_IDLE, ST_LOAD, ST_WAIT_EN, ST_START, ST_BIT0, ST_BIT1, ST_BIT2, ST_BIT3, 
                 ST_BIT4, ST_BIT5, ST_BIT6, ST_BIT7, ST_STOP);
                
SIGNAL pres_st : t_state := ST_IDLE;
SIGNAL next_st : t_state; 

SIGNAL sig_tx_busy     : STD_LOGIC;
SIGNAL sig_tx_data_out : STD_LOGIC;
SIGNAL sig_data_in     : STD_LOGIC_VECTOR (DATA_IN'RANGE) := (others => '0');

begin

-- State register
PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        pres_st <= next_st;
    END IF;
END PROCESS;

-- Next state logic
PROCESS (pres_st, CLK_EN, TX_START)
BEGIN
    -- default assignment
    next_st <= pres_st;
    
    IF ((pres_st = ST_IDLE) and (TX_START = '1')) THEN
        next_st <= ST_LOAD;
    ELSIF (pres_st = ST_LOAD) THEN
        next_st <= ST_WAIT_EN;
    ELSIF (CLK_EN = '1') THEN
        CASE pres_st IS
            WHEN ST_WAIT_EN =>
                next_st <= ST_START;
            WHEN ST_START =>
                next_st <= ST_BIT0;                
            WHEN ST_BIT0 =>
                next_st <= ST_BIT1;
            WHEN ST_BIT1 =>
                next_st <= ST_BIT2;
            WHEN ST_BIT2 =>
                next_st <= ST_BIT3;
            WHEN ST_BIT3 =>
                next_st <= ST_BIT4;
            WHEN ST_BIT4 =>
                next_st <= ST_BIT5;
            WHEN ST_BIT5 =>
                next_st <= ST_BIT6;  
            WHEN ST_BIT6 =>
                next_st <= ST_BIT7;  
            WHEN ST_BIT7 =>
                next_st <= ST_STOP;  
            WHEN ST_STOP =>
                next_st <= ST_IDLE;  
            WHEN OTHERS  =>
                next_st <= ST_IDLE;                                                                                                                              
        END CASE;
    END IF;
END PROCESS;

-- Output logic
PROCESS (pres_st)
BEGIN
    -- default assignment
    sig_tx_busy <= '0';
    
    IF (pres_st /= ST_IDLE) THEN
        sig_tx_busy <= '1';
    END IF;
END PROCESS;

-- Output mux
PROCESS (pres_st)
BEGIN
    -- default assignment
    sig_tx_data_out <= '1';
    
    CASE pres_st IS
        WHEN ST_START =>
            sig_tx_data_out <= '0';                
        WHEN ST_BIT0 =>
            sig_tx_data_out <= sig_data_in(0);
        WHEN ST_BIT1 =>
            sig_tx_data_out <= sig_data_in(1);
        WHEN ST_BIT2 =>
            sig_tx_data_out <= sig_data_in(2);
        WHEN ST_BIT3 =>
            sig_tx_data_out <= sig_data_in(3);
        WHEN ST_BIT4 =>
            sig_tx_data_out <= sig_data_in(4);
        WHEN ST_BIT5 =>
            sig_tx_data_out <= sig_data_in(5);  
        WHEN ST_BIT6 =>
            sig_tx_data_out <= sig_data_in(6);  
        WHEN ST_BIT7 =>
            sig_tx_data_out <= sig_data_in(7); 
        WHEN OTHERS =>
            sig_tx_data_out <= '1';                                                                                                                                 
    END CASE;
END PROCESS;

-- load register
PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        IF (pres_st = ST_LOAD) THEN
            sig_data_in <= DATA_IN;
        END IF;
    END IF;
END PROCESS;

-- output register
PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        TX_DATA_OUT <= sig_tx_data_out;  
        TX_BUSY     <= sig_tx_busy; 
    END IF;
END PROCESS;

end Behavioral;
