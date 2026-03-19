
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
    TYPE t_state IS (st_IDLE, st_RUN, st_LAP, st_REFRESH, st_STOP); 
    SIGNAL pres_st       : t_state := st_IDLE;
    SIGNAL next_st       : t_state;   
    
    SIGNAL CNT_RESET_C   : STD_LOGIC;
    SIGNAL CNT_ENABLE_C  : STD_LOGIC;
    SIGNAL DISP_ENABLE_C : STD_LOGIC;
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
    -- state register
    PROCESS (CLK) 
    BEGIN
        IF rising_edge(CLK) THEN
            pres_st <= next_st;
        END IF;
    END PROCESS;
    
    -- next state logic
    PROCESS (pres_st, BTN_S_S, BTN_L_C)
    BEGIN
    
        next_st <= pres_st; -- default assignment
    
        CASE pres_st IS
            WHEN st_IDLE    => 
            
                IF    (BTN_S_S = '1') THEN
                    next_st <= st_RUN;
                END IF;
                
            WHEN st_RUN     => 
            
                IF    (BTN_S_S = '1') THEN
                    next_st <= st_STOP;
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_LAP;
                END IF;
            
            WHEN st_LAP     =>

                IF    (BTN_S_S = '1') THEN
                    next_st <= st_RUN;
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_REFRESH;
                END IF;
            
            WHEN st_REFRESH => 
            
                next_st <= st_LAP;
            
            WHEN st_STOP    => 
            
                IF    (BTN_S_S = '1') THEN
                    next_st <= st_RUN;
                ELSIF (BTN_L_C = '1') THEN
                    next_st <= st_IDLE;
                END IF;
            
        END CASE;
    END PROCESS;
    
    -- output logic
    PROCESS (pres_st) 
    BEGIN
        
        CNT_RESET_C   <= '0';
        CNT_ENABLE_C  <= '0';
        DISP_ENABLE_C <= '0';
        
        CASE pres_st IS
            WHEN st_IDLE    => 
            
                CNT_RESET_C   <= '1';
                DISP_ENABLE_C <= '1';    
            
            WHEN st_RUN     => 
            
                CNT_ENABLE_C  <= '1';
                DISP_ENABLE_C <= '1';  
            
            WHEN st_LAP     => 
            
                CNT_ENABLE_C  <= '1';
                
            WHEN st_REFRESH => 

                CNT_ENABLE_C  <= '1';
                DISP_ENABLE_C <= '1';              
            
            WHEN st_STOP    => 
         
                DISP_ENABLE_C <= '1';      
                      
        END CASE;
    END PROCESS;
    
    -- output register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            CNT_RESET   <= CNT_RESET_C;
            CNT_ENABLE  <= CNT_ENABLE_C;
            DISP_ENABLE <= DISP_ENABLE_C;  
        END IF;
    END PROCESS;

--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------
