----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2026 22:31:51
-- Design Name: 
-- Module Name: pulse_gen - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_gen is
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
end pulse_gen;

architecture Behavioral of pulse_gen is

    SIGNAL cnt_run      : STD_LOGIC := '0';
    SIGNAL next_cnt_run : STD_LOGIC;
    SIGNAL sig_overfl   : STD_LOGIC;
    SIGNAL next_overfl  : STD_LOGIC;
    
    SIGNAL cnt_div      : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(G_DIV_FACT)))) - 1) DOWNTO 0) := (others => '0');
    SIGNAL next_cnt_div : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(G_DIV_FACT)))) - 1) DOWNTO 0);
begin

    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            cnt_run     <= next_cnt_run;
            cnt_div     <= next_cnt_div;
            sig_overfl  <= next_overfl;
        END IF;     
    END PROCESS;
    
    -- Trigger
    PROCESS (cnt_run, sig_overfl, TRG)
    BEGIN
        next_cnt_run <= cnt_run;
        
        IF (TRG = '1') THEN
            next_cnt_run <= '1';
        ELSIF (sig_overfl = '1') THEN
            next_cnt_run <= '0';   
        END IF;
    END PROCESS;
    
    -- Counter
    PROCESS (cnt_div, cnt_run, CE, SRST)
    BEGIN
        next_cnt_div <= cnt_div;
        next_overfl <= '0';
        
        IF (SRST = '1') THEN
            next_cnt_div <= (OTHERS => '0');
        ELSIF (CE = '1') THEN
            IF (cnt_run = '1') THEN
                IF (cnt_div = (G_DIV_FACT - 1)) then
                    next_cnt_div <= (OTHERS => '0');  
                    next_overfl  <= '1';
                ELSE
                    next_cnt_div <= cnt_div + 1; 
                END IF;  
            ELSE
                next_cnt_div <= (OTHERS => '0');
            END IF; 
        END IF;
    END PROCESS;
    
    OVERFL <= sig_overfl;

end Behavioral;
