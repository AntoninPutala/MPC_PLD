----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2026 08:34:52
-- Design Name: 
-- Module Name: ext_ctrl - Behavioral
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

ENTITY ext_ctrl IS
    GENERIC ( 
        LENGTH    : INTEGER := 50000 -- corresponds 1 ms
            );
    PORT ( 
        EXC_START : IN STD_LOGIC;
        CLK       : IN STD_LOGIC;
        EXC_OUT   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END ext_ctrl;

ARCHITECTURE Behavioral OF ext_ctrl IS

    TYPE t_state IS (st_idle, st_exc0, st_exc1, st_exc2, 
                     st_exc3, st_exc4, st_exc5, st_exc6, st_exc7, st_stop);
                     
    SIGNAL pres_st         : t_state := ST_IDLE;
    SIGNAL next_st         : t_state;
                     
    SIGNAL exc_start_del   : STD_LOGIC := '0';
    SIGNAL exc_start_egde  : STD_LOGIC;
    SIGNAL clk_en          : STD_LOGIC := '0';
    SIGNAL sig_exc_out     : STD_LOGIC_VECTOR (EXC_OUT'HIGH downto 0);
    SIGNAL sig_exc_out_reg : STD_LOGIC_VECTOR (EXC_OUT'HIGH downto 0) := (OTHERS => '0');
    
    SIGNAL cnt             : INTEGER := 0;

BEGIN

    -- Clock enable
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (pres_st = st_idle) THEN
                clk_en <= '0';
                cnt    <= 0;
            ELSE
                IF (cnt = (LENGTH - 2)) THEN
                    clk_en <= '1';
                    cnt    <= cnt + 1;
                ELSIF (cnt >= (LENGTH - 1)) THEN
                    clk_en <= '0';
                    cnt    <= 0;
                ELSE
                    clk_en <= '0';
                    cnt    <= cnt + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Edge detection
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            exc_start_del <= EXC_START;
        END IF;
    END PROCESS;
    
    exc_start_egde <= EXC_START AND NOT(exc_start_del);
    
    -- State register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) then
            pres_st <= next_st; 
        END IF;
    END PROCESS;
    
    -- Next state logic
    PROCESS (pres_st, exc_start_egde, clk_en)
    BEGIN
        next_st <= pres_st;
        
        IF ((pres_st = st_idle) AND (exc_start_egde = '1')) THEN
            next_st <= st_exc0;
        ELSE
            IF (clk_en = '1') THEN
                CASE (pres_st) IS
                    WHEN st_exc0 =>
                        next_st <= st_exc1;
                    WHEN st_exc1 =>
                        next_st <= st_exc2;                    
                    WHEN st_exc2 =>
                        next_st <= st_exc3;
                    WHEN st_exc3 =>
                        next_st <= st_exc4;
                    WHEN st_exc4 =>
                        next_st <= st_exc5;                    
                    WHEN st_exc5 =>
                        next_st <= st_exc6;
                    WHEN st_exc6 =>
                        next_st <= st_exc7;      
                    WHEN st_exc7 =>
                        next_st <= st_stop;     
                    WHEN st_stop =>
                        next_st <= st_idle;   
                    WHEN OTHERS  =>
                        next_st <= pres_st;                                                           
                END CASE;
            END IF;
        END IF;
    END PROCESS;
    
    -- Output logic 
    PROCESS (pres_st)
    BEGIN
        sig_exc_out <= (OTHERS => '0');
        
        CASE (pres_st) IS
            WHEN st_exc0 =>
                sig_exc_out(0) <= '1';
            WHEN st_exc1 =>
                sig_exc_out(0) <= '1';                    
                sig_exc_out(1) <= '1';                    
            WHEN st_exc2 =>
                sig_exc_out(1) <= '1';                    
                sig_exc_out(2) <= '1'; 
            WHEN st_exc3 =>
                sig_exc_out(2) <= '1';                    
                sig_exc_out(3) <= '1'; 
            WHEN st_exc4 =>
                sig_exc_out(3) <= '1';                    
                sig_exc_out(4) <= '1';                    
            WHEN st_exc5 =>
                sig_exc_out(4) <= '1';                    
                sig_exc_out(5) <= '1'; 
            WHEN st_exc6 =>
                sig_exc_out(5) <= '1';                    
                sig_exc_out(6) <= '1';      
            WHEN st_exc7 =>
                sig_exc_out(6) <= '1';                    
                sig_exc_out(7) <= '1';      
            WHEN st_stop =>
                sig_exc_out(7) <= '1';   
            WHEN OTHERS  =>       
                sig_exc_out <= (OTHERS => '0');                                                                    
        END CASE;
    END PROCESS; 

   -- Output register
    PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            sig_exc_out_reg <= sig_exc_out;
        END IF;
    END PROCESS;
    
    -- Output assigment
    EXC_OUT <= sig_exc_out_reg;

END Behavioral;

-- HW utilization
-- LUT 67
-- FF  52
