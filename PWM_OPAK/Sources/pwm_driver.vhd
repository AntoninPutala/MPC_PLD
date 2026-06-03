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
USE WORK.PKG_TYPES.ALL;
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
		PWM_REF      : IN  type_pwm_ref;
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
    
    PROCESS (cnt, PWM_REF)
    BEGIN
    
        PWM_OUT <= (OTHERS => '0');
    
        loop_1 : FOR i IN 0 TO (G_NCH - 1) 
        LOOP
            IF (cnt < PWM_REF(i)) THEN 
                PWM_OUT(i) <= '1';
            ELSE
                PWM_OUT(i) <= '0';
            END IF;
        END LOOP;
    END PROCESS;
    
    CNT_OUT    <= cnt;

END Behavioral;