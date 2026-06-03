----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/01/2026 03:02:21 PM
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY simple_adder_tb IS
END simple_adder_tb;

ARCHITECTURE Behavioral OF simple_adder_tb IS

    COMPONENT simple_adder
        GENERIC (
            NBIT  : INTEGER
        );
	    PORT (
           A      : IN  STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		   B      : IN  STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		   Y      : OUT STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
		   C      : OUT STD_LOGIC;
		   Z      : OUT STD_LOGIC
	    );
    END COMPONENT;
    
    CONSTANT NBIT : INTEGER := 4;
    
    SIGNAL a      : STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL b      : STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL y      : STD_LOGIC_VECTOR  ((NBIT - 1) DOWNTO 0);
    SIGNAL c      : STD_LOGIC;                              
    SIGNAL z      : STD_LOGIC;                               
    
    SIGNAL cmpl   : BOOLEAN := FALSE; 
    
    


BEGIN

    simple_adder_i : simple_adder
    generic map (
        NBIT  => NBIT
    )
	port map (
		A     => a,
		B     => b,
		Y     => y,
		C     => c,
		Z     => z
	);

    stimulus : PROCESS
    BEGIN
        -- Start values
        a <= (OTHERS => '0');
        b <= (OTHERS => '0');
        
        WAIT FOR 10 ns;
        
        LOOP_1: FOR k IN 0 TO 15
        LOOP
            a <= STD_LOGIC_VECTOR(TO_UNSIGNED(k, NBIT));
            
            LOOP_2: FOR l IN 0 TO 15
            LOOP
                b <= STD_LOGIC_VECTOR(TO_UNSIGNED(l, NBIT));
                
                -- Wait after each value
                WAIT FOR 10 ns;
            END LOOP;
        END LOOP;
        
        cmpl <= TRUE;
        
        WAIT FOR 50 ns;
        
        WAIT;
    END PROCESS;
    
    output_checker : PROCESS
    
        VARIABLE y_ref : STD_LOGIC_VECTOR (y'RANGE)       := (OTHERS => '0');
        VARIABLE temp  : STD_LOGIC_VECTOR (NBIT DOWNTO 0) := (OTHERS => '0');
        VARIABLE c_ref : STD_LOGIC := '0';
        VARIABLE z_ref : STD_LOGIC := '0';
        
        VARIABLE cnt   : INTEGER   := 0;
        
    BEGIN
    
        WAIT ON a, b, cmpl;
        
        y_ref := STD_LOGIC_VECTOR(UNSIGNED(a) + UNSIGNED(b));
        
        IF (y_ref = (y'RANGE => '0')) THEN
            z_ref := '1';
        ELSE
            z_ref := '0';
        END IF;
        
        temp  := STD_LOGIC_VECTOR(RESIZE(UNSIGNED(a), NBIT + 1) + UNSIGNED(b));
        
        c_ref := temp(NBIT);
        
        WAIT FOR 3 ns;
        
        IF (y /= y_ref) THEN
            
            cnt := cnt + 1;
        
            REPORT             
                "Error: actual y = " & INTEGER'image(TO_INTEGER(UNSIGNED(y))) &
                ", expected y = " & INTEGER'image(TO_INTEGER(UNSIGNED(y_ref))) &
                ". Inputs: a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a))) &
                ", b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b))) &
                ". Current error: " & INTEGER'image(cnt) &
                "."
            SEVERITY ERROR;
        END IF;
        
        IF (c /= c_ref) THEN
            
            cnt := cnt + 1;
        
            REPORT             
                "Error: actual c = " & STD_LOGIC'image(c) &
                ", expected c = " & STD_LOGIC'image(c_ref) &
                ". Inputs: a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a))) &
                ", b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b))) &
                ". Current error: " & INTEGER'image(cnt) &
                "."
            SEVERITY ERROR;
        END IF;
        
        IF (z /= z_ref) THEN
            
            cnt := cnt + 1;
        
            REPORT             
                "Error: actual z = " & STD_LOGIC'image(z) &
                ", expected z = " & STD_LOGIC'image(z_ref) &
                ". Inputs: a = " & INTEGER'image(TO_INTEGER(UNSIGNED(a))) &
                ", b = " & INTEGER'image(TO_INTEGER(UNSIGNED(b))) &
                ". Current error: " & INTEGER'image(cnt) &
                "."
            SEVERITY ERROR;
        END IF;
        
        IF (cmpl) THEN
            REPORT             
                "Total errors: " & INTEGER'image(cnt) &
                "."
            SEVERITY NOTE;
            
            IF (cnt = 0) THEN
                REPORT             
                    "Verification was passed!"
                SEVERITY NOTE; 
            ELSE
                REPORT             
                    "Verification was failed!"
                SEVERITY NOTE;
            END IF;
        END IF;
    
    END PROCESS;

END Behavioral;