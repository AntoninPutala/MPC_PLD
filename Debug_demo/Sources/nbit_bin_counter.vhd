
-- Company: Brno University of Technology
-- Engineer: Antonin Putala
-- 
-- Create Date: 03/27/2026 09:22:44 AM
-- Design Name: 
-- Module Name: nbit_bin_counter - Behavioral
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
--

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nbit_bin_counter is
    Generic (
        CNT_WIDTH : INTEGER := 4
    );
    Port ( 
        CLK  : in STD_LOGIC;
        SRST : in STD_LOGIC;
        CE   : in STD_LOGIC;
        CNT  : out STD_LOGIC_VECTOR ((CNT_WIDTH - 1) downto 0)
    );
end nbit_bin_counter;

architecture Behavioral of nbit_bin_counter is

    SIGNAL sig_count : UNSIGNED ((CNT_WIDTH - 1) downto 0) := (OTHERS => '0');

begin

    PROCESS (CLK) 
    BEGIN
        IF rising_edge(CLK) THEN
            IF (SRST = '1') THEN
                sig_count <= (OTHERS => '0');    
            ELSIF (CE = '1') THEN
                IF (sig_count = (2 ** CNT_WIDTH) - 2) THEN
                    sig_count <= (OTHERS => '0');                 
                ELSE
                    sig_count <= sig_count + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    CNT <= std_logic_vector(sig_count);

end Behavioral;
