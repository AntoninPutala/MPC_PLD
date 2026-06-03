--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
    PORT (
        CLK                 : IN    STD_LOGIC;
        BTN_S_S             : IN    STD_LOGIC;
        BTN_L_C             : IN    STD_LOGIC;
        CNT_RESET           : OUT   STD_LOGIC;
        CNT_ENABLE          : OUT   STD_LOGIC;
        DISP_ENABLE         : OUT   STD_LOGIC
    );
END ENTITY stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
--------------------------------------------------------------------------------

    TYPE t_state IS (st_idle, st_run, st_lap, st_refresh, st_stop); 
    SIGNAL pres_st          : t_state := st_IDLE;
    SIGNAL next_st          : t_state;   

--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            pres_st <= next_st;
        END IF;
    END PROCESS;
    
    PROCESS (pres_st, BTN_S_S, BTN_L_C)
    BEGIN
        next_st <= pres_st;
        
        CASE (pres_st) IS
            WHEN st_idle =>
                IF (BTN_S_S = '1') THEN
                    next_st <= st_run;    
                END IF;
            WHEN st_run =>
                IF (BTN_S_S = '1') THEN
                    next_st <= st_stop;   
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_lap; 
                END IF; 
            WHEN st_stop =>
                IF (BTN_S_S = '1') THEN
                    next_st <= st_run;   
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_idle; 
                END IF; 
            WHEN st_lap =>
                IF (BTN_S_S = '1') THEN
                    next_st <= st_run;   
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_refresh; 
                END IF; 
            WHEN st_refresh =>
                next_st <= st_lap; 
            WHEN OTHERS =>
                next_st <= pres_st;
        END CASE;
    END PROCESS;
    
    PROCESS (pres_st)
    BEGIN
        CNT_RESET   <= '0';
        CNT_ENABLE  <= '1';
        DISP_ENABLE <= '1';
        
        CASE (pres_st) IS
            WHEN st_idle =>
                CNT_RESET   <= '1';
                CNT_ENABLE  <= '0';
            WHEN st_stop =>
                CNT_ENABLE  <= '0';
            WHEN st_lap =>
                DISP_ENABLE <= '0';
            WHEN OTHERS =>
                CNT_RESET   <= '0';
                CNT_ENABLE  <= '1';
                DISP_ENABLE <= '1';
        END CASE;
    END PROCESS;    

--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------
