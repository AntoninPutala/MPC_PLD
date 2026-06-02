----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02.06.2026 11:17:06
-- Design Name:
-- Module Name: LFSR - Behavioral
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

ENTITY LFSR_tb IS
END LFSR_tb;

ARCHITECTURE sim OF LFSR_tb IS

    CONSTANT LENGTH : INTEGER := 20;
    CONSTANT TAP_1  : INTEGER := 20;
    CONSTANT TAP_2  : INTEGER := 17;

    CONSTANT INIT_STATE : STD_LOGIC_VECTOR((LENGTH-1) DOWNTO 0) := (OTHERS => '1');

    SIGNAL clk    : STD_LOGIC := '0';
    SIGNAL srst   : STD_LOGIC := '0';
    SIGNAL ce     : STD_LOGIC := '1';
    SIGNAL bit_o  : STD_LOGIC;
    SIGNAL word_o : STD_LOGIC_VECTOR((LENGTH-1) DOWNTO 0);
    SIGNAL done   : BOOLEAN   := FALSE;

BEGIN

    uut: ENTITY work.LFSR
        GENERIC MAP (
            LENGTH => LENGTH,
            TAP_1  => TAP_1,
            TAP_2  => TAP_2
        )
        PORT MAP (
            CLK    => clk,
            SRST   => srst,
            CE     => ce,
            BIT_O  => bit_o,
            WORD_O => word_o
        );

    clk_process : PROCESS
    BEGIN
        WHILE NOT(done) LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT;
    END PROCESS;
    
    stim_process : PROCESS
        VARIABLE state_count : INTEGER := 0;
    BEGIN
        WAIT FOR 1 ns;
        LOOP
            WAIT UNTIL rising_edge(clk);
            WAIT FOR 1 ns;
            state_count := state_count + 1;
            IF word_o = INIT_STATE THEN
                done <= TRUE;
                
                REPORT
                    "Total state: " & integer'image(state_count)
                SEVERITY NOTE;
                WAIT;
            END IF;
        END LOOP;
    END PROCESS;

END sim;