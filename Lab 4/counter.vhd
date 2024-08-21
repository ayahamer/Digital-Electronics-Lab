library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( reset : in STD_LOGIC := '0';
           clk : in STD_LOGIC := '1';
           enable : in STD_LOGIC := '0';
           clear : in STD_LOGIC := '0';
           eoc: out STD_LOGIC;
           count : out STD_LOGIC_VECTOR(3 downto 0));
end counter;

architecture Behavioral of counter is

signal digit_count: unsigned(3 downto 0); -- keeps count of 0-9

begin

    eoc <= '1' when digit_count >= 9 and enable = '1' else '0'; --timer that outputs a signal every millisecond, 

    process (clk, reset)
    begin
        if reset = '1' or clear = '1' then 
            digit_count <= (others => '0');
        elsif clk'event and clk = '1' then
            if enable = '1' then 
                if digit_count >= 9 then -- setting condition for incrementing counter
                    digit_count <= (others => '0');
                else 
                    digit_count <= digit_count + 1;--incrementing 0-9 counter
                end if; -- counter 
            end if; -- enable 
        end if; -- clk
    end process;

    count <= std_logic_vector(digit_count);

end Behavioral;