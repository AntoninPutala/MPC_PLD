
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
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

    signal SIG_CLEAR : STD_LOGIC := '0';
    signal SIG_BLOCK : STD_LOGIC := '0';
    
    signal SIG_COUNT : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(G_DEB_PERIOD)))) - 1) DOWNTO 0) := (others => '0');
    
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
process (CLK)
begin
    if rising_edge(CLK) then
        if (CE = '1') then
            if (SIG_BLOCK = '1') then
                if (SIG_COUNT >= (G_DEB_PERIOD - 1)) then
                    SIG_COUNT <= (others => '0'); 
                    SIG_BLOCK <= '0';
                else
                    SIG_COUNT <= SIG_COUNT + 1;
                    SIG_BLOCK <= '1';
                end if;
            else
                if (BTN_IN /= SIG_CLEAR) then
                    SIG_CLEAR <= BTN_IN;
                    SIG_BLOCK <= '1';
                end if;
            end if;
        end if;
    end if;
end process;

BTN_OUT <= SIG_CLEAR;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
