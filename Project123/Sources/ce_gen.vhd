----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
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
   signal CNT_DIV : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(G_DIV_FACT)))) - 1) DOWNTO 0) := (others => '0');


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    process (CLK)
    begin
        if rising_edge(CLK) then
            if (SRST = '1') then
                CNT_DIV <= (others => '0');
                CE_O    <= '0';
            elsif (CE = '1') then
                if (CNT_DIV = (G_DIV_FACT - 1)) then
                    CNT_DIV <= (others => '0');
                    CE_O    <= '1';    
                else
                    CNT_DIV <= CNT_DIV + 1;
                    CE_O    <= '0'; 
                end if;
            end if;
        end if;
    end process;



----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
