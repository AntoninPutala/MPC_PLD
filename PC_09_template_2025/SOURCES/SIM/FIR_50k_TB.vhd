----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE std.textio.ALL;
----------------------------------------------------------------------------------
entity FIR_50k_TB is
end FIR_50k_TB;
----------------------------------------------------------------------------------
architecture tb of FIR_50k_TB is
----------------------------------------------------------------------------------

  COMPONENT FIR_50k_wrapper IS
  GENERIC (
    SIM_MODEL                           : BOOLEAN := TRUE
  );
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k_wrapper;

  -----------------------------------------------------------------------

  SIGNAL sig_SIM_finished               : BOOLEAN := FALSE;     -- assert when all test vectors has been applied

  CONSTANT C_aclk_period                : time := 20 ns;
  SIGNAL aclk                           : STD_LOGIC := '0';

  SIGNAL s_axis_data_tvalid             : STD_LOGIC := '0';
  SIGNAL s_axis_data_tready             : STD_LOGIC;
  SIGNAL s_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL m_axis_data_tvalid             : STD_LOGIC;
  SIGNAL m_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  
  SIGNAL tdata                          : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL tvalid                         : STD_LOGIC;

  SIGNAL ref_data                       : STD_LOGIC_VECTOR(8 DOWNTO 0);
  SIGNAL v_cycle                        : INTEGER := 0;
  
  CONSTANT v_cycle_max                  : INTEGER := 2;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- Clock process definitions
  --------------------------------------------------------------------------------

  P_aclk: PROCESS
  BEGIN
    aclk <= '0'; WAIT FOR C_aclk_period/2;
    aclk <= '1'; WAIT FOR C_aclk_period/2;
    IF sig_SIM_finished THEN WAIT; END IF;
  END PROCESS P_aclk;


  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

  FIR_50k_wrapper_i : FIR_50k_wrapper
  GENERIC MAP(
    SIM_MODEL           => FALSE
  )
  PORT MAP(
    aclk                => aclk,
    s_axis_data_tvalid  => s_axis_data_tvalid,
    s_axis_data_tready  => s_axis_data_tready,
    s_axis_data_tdata   => s_axis_data_tdata,
    m_axis_data_tvalid  => m_axis_data_tvalid,
    m_axis_data_tdata   => m_axis_data_tdata
  );

  -----------------------------------------------------------------------
  --   FIR input
  --      read FIR_data_in.txt
  --      feed the FIR filter with the data from file
  -----------------------------------------------------------------------
    read_txt: PROCESS
        FILE     File_ID     : TEXT;     
        VARIABLE line_in     : LINE;    
        VARIABLE v_number    : INTEGER;
    BEGIN
        FILE_OPEN(File_ID, "..\..\..\..\SOURCES\FIR_data\FIR_data_in.txt", READ_MODE);
        
        
        WAIT UNTIL falling_edge(aclk); 
             
        WHILE NOT ENDFILE(File_ID) LOOP-- synchronization
            READLINE(File_ID, line_in);
            READ(line_in, v_number);
            tdata <= STD_LOGIC_VECTOR(TO_SIGNED(v_number,9));
            tvalid <= '1';          
            
            WAIT FOR C_aclk_period * 1;
            tvalid <= '0'; 
            WAIT FOR C_aclk_period * 7;
        END LOOP;
        
        FILE_CLOSE(File_ID);
        sig_SIM_finished <= TRUE;
        WAIT;
    END PROCESS read_txt;

    s_axis_data_tdata <= std_logic_vector(resize(signed(tdata), s_axis_data_tdata'length));
    s_axis_data_tvalid <= tvalid;


  -----------------------------------------------------------------------
  --   FIR output data check
  --      read reference data from FIR_data_out.txt
  --      compare the reference and actual data
  --      report any discrepancy (both a text LOG file and simulator console)
  --      report overall test result
  -----------------------------------------------------------------------
    read_ref : PROCESS
        FILE     File_ID     : TEXT;     
        VARIABLE line_in     : LINE;    
        VARIABLE v_number    : INTEGER;

    BEGIN
        FILE_OPEN(File_ID, "..\..\..\..\SOURCES\FIR_data\FIR_data_out.txt", READ_MODE);
        
        WAIT UNTIL falling_edge(aclk); 
        
        WHILE NOT ENDFILE(File_ID) LOOP-- synchronization
        
           -- IF (tvalid = '1') THEN
                v_cycle <= v_cycle + 1;
                
                IF (v_cycle > v_cycle_max ) THEN
                    READLINE(File_ID, line_in);
                    READ(line_in, v_number);
                    ref_data <= STD_LOGIC_VECTOR(TO_SIGNED(v_number,9));
                END IF;
                
                WAIT FOR C_aclk_period * 8;
           -- END IF;
           -- tvalid <= '1'; 
           -- WAIT FOR C_aclk_period * 1;
           -- tvalid <= '0'; 
        END LOOP;
        
        FILE_CLOSE(File_ID);
    END PROCESS read_ref;
  
  
    write_txt_v2: PROCESS
    
        FILE  File_ID   : TEXT;  
    
    BEGIN
                
        FILE_OPEN(File_ID, "data_out_v2.txt", WRITE_MODE);
        WAIT UNTIL falling_edge(aclk);  
            
        WHILE NOT sig_SIM_finished LOOP
        
            IF tvalid = '1' THEN-- synchronization
                WRITE (File_ID, INTEGER'image(TO_INTEGER(SIGNED(tdata))) & LF);
            END IF;
            
            WAIT FOR C_aclk_period;
        END LOOP;
        
        FILE_CLOSE(File_ID);
        WAIT;
    END PROCESS write_txt_v2;

    write_txt_v3: PROCESS
    
        FILE     File_ID   : TEXT;
        VARIABLE line_out  : LINE;
        VARIABLE text_line : LINE;
        VARIABLE err_count : INTEGER;

    BEGIN
    
        FILE_OPEN(File_ID, "data_out_v3.txt", WRITE_MODE);
        WAIT UNTIL falling_edge(aclk);   
           
        WHILE NOT sig_SIM_finished LOOP
        
            IF ((tvalid = '1') and (v_cycle > v_cycle_max )) THEN
                --WRITE (line_out, INTEGER'image(TO_INTEGER(SIGNED(tdata)))); -- no LF
                --WRITELINE (File_ID, line_out);
                
                IF (std_logic_vector(resize(signed(ref_data),  m_axis_data_tdata'length)) /= m_axis_data_tdata) THEN
                    err_count := err_count + 1;
                    
                    WRITE(text_line, STRING'("Output error at " & TIME'image(NOW)));
                    WRITE(text_line, STRING'(". Expected data: "));
                    WRITE(text_line, TO_INTEGER(SIGNED(std_logic_vector(resize(signed(ref_data),  m_axis_data_tdata'length)))));
                    WRITE(text_line, STRING'(" Actual data: "));
                    WRITE(text_line, TO_INTEGER(SIGNED(m_axis_data_tdata)));
                    REPORT text_line.ALL SEVERITY NOTE; 
                    WRITELINE(File_ID, text_line );
                    
                END IF;
                
                
            END IF;
            
            WAIT FOR C_aclk_period;
        END LOOP;
        
        FILE_CLOSE(File_ID);
        WAIT;
    END PROCESS write_txt_v3;


----------------------------------------------------------------------------------
end tb;
----------------------------------------------------------------------------------
