library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity sh_cycle_cnt_tb is

end sh_cycle_cnt_tb;

architecture Behavioral of sh_cycle_cnt_tb is

    
    constant C_N_CYCLE  : positive := 6;
    constant CLK_PERIOD : time := 10 ns;

    
    signal clk   : std_logic := '0';
    signal ce    : std_logic := '0';
    signal srst  : std_logic := '0';
    signal carry : std_logic;
    signal cnt   : std_logic_vector((integer(ceil(log2(real(C_N_CYCLE)))) - 1) downto 0);
    
    COMPONENT sh_cycle_cnt
       GENERIC (
           N_CYCLE             : POSITIVE := 2
           );
       PORT (
           CLK                 : IN  STD_LOGIC;
           SRST                : IN  STD_LOGIC;
           CE                  : IN  STD_LOGIC;
           CNT                 : out STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) downto 0);
           CARRY               : out STD_LOGIC
           );
  END COMPONENT;

begin

    
    uut: sh_cycle_cnt
        generic map (
            N_CYCLE => C_N_CYCLE
        )
        port map (
            CLK   => clk,
            CE    => ce,
            SRST  => srst,
            CARRY => carry,
            CNT   => cnt
        );

   
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

   
    stim_proc: process
    begin
        
        srst <= '1';
        ce   <= '0';
        wait for CLK_PERIOD * 2;
        
        
        srst <= '0';
        ce   <= '1';
        
       
        wait for CLK_PERIOD * 25;
        
      
        ce <= '0';
        wait for CLK_PERIOD * 5; 
        
      
        ce <= '1';
        wait for CLK_PERIOD * 15;
        
      
        srst <= '1';
        wait for CLK_PERIOD * 2;
        srst <= '0';
        
     
        wait for CLK_PERIOD * 10;
        
     
        wait;
    end process;

end Behavioral;