----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2026 09:27:27 AM
-- Design Name: 
-- Module Name: cnt_bin - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
    Port ( 
        CNT      : out STD_LOGIC_VECTOR (31 downto 0);
        CLK      : in  STD_LOGIC;
        SRST     : in  STD_LOGIC;
        CE       : in  STD_LOGIC;
        CNT_LOAD : in  STD_LOGIC;
        CNT_UP   : in  STD_LOGIC);
end cnt_bin;

architecture Behavioral of cnt_bin is
    
    signal sig_CNT : UNSIGNED (31 downto 0);
    
begin

process (CLK)
begin
    if rising_edge(CLK) then
        if (SRST = '1') then
            sig_CNT <= (others => '0');
        elsif (CE = '1') then
            if (CNT_LOAD = '1') then
                sig_CNT <= x"55555555";
            else
                if (CNT_UP = '1') then
                    sig_CNT <= sig_CNT + 1;
                else
                    sig_CNT <= sig_CNT - 1;
                end if;
            end if;
        end if;
    end if;
end process;

CNT <= std_logic_vector(sig_CNT);

end Behavioral;
