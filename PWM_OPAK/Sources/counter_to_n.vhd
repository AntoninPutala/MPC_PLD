----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/03/2026 01:54:51 PM
-- Design Name:
-- Module Name: counter_to_n - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY counter_to_n IS
    GENERIC (
        NCYCLE : INTEGER := 255
    );
	PORT (
		CLK    : IN  STD_LOGIC;
		SRST   : IN  STD_LOGIC;
		CE     : IN  STD_LOGIC;
		CNT    : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(NCYCLE)))) - 1) DOWNTO 0)
	);
END counter_to_n;

ARCHITECTURE Behavioral OF counter_to_n IS

    SIGNAL cnt_uns : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(NCYCLE)))) - 1) DOWNTO 0) := (OTHERS => '0');

BEGIN

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF    (SRST = '1') THEN
                cnt_uns <= (OTHERS => '0');
            ELSIF (CE   = '1') THEN
                IF (cnt_uns < (NCYCLE - 1)) THEN
                    cnt_uns <= cnt_uns + 1;
                ELSE
                    cnt_uns <= (OTHERS => '0');
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    CNT <= STD_LOGIC_VECTOR(cnt_uns);

END Behavioral;