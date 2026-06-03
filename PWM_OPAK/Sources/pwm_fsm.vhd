----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/03/2026 02:50:12 PM
-- Design Name:
-- Module Name: pwm_fsm - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY pwm_fsm IS
	PORT (
		CLK     : IN  STD_LOGIC;
		CE      : IN  STD_LOGIC;
		DIR     : IN  STD_LOGIC;
		PWM_REF : OUT type_pwm_ref
	);
END pwm_fsm;

ARCHITECTURE Behavioral OF pwm_fsm IS

    TYPE t_state IS (st_00, st_01, st_02, st_03, st_04, st_05, st_06, st_07);
    SIGNAL pres_st   : t_state := st_00;
    SIGNAL next_st   : t_state;
    
    SIGNAL pwm_reg_c : type_pwm_ref;
    SIGNAL pwm_reg_r : type_pwm_ref := (OTHERS => (OTHERS => '0'));

BEGIN

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            pres_st <= next_st;
        END IF;
    END PROCESS;
    
    PROCESS (pres_st, CE, DIR)
    BEGIN
        next_st <= pres_st;
        
        IF (CE = '1') THEN
            CASE pres_st IS
                WHEN st_00 =>
                    IF (DIR = '0') THEN
                        next_st <= st_01;
                    ELSE
                        next_st <= st_07;
                    END IF;                    
                WHEN st_01 =>
                    IF (DIR = '0') THEN
                        next_st <= st_02;
                    ELSE
                        next_st <= st_00;
                    END IF;                
                WHEN st_02 =>
                    IF (DIR = '0') THEN
                        next_st <= st_03;
                    ELSE
                        next_st <= st_01;
                    END IF;
                WHEN st_03 =>
                    IF (DIR = '0') THEN
                        next_st <= st_04;
                    ELSE
                        next_st <= st_02;
                    END IF; 
                WHEN st_04 =>
                    IF (DIR = '0') THEN
                        next_st <= st_05;
                    ELSE
                        next_st <= st_03;
                    END IF;                    
                WHEN st_05 =>
                    IF (DIR = '0') THEN
                        next_st <= st_06;
                    ELSE
                        next_st <= st_04;
                    END IF;                
                WHEN st_06 =>
                    IF (DIR = '0') THEN
                        next_st <= st_07;
                    ELSE
                        next_st <= st_05;
                    END IF;
                WHEN st_07 =>
                    IF (DIR = '0') THEN
                        next_st <= st_00;
                    ELSE
                        next_st <= st_06;
                    END IF;   
                WHEN OTHERS =>
                    next_st <= pres_st;                       
            END CASE;
        END IF;
    END PROCESS;
    
    PROCESS (pres_st)
    BEGIN
        pwm_reg_c <= (OTHERS => (OTHERS => '0'));
        
        CASE pres_st IS
            WHEN st_00 =>
                pwm_reg_c <= (PWM_4, PWM_3, PWM_2, PWM_1, PWM_0, PWM_1, PWM_2, PWM_3);  
            WHEN st_01 =>
                pwm_reg_c <= (PWM_3, PWM_4, PWM_3, PWM_2, PWM_1, PWM_0, PWM_1, PWM_2);                 
            WHEN st_02 =>
                pwm_reg_c <= (PWM_2, PWM_3, PWM_4, PWM_3, PWM_2, PWM_1, PWM_0, PWM_1);  
            WHEN st_03 =>
                pwm_reg_c <= (PWM_1, PWM_2, PWM_3, PWM_4, PWM_3, PWM_2, PWM_1, PWM_0);  
            WHEN st_04 =>
                pwm_reg_c <= (PWM_0, PWM_1, PWM_2, PWM_3, PWM_4, PWM_3, PWM_2, PWM_1);                   
            WHEN st_05 =>
                pwm_reg_c <= (PWM_1, PWM_0, PWM_1, PWM_2, PWM_3, PWM_4, PWM_3, PWM_2);                
            WHEN st_06 =>
                pwm_reg_c <= (PWM_2, PWM_1, PWM_0, PWM_1, PWM_2, PWM_3, PWM_4, PWM_3);  
            WHEN st_07 =>
                pwm_reg_c <= (PWM_3, PWM_2, PWM_1, PWM_0, PWM_1, PWM_2, PWM_3, PWM_4);            
            WHEN OTHERS =>
                pwm_reg_c <= (OTHERS => (OTHERS => '0'));       
        END CASE;
    END PROCESS;
    
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            pwm_reg_r <= pwm_reg_c;
        END IF;
    END PROCESS;
    
    PWM_REF <= pwm_reg_r;

END Behavioral;