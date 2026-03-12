----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT (
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
      PORT (
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
  END COMPONENT;
  
  COMPONENT cnt_bin
      PORT ( 
          CNT      : out STD_LOGIC_VECTOR (31 downto 0);
          CLK      : in  STD_LOGIC;
          SRST     : in  STD_LOGIC;
          CE       : in  STD_LOGIC;
          CNT_LOAD : in  STD_LOGIC;
          CNT_UP   : in  STD_LOGIC
          );
  END COMPONENT;

  --------------------------------------------------------------------------------

 signal sig_CNT : STD_LOGIC_VECTOR (31 downto 0);


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
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
      PORT MAP (
          CLK                 => CLK,
          DIG_1               => sig_CNT(31 DOWNTO 28), -- pristup na segmenty
          DIG_2               => sig_CNT(27 DOWNTO 24), -- na hornich 16 bitu
          DIG_3               => sig_CNT(23 DOWNTO 20),
          DIG_4               => sig_CNT(19 DOWNTO 16), -- po sem dulezite
          DP                  => "0000",
          DOTS                => "000",
          DISP_SEG            => DISP_SEG,
          DISP_DIG            => DISP_DIG
      );
      
    cnt_bin_i : cnt_bin
        PORT MAP ( 
            CNT      => sig_CNT,
            CLK      => CLK,
            SRST     => BTN(2),
            CE       => SW(2),
            CNT_LOAD => BTN(1),
            CNT_UP   => SW(3)
        );
        
    LED <= sig_CNT(31 DOWNTO 24);

  --------------------------------------------------------------------------------



----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------
