library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity milliseconds is
    Port ( Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Enable : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end milliseconds;

architecture Behavioral of milliseconds is
    signal digit_count_ms : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal digit_count_tms : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal digit_count_hms : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal digit_count_s : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
    signal enable_tms : STD_LOGIC :='0'; --enable of tens
    signal enable_hms : STD_LOGIC :='0'; -- enable of hundreds
    signal enable_s : STD_LOGIC :='0'; -- enable of second
    
    signal eoc_dig : STD_LOGIC :='0';
    signal an_count : unsigned(1 downto 0);
    signal an_clk_count: unsigned(16 downto 0);

    component counter is
        Port (
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin

    counter_inst_ms : counter --ms digit
    port map (
        reset => reset,
        clk => clk,
        enable => enable,
        count => digit_count_ms
    );
    
    counter_inst_tms : counter -- ten ms digit
    port map (
        reset => reset,
        clk => clk,
        enable => enable_tms,
        count => digit_count_tms
    );
    
    counter_inst_hms : counter -- hundred ms digit
    port map (
        reset => reset,
        clk => clk,
        enable => enable_hms,
        count => digit_count_hms
    );
    
    counter_inst_s : counter -- second digit
    port map (
        reset => reset,
        clk => clk,
        enable => enable_s,
        count => digit_count_s
    );
    
    --process(reset, clk)
    --    begin
    --    
    --    if reset = '1' then 
    --        digit_count_ms <= "1111";
    --        digit_count_tms <= "1111";
    --        digit_count_hms <= "1111";
    --        digit_count_s <= "1111";
    --        
    --    elsif clk'event and clk = '1' then
    --        if enable = '1' then 
    --            --digit_count_ms <= digit_count_ms;
    --            
    --            if digit_count_ms = "1001" then 
    --                enable_tms <= '1';
    --                -- segment display number
    --                
    --                if digit_count_ms ="1001" and digit_count_tms = "1001" then
    --                    enable_hms <= '1';
    --                
    --                    if digit_count_ms ="1001" and digit_count_tms = "1001" and digit_count_hms ="1001" then 
    --                        enable_s <= '1';
    --                    else 
    --                        enable_s <= '0';
    --                    end if; -- seconds place
    --                
    --                else 
    --                    enable_hms <= '0';
    --                end if; -- hundreds place
    --                
    --            else enable_tms <= '0';
    --            end if; -- tens place
    --         
    --        --else 
    --            --seg <= digit_count_ms;
    --        end if; -- enable
    --
    --    end if;
    --
    --end process;                

    process(digit_count_ms, digit_count_tms, digit_count_hms, digit_count_s)
    begin
    
        if digit_count_ms = "1001" then 
                    enable_tms <= '1';
                    -- segment display number
                    
                    if digit_count_ms ="1001" and digit_count_tms = "1001" then
                        enable_hms <= '1';
                    
                        if digit_count_ms ="1001" and digit_count_tms = "1001" and digit_count_hms ="1001" then 
                            enable_s <= '1';
                        else 
                            enable_s <= '0';
                        end if; -- seconds place
                    
                    else 
                        enable_hms <= '0';
                    end if; -- hundreds place
                    
                else enable_tms <= '0';
                end if; -- tens place
             
        case digit_count_ms or digit_count_tms or digit_count_hms or digit_count_s is
            when "0000" => seg <= "1111110";
            when "0001" => seg <= "0110000";
            when "0010" => seg <= "1101101";
            when "0011" => seg <= "1111001";
            when "0100" => seg <= "0110011";
            when "0101" => seg <= "1011011";
            when "0110" => seg <= "0001111";
            when "0111" => seg <= "1110000";
            when "1000" => seg <= "1111111";
            when "1001" => seg <= "1110011";
            when others => seg <= "0000000";  -- all segments off
        end case;
    end process;
    
    
    --recreate the time from counter for 1 ms
    eoc_dig <= '1' when an_clk_count = 2**16-1 else '0'; -- initializing new timer
    process (reset, clk)
    begin
    
        if reset = '1' then 
            an_clk_count <= (others => '0'); 
            an_count <= (others => '0');
        elsif clk'event and clk = '1' then
        
            if eoc_dig = '1' then 
                an_clk_count <= (others => '0'); --resetting count
      
                if an_count >= 3 then -- setting condition for incrementing counter
                    an_count <= (others => '0');
                else 
                    an_count <= an_count + 1;--incrementing 0-9 counter
                end if; -- counter 
            else 
                an_clk_count <= an_clk_count + 1;
                end if; -- max count 
         end if;
         
     end process;
     
     process(an_count)
     begin
        case an_count is
        when to_unsigned(0, an_count'length) => an <= "1110";
        when to_unsigned(1, an_count'length) => an <= "1101";
        when to_unsigned(2, an_count'length) => an <= "1011";
        when to_unsigned(3, an_count'length) => an <= "0111";
        when others => an <= "1111";
       end case;
     end process;

    
end Behavioral;
