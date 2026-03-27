----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: one_shot_gen_tb - sim
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Testbench for the one_shot_gen module.
-- 
-- Dependencies: one_shot_gen, pulse_gen
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_shot_gen_tb is
-- Testbench entity has no ports
end one_shot_gen_tb;

architecture sim of one_shot_gen_tb is

    -- Component Declaration for the Device Under Test (DUT)
    component one_shot_gen
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
    end component;
    
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

    -- Testbench signals initialization
    signal SRST       : STD_LOGIC := '1';
    signal CLK        : STD_LOGIC := '0';
    signal START_I    : STD_LOGIC := '0';
    
    -- Output signals
    signal IMPULSE_O  : STD_LOGIC;
    signal READY_O    : STD_LOGIC;
    signal FINISHED_O : STD_LOGIC;

    -- Clock period definitions
    constant CLK_PERIOD : time := 10 ns;
    
    SIGNAL clock_en : STD_LOGIC := '0';

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: one_shot_gen 
    generic map (
        IMPULSE_LEN => 4,
        EARLY_START => '0',
        STOP_DELAY  => 2
    )
    port map (
        SRST       => SRST,
        CLK        => CLK,
        CE         => clock_en,
        START_I    => START_I,
        IMPULSE_O  => IMPULSE_O,
        READY_O    => READY_O,
        FINISHED_O => FINISHED_O
    );
    
    ce_gen_i : ce_gen
       Generic map (
           G_DIV_FACT => 3
       )
       Port map (
           CLK        => CLK,
           SRST       => '0',
           CE         => '1',
           CE_O       => clock_en
       );

    -- Clock generation process
    clk_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- 1. Hold reset state for an initial period
        SRST <= '1';
        START_I <= '0';
        wait for 20 ns;	
        
        -- 2. Release reset and wait a couple of clock cycles
        SRST <= '0';
        wait for CLK_PERIOD * 2;

        -- 3. Enable the component
        wait for CLK_PERIOD * 2;

        -- 4. Apply the START trigger (high for one clock cycle)
        START_I <= '1';
        wait for CLK_PERIOD;
        START_I <= '0';
        
        wait for 6 * CLK_PERIOD;
        
        START_I <= '1';
        wait for CLK_PERIOD;
        START_I <= '0';

        -- 5. Wait for the generation to complete 
        -- It waits until the FINISHED_O flag goes high
        wait until FINISHED_O = '1';
        
        -- Wait a few extra cycles to observe the post-finish behavior
        wait for CLK_PERIOD * 5;

        -- 6. Trigger again to verify RESTART/BLOCK behavior (optional)
        START_I <= '1';
        wait for CLK_PERIOD;
        START_I <= '0';
        
        wait until FINISHED_O = '1';
        wait for CLK_PERIOD * 5;

        -- End the simulation
        assert false report "End of simulation reached." severity failure;
        wait;
    end process;

end sim;