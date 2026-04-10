
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

----------------------------------------------------------------------------------
ENTITY bcd_counter IS
  PORT(
    CLK                 : IN    STD_LOGIC;      -- clock signal
    CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
    CNT_RESET           : IN    STD_LOGIC;      -- counter reset
    CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
    DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
    CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY bcd_counter;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bcd_counter IS
----------------------------------------------------------------------------------
    
    -- Clock enable signals
    signal SIG_CE_HUNTH    : STD_LOGIC;
    signal SIG_CE_TENTH    : STD_LOGIC;
    signal SIG_CE_UNITS    : STD_LOGIC;
    signal SIG_CE_TENS     : STD_LOGIC;
    
    -- Carry signals
    signal SIG_CARRY_HUNTH : STD_LOGIC;
    signal SIG_CARRY_TENTH : STD_LOGIC;
    signal SIG_CARRY_UNITS : STD_LOGIC;
    
    -- Counters signal
    signal SIG_CNT_0       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal SIG_CNT_1       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal SIG_CNT_2       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal SIG_CNT_3       : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    
    
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

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  -- BCD counter
    cnt_hunth: sh_cycle_cnt
        generic map (
            N_CYCLE => 10
        )
        port map (
            CLK   => CLK,
            CE    => SIG_CE_HUNTH,
            SRST  => CNT_RESET,
            CARRY => SIG_CARRY_HUNTH,
            CNT   => SIG_CNT_0
        );
        
    cnt_tenth: sh_cycle_cnt
        generic map (
            N_CYCLE => 10
        )
        port map (
            CLK   => CLK,
            CE    => SIG_CE_TENTH,
            SRST  => CNT_RESET,
            CARRY => SIG_CARRY_TENTH,
            CNT   => SIG_CNT_1
        );
        
    cnt_units: sh_cycle_cnt
        generic map (
            N_CYCLE => 10
        )
        port map (
            CLK   => CLK,
            CE    => SIG_CE_UNITS,
            SRST  => CNT_RESET,
            CARRY => SIG_CARRY_UNITS,
            CNT   => SIG_CNT_2
        );
        
    cnt_tens: sh_cycle_cnt
        generic map (
            N_CYCLE => 6
        )
        port map (
            CLK   => CLK,
            CE    => SIG_CE_TENS,
            SRST  => CNT_RESET,
            CARRY => open,         -- connect to nothing
            CNT   => SIG_CNT_3(2 DOWNTO 0)
        );
        
    -- Clock enables signals
    SIG_CE_HUNTH <=  CNT_ENABLE   and CE_100HZ;   
    SIG_CE_TENTH <=  SIG_CE_HUNTH and SIG_CARRY_HUNTH;
    SIG_CE_UNITS <=  SIG_CE_TENTH and SIG_CARRY_TENTH;
    SIG_CE_TENS  <=  SIG_CE_UNITS and SIG_CARRY_UNITS;

  --------------------------------------------------------------------------------
  -- Output (display) register
    process (CLK)
    begin
        if rising_edge(CLK) then
            if (CNT_RESET = '1') then
                CNT_0 <= (others => '0');
                CNT_1 <= (others => '0');
                CNT_2 <= (others => '0');
                CNT_3 <= (others => '0');
            elsif (DISP_ENABLE = '1') then
                CNT_0 <= SIG_CNT_0;
                CNT_1 <= SIG_CNT_1;
                CNT_2 <= SIG_CNT_2;
                CNT_3 <= SIG_CNT_3;
            end if; 
        end if;
    end process;
     

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
