library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity my_uart32 is
    Generic (
        NBIT     : INTEGER := 32
        );
    Port ( 
        CLK      : in  STD_LOGIC;
        DATA_IN  : in  STD_LOGIC_VECTOR (NBIT-1 downto 0);
        TX_START : in  STD_LOGIC;
        TX_DATA  : out STD_LOGIC
        );
end my_uart32;

architecture Behavioral of my_uart32 is

    TYPE t_state IS (ST_IDLE, ST_LOAD, ST_WAIT_EN, ST_START, ST_WRITE, ST_STOP);
                
    SIGNAL pres_st             : t_state   := ST_IDLE;
    SIGNAL next_st             : t_state; 
    
    SIGNAL sig_ce              : STD_LOGIC;
    SIGNAL sig_count_end       : STD_LOGIC;
    SIGNAL sig_data_in         : STD_LOGIC_VECTOR ((NBIT - 1) downto 0) := (others => '0');
    SIGNAL new_sig_data_in     : STD_LOGIC_VECTOR ((NBIT - 1) downto 0);
    SIGNAL sig_tx_data_out     : STD_LOGIC;
    
    SIGNAL sig_count_en        : STD_LOGIC;
    SIGNAL sig_count           : UNSIGNED (4 downto 0) := (others => '0');
    
    constant DIV               : INTEGER := 10;
    
    COMPONENT ce_gen
    GENERIC (
        G_DIV_FACT          : POSITIVE := 2
    );
    PORT (
        CLK                 : IN  STD_LOGIC;
        SRST                : IN  STD_LOGIC;
        CE                  : IN  STD_LOGIC;
        CE_O                : OUT STD_LOGIC 
    );
    END COMPONENT ce_gen; 

begin

    ce_gen_1 : ce_gen
        GENERIC MAP (
            G_DIV_FACT         => DIV
        )
        PORT MAP  (
            CLK                => CLK,
            SRST               => '0',
            CE                 => '1',
            CE_O               => sig_ce
        );
        
PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        pres_st     <= next_st;
        sig_data_in <= new_sig_data_in;
    END IF;
END PROCESS;

PROCESS (pres_st, sig_ce, TX_START, sig_count_end)
BEGIN
    next_st <= pres_st;
    
    CASE pres_st IS
        WHEN ST_IDLE =>
            IF (TX_START = '1') THEN
                next_st <= ST_LOAD;
            END IF;
        WHEN ST_LOAD =>
            next_st <= ST_WAIT_EN;
        WHEN ST_WAIT_EN =>
            IF (sig_ce = '1') THEN
                next_st <= ST_START;
            END IF;
        WHEN ST_START =>
            IF (sig_ce = '1') THEN
                next_st <= ST_WRITE;
            END IF;
        WHEN ST_WRITE =>
            IF (sig_count_end = '1' and sig_ce = '1') THEN
                next_st <= ST_STOP;
            END IF;
        WHEN ST_STOP =>
            IF (sig_ce = '1') THEN
                next_st <= ST_IDLE;
            END IF;
        WHEN OTHERS =>
            next_st <= ST_IDLE;
    END CASE;
END PROCESS;

PROCESS (pres_st, DATA_IN, sig_data_in)
BEGIN
    new_sig_data_in <= sig_data_in;
    
    IF (pres_st = ST_LOAD) THEN
        new_sig_data_in <= DATA_IN;
    END IF;
END PROCESS;

PROCESS (pres_st)
BEGIN
    sig_count_en <= '0';
    
    IF (pres_st = ST_WRITE) THEN
        sig_count_en <= '1';
    END IF;
END PROCESS;

PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        IF (pres_st = ST_LOAD) THEN
            sig_count <= (others => '0');
        ELSIF ((sig_ce = '1') and (sig_count_en = '1')) THEN
            sig_count <= sig_count + 1;   
        END IF;
    END IF;
END PROCESS;

PROCESS (pres_st, sig_count, sig_data_in)
BEGIN
    sig_tx_data_out <= '0';
    
    IF (pres_st = ST_WRITE) THEN
        sig_tx_data_out <= sig_data_in((NBIT - 1) - to_integer(sig_count));
    ELSIF (pres_st = ST_START) THEN
        sig_tx_data_out <= '1';
    ELSIF (pres_st = ST_STOP) THEN
        sig_tx_data_out <= '0';
    END IF;
END PROCESS;

PROCESS (pres_st, sig_count)
BEGIN
    sig_count_end <= '0';
    
    IF ((pres_st = ST_WRITE) and (sig_count = (NBIT-1))) THEN
        sig_count_end <= '1';
    END IF;
END PROCESS;

PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
        TX_DATA <= sig_tx_data_out;
    END IF;
END PROCESS;

end Behavioral;