library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( reset : in STD_LOGIC := '0';
           clk : in STD_LOGIC := '1';
           enable : in STD_LOGIC := '0';
           count : out STD_LOGIC_VECTOR(3 downto 0));
end counter;

architecture Behavioral of counter is

signal eoc: std_logic := '0';
signal clk_count: unsigned(16 downto 0); -- #bits = time*fclk = 1ms*100MHz = 100000; log2(100000) = 16.6 = ~17
signal digit_count: unsigned(3 downto 0); -- keeps count of 0-9

begin

eoc <= '1' when clk_count = 2**16-1 else '0'; --timer that outputs a signal every millisecond, 

process (clk, reset)
begin
    if reset = '1' then 
        clk_count <= (others => '0');
        digit_count <= (others => '0');
    elsif clk'event and clk = '1' then
        if enable = '1' then 
            if eoc = '1' then 
                clk_count <= (others => '0'); --resetting count
      
                if digit_count >= 9 then -- setting condition for incrementing counter
                    digit_count <= (others => '0');
                else 
                    digit_count <= digit_count + 1;--incrementing 0-9 counter
                end if; -- counter 
            else 
                clk_count <= clk_count + 1;
                --digit_count <= digit_count;
            end if; -- max count 
            
        end if; -- enable 
    end if; -- clk
end process;

count <= std_logic_vector(digit_count);

end Behavioral;
