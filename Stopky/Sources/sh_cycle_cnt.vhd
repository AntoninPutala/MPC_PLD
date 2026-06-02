----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02.06.2026 14:41:31
-- Design Name:
-- Module Name: sh_cycle_cnt - Behavioral
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

ENTITY sh_cycle_cnt IS
    GENERIC (
        N_CYCLE : INTEGER := 10
    );
	PORT (
		CLK        : IN  STD_LOGIC;
		CE         : IN  STD_LOGIC;
		SRST       : IN  STD_LOGIC;
		CARRY      : OUT STD_LOGIC;
		CNT        : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) DOWNTO 0)
	);
END sh_cycle_cnt;

ARCHITECTURE Behavioral OF sh_cycle_cnt IS

    SIGNAL cnt_uns : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) DOWNTO 0) := (OTHERS => '0');
    
BEGIN

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (SRST = '1') THEN
                cnt_uns <= (OTHERS => '0');    
            ELSIF (CE = '1') THEN
                IF (cnt_uns >= (N_CYCLE - 1)) THEN
                    cnt_uns <= (OTHERS => '0');
                ELSE
                    cnt_uns <= cnt_uns + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
   
    CNT   <= STD_LOGIC_VECTOR(cnt_uns);
    
    CARRY <= '1' WHEN (cnt_uns >= (N_CYCLE - 1)) ELSE
             '0';

END Behavioral;