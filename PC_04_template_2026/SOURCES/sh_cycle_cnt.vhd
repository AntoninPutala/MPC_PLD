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
        CLK   : in  STD_LOGIC;
        CE    : in  STD_LOGIC;
        SRST  : in  STD_LOGIC;
        CARRY : out STD_LOGIC;
        CNT   : out STD_LOGIC_VECTOR ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) downto 0)
        );
end sh_cycle_cnt;

architecture Behavioral of sh_cycle_cnt is
    
    signal CNT_DIV : UNSIGNED ((INTEGER(CEIL(LOG2(REAL(N_CYCLE)))) - 1) DOWNTO 0);
    
begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if (SRST = '1') then
                CNT_DIV <= (others => '0');
            elsif (CE = '1') then
                if (CNT_DIV >= (N_CYCLE - 1)) then
                    CNT_DIV <= (others => '0');              
                else
                    CNT_DIV <= CNT_DIV + 1;
                end if;
            end if;
        end if;
    end process;
    
    process (CNT_DIV)
    begin
        CARRY <= '0';
        
        if (CNT_DIV = (N_CYCLE - 1)) then
            CARRY   <= '1'; 
        end if;
    end process;
    
    CNT <= std_logic_vector(CNT_DIV);
    
end Behavioral;
