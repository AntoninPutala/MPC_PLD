----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2026 01:54:57 PM
-- Design Name: 
-- Module Name: CODE_detect - Behavioral
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

entity CODE_detect is
    Port ( 
        SW  : in  STD_LOGIC_VECTOR (1 to 4);
        BTN : in  STD_LOGIC_VECTOR (1 to 4);
        LED : out STD_LOGIC_VECTOR (7 downto 0)
        );
end CODE_detect;

architecture Behavioral of CODE_detect is

begin
    
    LED <= "01010101" when SW = "1011" and BTN = "0001" else
           "10101010";

end Behavioral;
