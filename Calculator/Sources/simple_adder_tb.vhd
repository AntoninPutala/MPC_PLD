----------------------------------------------------------------------------------
-- Company: Brno University of Technology
-- Engineer: Bc. Antonin Putala
-- 
-- Create Date: 02/27/2026 09:34:58 AM
-- Design Name: 
-- Module Name: simple_adder_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_adder_tb is

end simple_adder_tb;

architecture Behavioral of simple_adder_tb is
    
    --  Component Declaration
    COMPONENT simple_adder
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
    end COMPONENT;
    
    constant N_BIT : integer := 4;
    
    signal sig_A : STD_LOGIC_VECTOR (N_BIT-1 downto 0);
    signal sig_B : STD_LOGIC_VECTOR (N_BIT-1 downto 0);
    signal sig_Y : STD_LOGIC_VECTOR (N_BIT-1 downto 0);
    signal sig_C : STD_LOGIC;
    signal sig_Z : STD_LOGIC;
    
    signal ref_Y : STD_LOGIC_VECTOR (N_BIT-1 downto 0);
    signal ref_Z : STD_LOGIC;
    signal ref_C : STD_LOGIC;
    
    signal simulus_finished : BOOLEAN := FALSE;
    
begin
    --------------------------------------------------------------------
    -- Component Instatiation
    -- Unit Under Test
    UUT: simple_adder
        Generic map (
            N_BIT => N_BIT
            )
        Port Map ( 
            A => sig_A,
            B => sig_B,
            Y => sig_Y,
            C => sig_C,
            Z => sig_Z
            );
   
      --------------------------------------------------------------------        
     -- Stimulus Generator
     PROCESS

     BEGIN
        sig_A <= X"0";
        sig_B <= X"0";
        WAIT FOR 10 ns;
        
        LOOP_1 : FOR k IN 0 TO 15 LOOP
            sig_A <= std_logic_vector(to_unsigned(k, N_BIT));
            
            LOOP_2 : FOR i IN 0 TO 15 LOOP
                sig_B <= std_logic_vector(to_unsigned(i, N_BIT));
                WAIT FOR 10 ns; 
            END LOOP;
            
        END LOOP;
        
        WAIT FOR 10 ns; 
        
        simulus_finished <= TRUE;
        
        WAIT;
        -- Never
     
     END PROCESS;
     
     -- Output Checker
     PROCESS
        
        VARIABLE cnt_err : INTEGER := 0;
        
     BEGIN
     
        WAIT ON sig_A, sig_B, simulus_finished;
        
        ref_Y <= std_logic_vector ( unsigned (sig_A) + unsigned (sig_B) );
        
        WAIT FOR 2 ns;
        
        IF (unsigned(ref_Y) = 0) THEN
            ref_Z <= '1';
        ELSE 
            ref_Z <= '0';
        END IF;
        
        WAIT FOR 2 ns;
        
        --ASSERT ref_Y = sig_Y REPORT "Error in addition!" SEVERITY ERROR;
        
        IF NOT (ref_Y = sig_Y) THEN
            cnt_err := cnt_err + 1;
            REPORT
                "Error: " & 
                "expected Y = " & integer'image(to_integer(unsigned(ref_Y))) &
                ", actual Y = "   & integer'image(to_integer(unsigned(sig_Y))) &
                " (inputs: " &
                "A = " & integer'image(to_integer(unsigned(sig_A))) &
                ", B = " & integer'image(to_integer(unsigned(sig_B))) &
                "). Current error: " & integer'image(cnt_err)
            SEVERITY ERROR;
        END IF;
        
            IF NOT (ref_Z = sig_Z) THEN
                cnt_err := cnt_err + 1;
            REPORT
                "Error: " & 
                "expected Z = " & std_logic'image(ref_Z) &
                ", actual Z = "     & std_logic'image(sig_Z) &
                " (inputs: " &
                "A = " & integer'image(to_integer(unsigned(sig_A))) &
                ", B = " & integer'image(to_integer(unsigned(sig_B))) &
                "). Current error: " & integer'image(cnt_err)
            SEVERITY ERROR;
        END IF;
        
        IF (simulus_finished) THEN
            REPORT
                "Total Error: " & integer'image(cnt_err)
            SEVERITY NOTE;
            
            IF (cnt_err = 0) THEN
                REPORT
                    "Verification was passed."
                SEVERITY NOTE;
            ELSE
                REPORT
                    "Verification was failed!!!"
                SEVERITY NOTE;
            END IF;
        END IF;
        
     END PROCESS;
     
     
        
end Behavioral;
