----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/03/2026 01:47:09 PM
-- Design Name:
-- Module Name: pwm_driver - Behavioral
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
USE WORK.PKG_CONSTANTS.ALL;
USE IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY pwm_driver IS
	PORT (
		CLK          : IN  STD_LOGIC;
		PWM_REF_0    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_1    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_2    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_3    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_4    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_5    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_6    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_REF_7    : IN  STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
		PWM_OUT      : OUT STD_LOGIC_VECTOR ((G_NCH-1) DOWNTO 0);
		CNT_OUT      : OUT STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0)
	);
END pwm_driver;

ARCHITECTURE Behavioral OF pwm_driver IS

    CONSTANT CNT_MAX : INTEGER := ((2 ** G_RES) - 1);

    COMPONENT counter_to_n
        GENERIC (
            NCYCLE   : INTEGER := 255
        );
	    PORT (
		    CLK      : IN  STD_LOGIC;
		    SRST     : IN  STD_LOGIC;
		    CE       : IN  STD_LOGIC;
		    CNT      : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(NCYCLE)))) - 1) DOWNTO 0)
	   );
    END COMPONENT;
    
    SIGNAL cnt       : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);
    
BEGIN

    counter_to_n_i: counter_to_n
    generic map (
        NCYCLE => CNT_MAX
    )
    port map (
        CLK    => CLK,
        SRST   => '0',
        CE     => '1',
        CNT    => cnt
    );
    
    PWM_OUT(0) <= '1' WHEN (cnt < PWM_REF_0) ELSE '0';
    PWM_OUT(1) <= '1' WHEN (cnt < PWM_REF_1) ELSE '0';
    PWM_OUT(2) <= '1' WHEN (cnt < PWM_REF_2) ELSE '0';
    PWM_OUT(3) <= '1' WHEN (cnt < PWM_REF_3) ELSE '0';
    PWM_OUT(4) <= '1' WHEN (cnt < PWM_REF_4) ELSE '0';
    PWM_OUT(5) <= '1' WHEN (cnt < PWM_REF_5) ELSE '0';
    PWM_OUT(6) <= '1' WHEN (cnt < PWM_REF_6) ELSE '0';
    PWM_OUT(7) <= '1' WHEN (cnt < PWM_REF_7) ELSE '0';
    
    CNT_OUT    <= cnt;

END Behavioral;