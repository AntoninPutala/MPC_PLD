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

    signal SIG_REG : STD_LOGIC;
    
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of sig_reg : signal is "TRUE";
    attribute ASYNC_REG of sig_out : signal is "TRUE";

    -- No LUT for shift register
    attribute SHREG_EXTRACT : string;           
    attribute SHREG_EXTRACT of sig_reg : signal is "NO";
    attribute SHREG_EXTRACT of sig_out : signal is "NO";
  
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    process (CLK)
    begin
        if rising_edge(CLK) then
            SIG_REG <= SIG_IN;
            SIG_OUT <= SIG_REG;
        end if;
    end process;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
