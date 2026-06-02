----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
    GENERIC (
        G_DEB_PERIOD        : POSITIVE := 3
    );    
    PORT ( 
        CLK                 : IN    STD_LOGIC;
        CE                  : IN    STD_LOGIC;
        BTN_IN              : IN    STD_LOGIC;
        BTN_OUT             : OUT   STD_LOGIC
    );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------

    SIGNAL bnt_in_last      : STD_LOGIC := '0';
    SIGNAL bnt_out_reg      : STD_LOGIC := '0';
    SIGNAL block_read       : STD_LOGIC := '0';
    SIGNAL cnt              : INTEGER   := 0;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (CE = '1') THEN
                IF (block_read = '1') THEN
                    IF (cnt >= G_DEB_PERIOD) THEN
                        cnt         <= 0;
                        block_read <= '0';
                    ELSE
                        cnt         <= cnt + 1;
                    END IF;
                ELSE
                    bnt_in_last  <= BTN_IN;
                    
                    IF (bnt_in_last /= BTN_IN) THEN
                        bnt_out_reg  <= BTN_IN;
                        block_read   <= '1';
                    END IF;
                END IF;            
            END IF;
        END IF;
    END PROCESS;

BTN_OUT <= bnt_out_reg;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
