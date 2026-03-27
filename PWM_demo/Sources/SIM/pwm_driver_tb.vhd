----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.PKG_CONSTANTS.ALL;
use WORK.PKG_TYPES.ALL;
----------------------------------------------------------------------------------
ENTITY pwm_driver_tb IS
END pwm_driver_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver_tb IS
----------------------------------------------------------------------------------

    COMPONENT pwm_driver
        Generic (
            G_RES : INTEGER := 8;
            G_NCH : INTEGER := 8
        );
        Port ( 
            CLK       : in  STD_LOGIC;
            PWM_REF   : in  type_pwm_ref;
            SRST      : in STD_LOGIC;
            CE        : in STD_LOGIC;
            PWM_OUT   : out STD_LOGIC_VECTOR ((G_NCH - 1) DOWNTO 0);
            CNT_OUT   : out STD_LOGIC_VECTOR ((G_RES - 1) DOWNTO 0)
        );
    END COMPONENT;
    
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
    END COMPONENT ce_gen;

  --------------------------------------------------------------------------------

  CONSTANT G_RES        : INTEGER := 8;
  CONSTANT G_NCH        : INTEGER := 8;
  SIGNAL clk            : STD_LOGIC := '0';
  SIGNAL srst           : STD_LOGIC := '0';
  SIGNAL ce             : STD_LOGIC;

  SIGNAL pwm_ref        : type_pwm_ref;
  SIGNAL pwm_ref_7      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_6      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_5      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_4      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_3      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_2      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_1      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_ref_0      : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0) := (OTHERS => '0');

  SIGNAL pwm_out        : STD_LOGIC_VECTOR ((G_NCH-1) DOWNTO 0);
  SIGNAL cnt_out        : STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0);

  --------------------------------------------------------------------------------

  CONSTANT C_CLK_PERIOD      : TIME := 20 ns;
  SIGNAL  F_sim_finished     : BOOLEAN := FALSE;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

    pwm_driver_i : pwm_driver
        GENERIC MAP (
            G_RES               => G_RES,
            G_NCH               => G_NCH
        )
        PORT MAP    (
            CLK                 => clk,
            SRST                => srst,
            CE                  => ce,
            PWM_REF             => pwm_ref,
            PWM_OUT             => pwm_out,
            CNT_OUT             => cnt_out
  );
  
    ce_gen_i : ce_gen
        GENERIC MAP(
            G_DIV_FACT                  => 3
        )
        PORT MAP(
            CLK                         => CLK,
            SRST                        => SRST,
            CE                          => '1',
            CE_O                        => ce
        );
  --------------------------------------------------------------------------------

    pwm_ref(0) <= pwm_ref_0;
    pwm_ref(1) <= pwm_ref_1;
    pwm_ref(2) <= pwm_ref_2;
    pwm_ref(3) <= pwm_ref_3;
    pwm_ref(4) <= pwm_ref_4;
    pwm_ref(5) <= pwm_ref_5;
    pwm_ref(6) <= pwm_ref_6;
    pwm_ref(7) <= pwm_ref_7;
    

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR C_CLK_PERIOD/2;
    clk <= '1';
    WAIT FOR C_CLK_PERIOD/2;
    IF F_sim_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    ------------------------------------------------------------------------------
    -- initialize PWM references
    pwm_ref_0 <= "00000000";
    pwm_ref_1 <= "00000001";
    pwm_ref_2 <= "00000011";
    pwm_ref_3 <= "00000111";
    pwm_ref_4 <= "00011111";
    pwm_ref_5 <= "00111111";
    pwm_ref_6 <= "01111111";
    pwm_ref_7 <= "11111111";

    WAIT FOR C_CLK_PERIOD*2000;

    ------------------------------------------------------------------------------

    F_sim_finished <= TRUE;

    ------------------------------------------------------------------------------
    -- final report
    REPORT LF &
             "================================================================" & LF &
             "Simulation finished! Check the waveform window!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;

    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE;
----------------------------------------------------------------------------------