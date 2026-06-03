----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
    GENERIC (
        G_DIV_FACT          : POSITIVE := 2
    );
    PORT (
        CLK                 : IN  STD_LOGIC;
        SRST                : IN  STD_LOGIC;
        CE                  : IN  STD_LOGIC;
        CE_O                : OUT STD_LOGIC 
    );  
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------

    SIGNAL cnt       : INTEGER := 0;    
    SIGNAL cnt_next  : INTEGER;  
    
    SIGNAL ce_o_pres : STD_LOGIC := '0';  
    SIGNAL ce_o_next : STD_LOGIC;  
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            cnt       <= cnt_next;
            ce_o_pres <= ce_o_next;
        END IF;
    END PROCESS;
    
    PROCESS (cnt, SRST, CE)
    BEGIN
        cnt_next <= cnt;
        ce_o_next <= '0';
    
        IF (SRST = '1') THEN
            cnt_next <= 0;
        ELSIF (CE = '1') THEN
            IF (cnt >= (G_DIV_FACT-1)) THEN
                cnt_next <= 0;
                ce_o_next <= '1';
            ELSE
                cnt_next <= cnt + 1;
            END IF;
        END IF;
    END PROCESS;
    
    CE_O <= ce_o_pres;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
