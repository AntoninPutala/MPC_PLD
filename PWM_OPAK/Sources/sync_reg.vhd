----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
    PORT(
        CLK                 : IN    STD_LOGIC;
        SIG_IN              : IN    STD_LOGIC;
        SIG_OUT             : OUT   STD_LOGIC
    );
END ENTITY sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------

    SIGNAL sig_reg          : STD_LOGIC := '0';
    SIGNAL sig_out_reg      : STD_LOGIC := '0';
    
    attribute ASYNC_REG                : string;
    attribute ASYNC_REG of sig_reg     : signal is "TRUE";
    attribute ASYNC_REG of sig_out     : signal is "TRUE";
    
    attribute SHREG_EXTRACT            : string;        

    attribute SHREG_EXTRACT of sig_reg : signal is "NO";
    attribute SHREG_EXTRACT of sig_out : signal is "NO";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            sig_reg     <= SIG_IN;
            sig_out_reg <= sig_reg;
        END IF;
    END PROCESS;

    SIG_OUT <= sig_out_reg;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
