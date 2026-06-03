----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/01/2026 02:17:59 PM
-- Design Name:
-- Module Name: rp_top - Behavioral
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

ENTITY rp_top IS
	PORT (
		SW  : IN  STD_LOGIC_VECTOR (4 DOWNTO 1);
		BTN : IN  STD_LOGIC_VECTOR (4 DOWNTO 1);
		LED : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END rp_top;

ARCHITECTURE Behavioral OF rp_top IS

BEGIN

    --LED <= (BTN(1), NOT(BTN(4)) , OTHERS => '0');
    LED <= "01010101" WHEN ((SW = X"C") AND (BTN(2) = '1')) ELSE "10101010";

END Behavioral;