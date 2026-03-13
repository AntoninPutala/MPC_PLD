----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2026 08:50:22 AM
-- Design Name: 
-- Module Name: bcd_counter - Behavioral
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

entity bcd_counter is
    Port ( 
        cnt_enable  : in  STD_LOGIC;
        disp_enable : in  STD_LOGIC;
        cnt_reset   : in  STD_LOGIC;
        clk         : in  STD_LOGIC;
        ce_100hz    : in  STD_LOGIC;
        cnt_0       : out STD_LOGIC_VECTOR (3 downto 0);
        cnt_1       : out STD_LOGIC_VECTOR (3 downto 0);
        cnt_2       : out STD_LOGIC_VECTOR (3 downto 0);
        cnt_3       : out STD_LOGIC_VECTOR (3 downto 0)
        );
end bcd_counter;

architecture Behavioral of bcd_counter is

begin


end Behavioral;
