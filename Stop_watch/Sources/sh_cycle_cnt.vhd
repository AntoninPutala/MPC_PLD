----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2026 08:57:46 AM
-- Design Name: 
-- Module Name: sh_cycle_cnt - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sh_cycle_cnt is
    Generic (
        N_CYCLE : POSITIVE := 10
        );
    Port ( 
        clk   : in  STD_LOGIC;
        ce    : in  STD_LOGIC;
        srst  : in  STD_LOGIC;
        carry : out STD_LOGIC;
        cnt   : out STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) downto 0));
end sh_cycle_cnt;

architecture Behavioral of sh_cycle_cnt is
    
    signal cnt_div : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(DIV_FACT)))) - 1) DOWNTO 0);
    
begin




end Behavioral;
