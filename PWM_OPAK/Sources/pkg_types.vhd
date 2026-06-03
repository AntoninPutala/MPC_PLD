----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/03/2026 02:26:31 PM
-- Design Name:
-- Module Name: pkg_types - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PKG_CONSTANTS.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

PACKAGE pkg_types IS
    TYPE type_pwm_ref IS ARRAY(G_NCH-1 DOWNTO 0) OF
                        STD_LOGIC_VECTOR(G_RES-1 DOWNTO 0);
END;