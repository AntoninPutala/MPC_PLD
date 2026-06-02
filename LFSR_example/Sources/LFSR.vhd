----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02.06.2026 11:17:06
-- Design Name:
-- Module Name: LFSR - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY LFSR IS
    GENERIC (
        LENGTH : INTEGER := 6;
        TAP_1  : INTEGER := 5;
        TAP_2  : INTEGER := 6
    );
	PORT (
		CLK    : IN  STD_LOGIC;
		SRST   : IN  STD_LOGIC;
		CE     : IN  STD_LOGIC;
		BIT_O  : OUT STD_LOGIC;
		WORD_O : OUT STD_LOGIC_VECTOR ((LENGTH-1) DOWNTO 0)
	);
END LFSR;

ARCHITECTURE Behavioral OF LFSR IS

    SIGNAL sreg      : STD_LOGIC_VECTOR ((LENGTH-1) DOWNTO 0) := (OTHERS => '1');
    SIGNAL feedback  : STD_LOGIC;
    
BEGIN

    -- Shift register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (SRST = '1') THEN
                sreg <= (OTHERS => '1');
            ELSIF (CE = '1') THEN
                sreg <= sreg((LENGTH-2) DOWNTO 0) & feedback;
            END IF;
        END IF;
    END PROCESS;
    
    -- Linear feedback
    feedback <= sreg(TAP_1 - 1) XOR sreg(TAP_2 - 1);
    
    -- Outputs
    BIT_O    <= sreg(LENGTH-1);
    WORD_O   <= sreg;
    
END Behavioral;