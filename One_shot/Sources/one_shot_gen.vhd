----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2026 22:30:35
-- Design Name: 
-- Module Name: one_shot_gen - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- EARLY_START = 0 - ignore
-- EARLY_START = 1 - nex start

entity one_shot_gen is
    Generic (
        IMPULSE_LEN : POSITIVE := 4;
        EARLY_START : STD_LOGIC := '0';
        STOP_DELAY  : POSITIVE := 4
    );
    Port ( 
        SRST       : in  STD_LOGIC;
        CLK        : in  STD_LOGIC;
        CE         : in  STD_LOGIC;
        START_I    : in  STD_LOGIC;
        IMPULSE_O  : out STD_LOGIC;
        READY_O    : out STD_LOGIC;
        FINISHED_O : out STD_LOGIC
    );
end one_shot_gen;

architecture Behavioral of one_shot_gen is

    TYPE t_state IS (ST_IDLE, ST_WAIT, ST_TRIG, ST_PULSE, ST_RESTART, ST_FINISH, ST_BLOCK);
                
    SIGNAL pres_st : t_state := ST_IDLE;
    SIGNAL next_st : t_state; 
    
    SIGNAL srst_imp : STD_LOGIC;
    SIGNAL trg_imp  : STD_LOGIC;
    SIGNAL over_imp : STD_LOGIC;
    SIGNAL srst_del : STD_LOGIC;
    SIGNAL trg_del  : STD_LOGIC;
    SIGNAL over_del : STD_LOGIC;
    SIGNAL finished : STD_LOGIC;
    SIGNAL impulse  : STD_LOGIC;
    SIGNAL ready    : STD_LOGIC;
           
    COMPONENT pulse_gen
        Generic (
            G_DIV_FACT : POSITIVE := 2    
        );
        Port ( 
            SRST       : in  STD_LOGIC;
            CE         : in  STD_LOGIC;
            CLK        : in  STD_LOGIC;
            TRG        : in  STD_LOGIC;
            OVERFL     : out STD_LOGIC
        );
    END COMPONENT;

begin
    
    -- state register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            pres_st <= next_st;
        END IF;     
    END PROCESS;
    
    -- next state logic
    PROCESS (pres_st, over_imp, over_del, SRST, CE, START_I)
    BEGIN
        next_st <= pres_st;
        
        CASE pres_st IS
            WHEN ST_IDLE =>
                IF (START_I = '1') THEN
                    next_st <= ST_WAIT;
                END IF;
            WHEN ST_WAIT =>    
                IF (CE = '1') THEN
                    next_st <= ST_TRIG;
                END IF;
            WHEN ST_TRIG =>    
                next_st <= ST_PULSE;
            WHEN ST_RESTART =>    
                next_st <= ST_TRIG;
            WHEN ST_PULSE =>    
                IF (over_imp = '1') THEN
                    next_st <= ST_FINISH;
                ELSIF ((EARLY_START = '1') and (START_I = '1')) THEN
                    next_st <= ST_RESTART;
                END IF;
            WHEN ST_FINISH =>    
                IF (CE = '1') THEN
                    IF (EARLY_START = '1') THEN
                        next_st <= ST_IDLE;
                    ELSIF (STOP_DELAY < 2) THEN
                        next_st <= ST_IDLE;
                    ELSE
                        next_st <= ST_BLOCK; 
                    END IF;
                END IF;
            WHEN ST_BLOCK =>
                IF (over_del = '1') THEN
                    next_st <= ST_IDLE;
                END IF;
            WHEN OTHERS =>
                next_st <= ST_IDLE;
        END CASE;
        
        IF (SRST = '1') THEN
            next_st <= ST_IDLE;
        END IF;
    END PROCESS;
    
    -- output logic
    PROCESS (pres_st)
    BEGIN
        finished   <= '0';
        ready      <= '0';
        impulse    <= '0';
        trg_imp    <= '0';
        srst_imp   <= '0';
        trg_del    <= '0';
        srst_del   <= '0';
        
        CASE pres_st IS
            WHEN ST_IDLE    =>
                srst_imp   <= '1';
                srst_del   <= '1';
                ready      <= '1';
            WHEN ST_TRIG   =>    
                trg_imp    <= '1';
                impulse    <= '1';
            WHEN ST_PULSE   =>    
                impulse    <= '1';
            WHEN ST_FINISH  =>    
                finished   <= '1';
                trg_del    <= '1';
            WHEN ST_RESTART =>    
                srst_imp   <= '1';
                impulse    <= '1';
            WHEN OTHERS     =>
                finished   <= '0';
                ready      <= '0';
                impulse    <= '0';
                trg_imp    <= '0';
                srst_imp   <= '0';
                trg_del    <= '0';
                srst_del   <= '0';
        END CASE;
    END PROCESS;   
    
    -- output register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            FINISHED_O <= finished;
            READY_O    <= ready;
            IMPULSE_O  <= impulse;
        END IF;     
    END PROCESS;
    
    pulse_gen_1 : pulse_gen
        Generic map (
            G_DIV_FACT => IMPULSE_LEN  
        )
        Port map ( 
            SRST       => srst_imp,
            CE         => CE,
            CLK        => CLK,
            TRG        => trg_imp,
            OVERFL     => over_imp
        );

    pulse_gen_2 : pulse_gen
        Generic map (
            G_DIV_FACT => STOP_DELAY  
        )
        Port map ( 
            SRST       => srst_del,
            CE         => CE,
            CLK        => CLK,
            TRG        => trg_del,
            OVERFL     => over_del
        );

end Behavioral;
