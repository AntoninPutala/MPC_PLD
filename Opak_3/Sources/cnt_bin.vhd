----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/01/2026 04:14:51 PM
-- Design Name:
-- Module Name: cnt_bin - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY cnt_bin IS
    GENERIC (
        NBIT       : INTEGER := 32
    );
	PORT (
		CLK        : IN  STD_LOGIC;
		SRST       : IN  STD_LOGIC;
		CE         : IN  STD_LOGIC;
		CNT_LOAD   : IN  STD_LOGIC;
		CNT_UP     : IN  STD_LOGIC;
		DATA_LOAD  : IN  STD_LOGIC_VECTOR ((NBIT-1) DOWNTO 0);
		CNT        : OUT STD_LOGIC_VECTOR ((NBIT-1) DOWNTO 0)
	);
END cnt_bin;

ARCHITECTURE Behavioral OF cnt_bin IS

    SIGNAL sig_cnt : UNSIGNED (CNT'RANGE) := (OTHERS => '0');

BEGIN

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (SRST = '1') THEN
                sig_cnt <= (others => '0');
            ELSIF (CE = '1') THEN
                IF (CNT_LOAD = '1') THEN
                    sig_cnt <= UNSIGNED(DATA_LOAD);
                ELSE
                    IF (CNT_UP = '1') THEN
                        sig_cnt <= sig_cnt + 1;
                    ELSE
                        sig_cnt <= sig_cnt - 1;
                    END IF;
                END IF;
            END IF;
        END IF;    
    END PROCESS;
    
    CNT <= STD_LOGIC_VECTOR(sig_cnt);

END Behavioral;