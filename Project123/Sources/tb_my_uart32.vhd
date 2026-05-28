library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_my_uart32 is
end tb_my_uart32;

architecture Behavioral of tb_my_uart32 is

    CONSTANT NBIT : INTEGER := 32;

    component my_uart32
        Generic (
            NBIT     : INTEGER := 32
            );
        Port ( 
            CLK      : in  STD_LOGIC;
            DATA_IN  : in  STD_LOGIC_VECTOR (NBIT-1 downto 0);
            TX_START : in  STD_LOGIC;
            TX_DATA  : out STD_LOGIC);
        end component;

    signal clk : std_logic := '0';
    signal data_in : std_logic_vector(31 downto 0) := (others => '0');
    signal tx_start : std_logic := '0';
    signal tx_data : std_logic;

begin

    uut: my_uart32
        generic map (
            NBIT => NBIT
        )
        port map (
            CLK => clk,
            DATA_IN => data_in,
            TX_START => tx_start,
            TX_DATA => tx_data
        );

    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    stim_proc: process
    begin
        wait for 100 ns;
        
        for i in 1 to 100 loop
            data_in <= std_logic_vector(to_unsigned(i * 16777217, 32));
            tx_start <= '1';
            wait for 10 ns;
            tx_start <= '0';
            wait for 4000 ns;
        end loop;
        
        data_in <= X"FFFFFFFF";
        wait for 1000 ns;
        tx_start <= '1';
        wait for 30 ns;
        tx_start <= '0';
        wait for 100 ns;
        data_in <= X"0F0F0F0F";
     
        wait;
    end process;

end Behavioral;