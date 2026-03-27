library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nbit_bin_counter_tb is
end nbit_bin_counter_tb;

architecture Behavioral of nbit_bin_counter_tb is

    constant C_CNT_WIDTH  : integer := 4;
    constant C_CLK_PERIOD : time := 10 ns;

    signal clk_tb  : std_logic := '0';
    signal srst_tb : std_logic := '0';
    signal ce_tb   : std_logic := '0';
    signal cnt_tb  : std_logic_vector((C_CNT_WIDTH - 1) downto 0);
    
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


begin

    uut: nbit_bin_counter
        generic map (
            CNT_WIDTH => C_CNT_WIDTH
        )
        port map (
            CLK  => clk_tb,
            SRST => srst_tb,
            CE   => ce_tb,
            CNT  => cnt_tb
        );

    p_clk_gen : process
    begin
        clk_tb <= '0';
        wait for C_CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for C_CLK_PERIOD / 2;
    end process;

    p_stimulus : process
    begin
        srst_tb <= '1';
        ce_tb   <= '0';
        wait for 2 * C_CLK_PERIOD;

        srst_tb <= '0';
        ce_tb   <= '1';
        wait for 10 * C_CLK_PERIOD;

        ce_tb   <= '0';
        wait for 3 * C_CLK_PERIOD;

        ce_tb   <= '1';
        wait for 8 * C_CLK_PERIOD;  

        srst_tb <= '1';
        wait for 2 * C_CLK_PERIOD;
        srst_tb <= '0';
        
        wait; 
    end process;

end Behavioral;