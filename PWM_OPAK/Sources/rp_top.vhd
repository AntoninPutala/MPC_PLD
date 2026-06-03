----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PKG_CONSTANTS.ALL;
USE WORK.PKG_TYPES.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
    PORT(
        CLK             : IN  STD_LOGIC;
        BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

    COMPONENT seg_disp_driver
        PORT(
            CLK             : IN  STD_LOGIC;
            DIG_1           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            DIG_2           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            DIG_3           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            DIG_4           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
            DP              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
            DOTS            : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
            DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
        );
    END COMPONENT seg_disp_driver;
    
    COMPONENT bcd_counter
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
    END COMPONENT bcd_counter;

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
    
    COMPONENT btn_in
        GENERIC (
            G_DEB_PERIOD        : POSITIVE
        );
        PORT (
            CLK                 : IN    STD_LOGIC;
            CE                  : IN    STD_LOGIC;
            BTN                 : IN    STD_LOGIC;
            BTN_DEBOUNCED       : OUT   STD_LOGIC;
            BTN_EDGE_POS        : OUT   STD_LOGIC;
            BTN_EDGE_NEG        : OUT   STD_LOGIC;
            BTN_EDGE_ANY        : OUT   STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT stopwatch_fsm
        PORT (
            CLK                 : IN    STD_LOGIC;
            BTN_S_S             : IN    STD_LOGIC;
            BTN_L_C             : IN    STD_LOGIC;
            CNT_RESET           : OUT   STD_LOGIC;
            CNT_ENABLE          : OUT   STD_LOGIC;
            DISP_ENABLE         : OUT   STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT pwm_driver
        PORT (
            CLK                 : IN  STD_LOGIC;
            PWM_REF             : IN  type_pwm_ref;
            PWM_OUT             : OUT STD_LOGIC_VECTOR ((G_NCH-1) DOWNTO 0);
            CNT_OUT             : OUT STD_LOGIC_VECTOR ((G_RES-1) DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT pwm_fsm
       	PORT (
		    CLK     : IN  STD_LOGIC;
		    CE      : IN  STD_LOGIC;
		    DIR     : IN  STD_LOGIC;
		    PWM_REF : OUT type_pwm_ref
	    ); 
    END COMPONENT;

  ------------------------------------------------------------------------------

    SIGNAL cnt_0              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    SIGNAL cnt_1              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    SIGNAL cnt_2              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    SIGNAL cnt_3              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
    
    SIGNAL cnt_reset          : STD_LOGIC;
    SIGNAL cnt_enable         : STD_LOGIC;
    SIGNAL disp_enable        : STD_LOGIC;
    
    SIGNAL ce_5Hz             : STD_LOGIC;
    SIGNAL ce_100Hz           : STD_LOGIC;
    SIGNAL ce_1000Hz          : STD_LOGIC; 
    
    SIGNAL btn_s_s            : STD_LOGIC;
    SIGNAL btn_l_c            : STD_LOGIC;
    
    SIGNAL pwm_ref            : type_pwm_ref;
    SIGNAL pwm_out            : STD_LOGIC_VECTOR ((G_NCH-1) DOWNTO 0);   
    SIGNAL pwm_ce             : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

    seg_disp_driver_i : seg_disp_driver
        PORT MAP(
            CLK                 => CLK,
            DIG_1               => cnt_3,
            DIG_2               => cnt_2,
            DIG_3               => cnt_1,
            DIG_4               => cnt_0,
            DP                  => "0000",
            DOTS                => "011",
            DISP_SEG            => DISP_SEG,
            DISP_DIG            => DISP_DIG
        );

  --------------------------------------------------------------------------------
  -- clock enable generator
    ce_gen_i_1 : ce_gen
        generic map (
            G_DIV_FACT          => 500000
        )                       
        port map (
            CLK                 => CLK,
            SRST                => '0',
            CE                  => '1',
            CE_O                => ce_100Hz
        );  

    ce_gen_i_2 : ce_gen
        generic map (
            G_DIV_FACT          => 50000
        )                       
        port map (
            CLK                 => CLK,
            SRST                => '0',
            CE                  => '1',
            CE_O                => ce_1000Hz
        );
        
    ce_gen_i_3 : ce_gen
        generic map (
            G_DIV_FACT          => 10000000
        )                       
        port map (
            CLK                 => CLK,
            SRST                => '0',
            CE                  => '1',
            CE_O                => ce_5Hz
        );  
      

  --------------------------------------------------------------------------------
  -- button input module
    btn_in_i_1 : btn_in
        generic map (
            G_DEB_PERIOD        => 40
        )
        port map (
            CLK                 => CLK,
            CE                  => ce_1000Hz,
            BTN                 => BTN(0),
            BTN_DEBOUNCED       => open,
            BTN_EDGE_POS        => btn_s_s,
            BTN_EDGE_NEG        => open,
            BTN_EDGE_ANY        => open
        );

    btn_in_i_2 : btn_in
        generic map (
            G_DEB_PERIOD        => 40
        )
        port map (
            CLK                 => CLK,
            CE                  => ce_1000Hz,
            BTN                 => BTN(3),
            BTN_DEBOUNCED       => open,
            BTN_EDGE_POS        => btn_l_c,
            BTN_EDGE_NEG        => open,
            BTN_EDGE_ANY        => open
        );

  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
    bcd_counter_i : bcd_counter
        PORT MAP (
            CLK         => CLK,
            CE_100HZ    => ce_100Hz,
            CNT_RESET   => cnt_reset,
            CNT_ENABLE  => cnt_enable,
            DISP_ENABLE => disp_enable,
            CNT_0       => cnt_0,
            CNT_1       => cnt_1,
            CNT_2       => cnt_2,
            CNT_3       => cnt_3
        );

  --------------------------------------------------------------------------------
  -- stopwatch control FSM
    stopwatch_fsm_i : stopwatch_fsm
        port map (
            CLK                 => CLK,
            BTN_S_S             => btn_s_s,
            BTN_L_C             => btn_l_c,
            CNT_RESET           => cnt_reset,
            CNT_ENABLE          => cnt_enable,
            DISP_ENABLE         => disp_enable
        );


  --------------------------------------------------------------------------------
  -- LED connection
    pwm_fsm_I : pwm_fsm
        port map (
            CLK     => CLK,
            CE      => pwm_ce,
            DIR     => SW(0),
            PWM_REF => pwm_ref
        );
  
    pwm_driver_i : pwm_driver
        port map (
            CLK                 => CLK,
            PWM_REF             => pwm_ref,
            PWM_OUT             => pwm_out,
            CNT_OUT             => open
        );
    
    LED    <= pwm_out;

    pwm_ce <= ce_5Hz AND SW(1);

----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
