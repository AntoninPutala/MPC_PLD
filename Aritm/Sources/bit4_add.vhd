----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2026 21:03:23
-- Design Name: 
-- Module Name: 4bit_add - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bit4_add is
    Port ( 
        A      : in  STD_LOGIC_VECTOR (3 downto 0);
        B      : in  STD_LOGIC_VECTOR (3 downto 0);
        RESULT : out STD_LOGIC_VECTOR (3 downto 0)
        );
end bit4_add;

architecture Behavioral of bit4_add is

    signal sig_A      : UNSIGNED (3 downto 0);
    signal sig_B      : UNSIGNED (3 downto 0);
    signal sig_RESULT : UNSIGNED (3 downto 0);
    
begin

    sig_A  <= unsigned(A);
    sig_B  <= unsigned(B);
    sig_RESULT <= sig_A + sig_B;
    
    RESULT <= std_logic_vector(sig_RESULT);
    
end Behavioral;
