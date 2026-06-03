----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
    PORT (
        CLK                 : IN    STD_LOGIC;
        SIG_IN              : IN    STD_LOGIC;
        EDGE_POS            : OUT   STD_LOGIC;
        EDGE_NEG            : OUT   STD_LOGIC;
        EDGE_ANY            : OUT   STD_LOGIC
    );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------

    SIGNAL sig_in_del   : STD_LOGIC := '0';
    SIGNAL sig_edge_pos : STD_LOGIC;
 
    SIGNAL sig_edge_neg : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    
    -- Get delayed signal
    PROCESS (CLK)
    BEGIN
        IF  rising_edge(CLK) THEN
            sig_in_del <= SIG_IN;
        END IF;
    END PROCESS;
    
    -- Edge detection
    sig_edge_pos <=     SIG_IN  AND NOT(sig_in_del);
    sig_edge_neg <= NOT(SIG_IN) AND     sig_in_del;
     
    -- Output value assignment 
    EDGE_POS     <= sig_edge_pos;
    EDGE_NEG     <= sig_edge_neg;
    EDGE_ANY     <= sig_edge_pos OR sig_edge_neg;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
