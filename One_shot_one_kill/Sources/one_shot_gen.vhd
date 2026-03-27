----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2026 14:07:58
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

-- EARLY_REACT = '0' - ignore
--             = '1' - new start
entity one_shot_gen is
    Generic (
        IMPULSE_LEN : POSITIVE  := 4;
        EARLY_REACT : STD_LOGIC := '0';
        GUARD_LEN   : POSITIVE  := 4
        );
    Port ( 
        CLK        : in  STD_LOGIC;
        SRST       : in  STD_LOGIC;
        CE         : in  STD_LOGIC;
        START_I    : in  STD_LOGIC;
        IMPULSE_O  : out STD_LOGIC;
        READY_O    : out STD_LOGIC;
        FINISHED_O : out STD_LOGIC
        );
end one_shot_gen;

architecture Behavioral of one_shot_gen is
    
    SIGNAL cnt_trig         : STD_LOGIC := '0';
    SIGNAL cnt_trig_gr      : STD_LOGIC := '0';
    SIGNAL cnt_rst          : STD_LOGIC;
    SIGNAL cnt_rst_gr       : STD_LOGIC;
    SIGNAL finished         : STD_LOGIC := '0';
    SIGNAL cnt_carry        : STD_LOGIC := '0';
    SIGNAL cnt_carry_gr     : STD_LOGIC := '0';
    SIGNAL pulse_bl         : STD_LOGIC := '0';
    SIGNAL impulse          : STD_LOGIC := '0';
    SIGNAL next_impulse     : STD_LOGIC;
    SIGNAL next_cnt_trig    : STD_LOGIC;
    SIGNAL next_cnt_trig_gr : STD_LOGIC;
    SIGNAL next_finished    : STD_LOGIC; 
    SIGNAL next_pulse_bl   : STD_LOGIC;
    
    COMPONENT ce_gen
        GENERIC (
            G_DIV_FACT          : POSITIVE := 2
        );
        PORT (
            CLK                 : IN  STD_LOGIC;
            SRST                : IN  STD_LOGIC;
            CE                  : IN  STD_LOGIC;
            CE_O                : OUT STD_LOGIC 
        );
    END COMPONENT;
    
begin

    ce_gen_1 : ce_gen
       Generic map (
           G_DIV_FACT => IMPULSE_LEN
       )
       Port map (
           CLK        => CLK,
           SRST       => cnt_rst,
           CE         => cnt_trig,
           CE_O       => cnt_carry
       );
       
    ce_gen_2 : ce_gen
       Generic map (
           G_DIV_FACT => GUARD_LEN
       )
       Port map (
           CLK        => CLK,
           SRST       => cnt_rst_gr,
           CE         => cnt_trig_gr,
           CE_O       => cnt_carry_gr
       );
       
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            impulse     <= next_impulse;   
            cnt_trig    <= next_cnt_trig;
            finished    <= next_finished;
            pulse_bl    <= next_pulse_bl;
            cnt_trig_gr <= next_cnt_trig_gr;
        END IF;
    END PROCESS;
    
    PROCESS (SRST, cnt_carry, CE, START_I, impulse)
    BEGIN
        next_impulse  <= impulse;
        
        IF (SRST = '1') THEN
            next_impulse <= '0';
        ELSIF (CE = '1') THEN
            IF ((START_I = '1') and (impulse = '0')) THEN
                next_impulse <= '1';    
            ELSIF ((cnt_carry = '1') and (impulse = '1')) THEN
                next_impulse <= '0';
            END IF;
        END IF;
    END PROCESS;
    
    PROCESS (SRST, CE, impulse)
    BEGIN
        next_cnt_trig <= '0';
        
        IF (SRST = '1') THEN
            next_cnt_trig <= '0';
        ELSIF (CE = '1') THEN
            next_cnt_trig <= impulse;
        END IF;
    END PROCESS;
    
    PROCESS (SRST, CE, pulse_bl)
    BEGIN
        next_cnt_trig_gr <= '0';
        
        IF (SRST = '1') THEN
            next_cnt_trig <= '0';
        ELSIF (CE = '1') THEN
            next_cnt_trig <= pulse_bl;
        END IF;
    END PROCESS;
    
    PROCESS (SRST, CE, impulse, next_impulse, pulse_bl)
    BEGIN
        next_finished <= finished;
        next_pulse_bl <= pulse_bl;
        
        IF (SRST = '1') THEN
            next_finished <= '0';
            next_pulse_bl <= '0';
        ELSIF (CE = '1') THEN
            IF ((impulse = '1') and (next_impulse) = '0') THEN
                next_finished <= '1';  
                next_pulse_bl <= '1';  
            ELSIF (pulse_bl = '1') THEN
                IF (cnt_carry_gr = '1') THEN
                    next_pulse_bl <= '0';
                END IF;
                
                next_finished <= '0'; 
            ELSE
                next_finished <= '0';  
            END IF;
        END IF;
    END PROCESS;
    
    -- New start logic
    PROCESS (SRST, CE, START_I, impulse)
    BEGIN
        cnt_rst <= '0';
        
        IF (SRST = '1') THEN 
            cnt_rst <= '1';
        ELSIF (impulse = '0') THEN
            cnt_rst <= '1';
        ELSIF (EARLY_REACT = '1') THEN
            IF ((impulse = '1') and (START_I = '1')) THEN 
                cnt_rst <= '1';
            END IF;
        END IF;
    END PROCESS;
    
    PROCESS (SRST, impulse)
    BEGIN
        cnt_rst_gr <= '0';
        
        IF (SRST = '1') THEN 
            cnt_rst_gr <= '1';
        ELSIF (EARLY_REACT = '1') THEN
            cnt_rst_gr <= '1';
        ELSIF (impulse = '1') THEN
            cnt_rst_gr <= '1';
        END IF;
    END PROCESS;
    
    READY_O    <= NOT (impulse OR finished OR pulse_bl);
    
    IMPULSE_O  <= impulse;
    FINISHED_O <= finished;
      
end Behavioral;
