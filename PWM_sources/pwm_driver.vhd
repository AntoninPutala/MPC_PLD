----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Antonin Putala
-- 
-- Create Date: 03/27/2026 09:19:45 AM
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.PKG_CONSTANTS.ALL;
use WORK.PKG_TYPES.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- G_NCH and G_RES are defined in pkg_constants
-- type_pwm_ref is defined in pkg_types as:
--   TYPE type_pwm_ref IS ARRAY(G_NCH-1 DOWNTO 0) OF
--      STD_LOGIC_VECTOR(G_RES-1 DOWNTO 0);                      

entity pwm_driver is
    Generic (
        G_RES : INTEGER := 8;
        G_NCH : INTEGER := 8
    );
    Port ( 
        CLK       : in  STD_LOGIC;
        CE        : in  STD_LOGIC;
        SRST      : in  STD_LOGIC;
        PWM_REF   : in  type_pwm_ref;
        PWM_OUT   : out STD_LOGIC_VECTOR ((G_NCH - 1) DOWNTO 0);
        CNT_OUT   : out STD_LOGIC_VECTOR ((G_RES - 1) DOWNTO 0)
    );
end pwm_driver;

architecture Behavioral of pwm_driver is

    COMPONENT nbit_bin_counter
        Generic (
            CNT_WIDTH : INTEGER := 4
        );
        Port ( 
            CLK  : in STD_LOGIC;
            SRST : in STD_LOGIC;
            CE   : in STD_LOGIC;
            CNT  : out STD_LOGIC_VECTOR ((CNT_WIDTH - 1) downto 0)
        );
    END COMPONENT;
    
    SIGNAL sig_cnt : STD_LOGIC_VECTOR ((G_RES - 1) downto 0);

begin

    nbit_bin_counter_i: nbit_bin_counter
        generic map (
            CNT_WIDTH => G_RES
        )
        port map (
            CLK  => CLK,
            SRST => SRST,
            CE   => CE,
            CNT  => sig_cnt
        );    
    
    PROCESS (sig_cnt, PWM_REF) 
    BEGIN
        PWM_OUT <= (OTHERS => '0');
    
        FOR i IN 0 TO (G_NCH - 1) LOOP
            IF (PWM_REF(i) > sig_cnt) THEN
                PWM_OUT(i) <= '1';
            ELSE
                PWM_OUT(i) <= '0';
            END IF;
        END LOOP;
    END PROCESS;
    
    CNT_OUT <= sig_cnt;

end Behavioral;
