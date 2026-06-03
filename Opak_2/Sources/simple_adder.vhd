----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/01/2026 02:45:00 PM
-- Design Name:
-- Module Name: simple_adder - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY simple_adder IS
    GENERIC (
        NBIT  : INTEGER := 4
    );
	PORT (
		A     : IN  STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		B     : IN  STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		Y     : OUT STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		C     : OUT STD_LOGIC;
		Z     : OUT STD_LOGIC
	);
END simple_adder;

ARCHITECTURE Behavioral OF simple_adder IS

    SIGNAL y_sig : STD_LOGIC_VECTOR (NBIT DOWNTO 0);

BEGIN

    y_sig <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(A), NBIT + 1) + UNSIGNED(B));
    
    Y     <= y_sig((NBIT - 1) DOWNTO 0);
    C     <= y_sig(NBIT);
    
    Z     <= '1' WHEN (y_sig((NBIT - 1) DOWNTO 0) = (Y'RANGE => '0')) ELSE
             '0';
                 

END Behavioral;