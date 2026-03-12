library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ce_gen_tb is

end ce_gen_tb;

architecture Behavioral of ce_gen_tb is

    constant C_DIV_FACT   : positive := 5; 
    constant C_CLK_PERIOD : time := 10 ns;

    signal clk  : std_logic := '0';
    signal srst : std_logic := '1';
    signal ce   : std_logic := '0';
    signal ce_o : std_logic;
    
    COMPONENT ce_gen
        Generic (
            DIV_FACT : POSITIVE := 2
            );
        Port ( 
            clk  : in  STD_LOGIC;
            srst : in  STD_LOGIC;
            ce   : in  STD_LOGIC;
            ce_o : out STD_LOGIC
            );
        END COMPONENT;

begin

   
    uut: ce_gen
        generic map (
            DIV_FACT => C_DIV_FACT
        )
        port map (
            clk  => clk,
            srst => srst,
            ce   => ce,
            ce_o => ce_o
        );

   
    clk_process : process
    begin
        clk <= '0';
        wait for C_CLK_PERIOD / 2;
        clk <= '1';
        wait for C_CLK_PERIOD / 2;
    end process;

   
    stim_proc: process
    begin

        srst <= '1';
        ce   <= '0';
        wait for 25 ns;
        

        srst <= '0';
        wait for 20 ns;
        

        ce <= '1';
        wait for 150 ns;
        

        ce <= '0';
        wait for 40 ns;
        

        ce <= '1';
        wait for 50 ns;
        srst <= '1';
        wait for 20 ns;
        srst <= '0';
        

        wait;
    end process;

end Behavioral;