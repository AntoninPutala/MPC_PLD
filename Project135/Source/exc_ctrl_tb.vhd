library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY ext_ctrl_tb IS
END ext_ctrl_tb;

ARCHITECTURE Behavioral OF ext_ctrl_tb IS

    COMPONENT ext_ctrl
        GENERIC ( 
            LENGTH    : INTEGER
        );
        PORT ( 
            EXC_START : in STD_LOGIC;
            CLK       : in STD_LOGIC;
            EXC_OUT   : out STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL exc_start_tb : STD_LOGIC := '0';
    SIGNAL clk_tb       : STD_LOGIC := '0';
    SIGNAL exc_out_tb   : STD_LOGIC_VECTOR (7 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 20 ns;

BEGIN

    uut: ext_ctrl 
    generic map (
        LENGTH    => 5
    )
    port map (
        EXC_START => exc_start_tb,
        CLK       => clk_tb,
        EXC_OUT   => exc_out_tb
    );

    clk_process : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR CLK_PERIOD/2;
        clk_tb <= '1';
        WAIT FOR CLK_PERIOD/2;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN		
        WAIT FOR 100 ns;
        
        exc_start_tb <= '1';
        WAIT FOR CLK_PERIOD * 2; 
        exc_start_tb <= '0';
        
        WAIT FOR 200 ns;
        
        -- Too early
        exc_start_tb <= '1';
        WAIT FOR CLK_PERIOD * 3; 
        exc_start_tb <= '0';
        
        WAIT FOR 800 ns;
       
        exc_start_tb <= '1';
        WAIT FOR CLK_PERIOD * 2;
        exc_start_tb <= '0';

        WAIT FOR 1000 ns;

        WAIT;
     END PROCESS;

END Behavioral;