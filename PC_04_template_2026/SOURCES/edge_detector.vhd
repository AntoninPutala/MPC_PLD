
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
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

    signal SIG_DEL      : STD_LOGIC;
    signal SIG_EDGE_POS : STD_LOGIC;
    signal SIG_EDGE_NEG : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    process (CLK)
    begin
        if rising_edge(CLK) then
            SIG_DEL <= SIG_IN;
        end if;
    end process;
    
    SIG_EDGE_POS <= SIG_IN and not(SIG_DEL);
    SIG_EDGE_NEG <= not(SIG_IN) and SIG_DEL;
    
    EDGE_POS <= SIG_EDGE_POS;
    EDGE_NEG <= SIG_EDGE_NEG;
    EDGE_ANY <= SIG_EDGE_POS or SIG_EDGE_NEG;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
