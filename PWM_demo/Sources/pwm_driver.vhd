----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Antonin Putala
-- 
-- Create Date: 03/27/2026 09:19:45 AM
-- Design Name: 
-- Module Name: pwm_driver - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_driver is
    Generic (
        CNT_WIDTH : INTEGER := 4
    );
    Port ( 
        CLK       : in  STD_LOGIC;
        PWM_REF_7 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_6 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_5 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_4 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_3 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_2 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_1 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_REF_0 : in  STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0);
        PWM_OUT   : out STD_LOGIC_VECTOR (7 DOWNTO 0);
        CNT_OUT   : out STD_LOGIC_VECTOR ((CNT_WIDTH - 1) DOWNTO 0)
    );
end pwm_driver;

architecture Behavioral of pwm_driver is

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
    
    SIGNAL sig_cnt : STD_LOGIC_VECTOR ((CNT_WIDTH - 1) downto 0);

begin

    nbit_bin_counter_i: nbit_bin_counter
        generic map (
            CNT_WIDTH => CNT_WIDTH
        )
        port map (
            CLK  => CLK,
            SRST => '0',
            CE   => '1',
            CNT  => sig_cnt
        );    
        
    PWM_OUT(0) <= '1' WHEN (PWM_REF_0 >= sig_cnt) ELSE '0';
    PWM_OUT(1) <= '1' WHEN (PWM_REF_1 >= sig_cnt) ELSE '0';  
    PWM_OUT(2) <= '1' WHEN (PWM_REF_2 >= sig_cnt) ELSE '0';  
    PWM_OUT(3) <= '1' WHEN (PWM_REF_3 >= sig_cnt) ELSE '0';  
    PWM_OUT(4) <= '1' WHEN (PWM_REF_4 >= sig_cnt) ELSE '0';
    PWM_OUT(5) <= '1' WHEN (PWM_REF_5 >= sig_cnt) ELSE '0';  
    PWM_OUT(6) <= '1' WHEN (PWM_REF_6 >= sig_cnt) ELSE '0';  
    PWM_OUT(7) <= '1' WHEN (PWM_REF_7 >= sig_cnt) ELSE '0'; 
    
    CNT_OUT <= sig_cnt;

end Behavioral;
