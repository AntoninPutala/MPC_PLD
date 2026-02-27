----------------------------------------------------------------------------------
-- Company: Brno University of Tehcnology
-- Engineer: Bc. Antonin Putala
-- 
-- Create Date: 02/27/2026 09:18:43 AM
-- Design Name: 
-- Module Name: simple_adder - Behavioral
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

entity simple_adder is
    Generic (
        N_BIT : integer := 4
        );
    Port ( 
        A : in  STD_LOGIC_VECTOR (N_BIT-1 downto 0);
        B : in  STD_LOGIC_VECTOR (N_BIT-1 downto 0);
        Y : out STD_LOGIC_VECTOR (N_BIT-1 downto 0);
        C : out STD_LOGIC;
        Z : out STD_LOGIC
        );
end simple_adder;

architecture Behavioral of simple_adder is

    signal A_uns : UNSIGNED (A'range);
    signal B_uns : UNSIGNED (B'range);
    signal Y_uns : UNSIGNED (Y'range);
    signal X_uns : UNSIGNED (Y'high+1 downto Y'low);
    
begin
    -- Conversion
    A_uns <= unsigned(A);
    B_uns <= unsigned(B);
    
    -- Addition
    X_uns <= RESIZE(A_uns, N_BIT+1) + RESIZE(B_uns, N_BIT+1);
    Y_uns <= X_uns(N_BIT-1 downto 0);
    
    -- Assignment
    Y <= std_logic_vector(Y_uns);
    
    C <= std_logic(X_uns(N_BIT));
    Z <= '1' when (Y_uns = 0) else '0';
    
end Behavioral;
