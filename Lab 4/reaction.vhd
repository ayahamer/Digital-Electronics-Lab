----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2023 20:34:35
-- Design Name: 
-- Module Name: reaction - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- - Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           button : in STD_LOGIC := '0';
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end reaction;

architecture Behavioral of reaction is
    type state_type is (idle, random_time, run);
    signal current_state, next_state : state_type;
    signal eoc_random, enable_fsm, clear, button_pressed, button_check: STD_LOGIC :='0';
    
    signal digit_count_ms, digit_count_tms, digit_count_hms, digit_count_s: STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- count for ms, tens, hundred, and second
    signal enable_tms, enable_hms,enable_s : STD_LOGIC :='0'; --enable of tens/hundreds, and second
    
    signal eoc_dig : STD_LOGIC :='0';
    signal an_count : unsigned(1 downto 0);
    signal an_clk_count: unsigned(16 downto 0);

    signal eoc, dummy: std_logic := '0';
    signal clk_count: unsigned(16 downto 0); -- #bits = time*fclk = 1ms*100MHz = 100000; log2(100000) = 16.6 = ~17
    signal clk_count_random: unsigned(28 downto 0); -- #bits = time*fclk = 1s*100MHz = 100,000,000; log2(100,000,000) = 26.5 = ~27
    
    
    component counter is
        Port ( reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               enable : in STD_LOGIC;
               clear : in STD_LOGIC;
               eoc: out STD_LOGIC;
               count : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    

    begin
    
        counter_inst_ms : counter --ms digit
        port map (
            reset => reset,
            clk => clk,
            enable => eoc,
            clear => clear,
            eoc => enable_tms,
            count => digit_count_ms
        );
        
        counter_inst_tms : counter -- ten ms digit
        port map (
            reset => reset,
            clk => clk,
            enable => enable_tms,
            clear => clear,
            eoc => enable_hms,
            count => digit_count_tms
        );
        
        counter_inst_hms : counter -- hundred ms digit
        port map (
            reset => reset,
            clk => clk,
            enable => enable_hms,
            clear => clear,
            eoc => enable_s,
            count => digit_count_hms
        );
        
        counter_inst_s : counter -- second digit
        port map (
            reset => reset,
            clk => clk,
            enable => enable_s,
            clear => clear,
            eoc => dummy,
            count => digit_count_s
        );
    
  ----------------------------------  
        
        process(clk, reset) --FSM
        begin
            if reset = '1' then
                current_state <= idle;
            elsif clk'event and clk='1' then
                current_state <= next_state;
            end if;
        end process;

        process(clk, reset) --button edge detector
        begin
            if reset = '1' then
                button_check <= '0';
            elsif clk'event and clk='1' then
                button_check <= button;
            end if;
        end process;
        
        button_pressed <= '1' when button = '1' and button_check = '0' else '0';
        
        process(current_state, button_pressed, eoc_random)--FSM
        begin
            
            case current_state is
                when idle =>
                    clear <= '0';
                    enable_fsm <= '0';
                    if button_pressed = '1' then 
                        next_state <= random_time;
                    else
                        next_state <= idle;
                    end if;
                when random_time =>
                    clear <= '1';
                    enable_fsm <= '1';
                    if eoc_random = '1' then --if button_pressed = '0' and eoc_random = '1' then -- maybe take out button='0' cause we only need rising edge...
                        next_state <= run;
                    else 
                        next_state <= random_time;
                    end if;
                when run =>
                    clear <= '0';
                    enable_fsm <= '1';
                    if button_pressed = '1' then
                        next_state <= idle;
                    else 
                        next_state <= run;
                    end if;
                when others =>
                    clear <= '0';
                    enable_fsm <= '0';
                    next_state <= idle;
            end case;
        end process;
    
        
        eoc <= '1' when clk_count = 99999 and current_state = run else '0';
        process (clk, reset) -- millisecond timer
        begin
            if clear = '1' or reset = '1' then 
                clk_count <= (others => '0');
            elsif clk'event and clk = '1' then
                if current_state = run then -- turn on counter and millisecond counter
                    if eoc = '1' then 
                        clk_count <= (others => '0'); --resetting count
                     else 
                        clk_count <= clk_count + 1;
                    end if;
                end if; -- max count 
            end if; -- clk
        end process;
        
        
        eoc_random <= '1' when clk_count_random = 99999999 else '0'; --and enable_fsm = '1' else '0'; --should be 8 9s 299999999
        process (clk, reset) -- second timer
        begin
            if reset = '1' then 
                clk_count_random <= (others => '0');
            elsif clk'event and clk = '1' then
                --if enable_fsm = '1' then 
                    if eoc_random = '1' then 
                        clk_count_random <= (others => '0'); --resetting count
                     else 
                        clk_count_random <= clk_count_random + 1;
                    end if; -- max count 
                --end if; -- enable 
            end if; -- clk
        end process;
    
        --recreate the time from counter for 1 ms
        eoc_dig <= '1' when an_clk_count = 99999 else '0'; -- for refreshing the displays to create visual effect
        process (reset, clk) --display millisecond timer
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
        
        --matching seg to display output
        process(an_count,digit_count_ms, digit_count_tms, digit_count_hms, digit_count_s)
         begin
            if an_count = 0 then
                an <= "1110";
                case digit_count_ms is
                    when "0000" => seg <= "1000000"; --0
                    when "0001" => seg <= "1111001"; --1
                    when "0010" => seg <= "0100100"; --2
                    when "0011" => seg <= "0110000"; --3
                    when "0100" => seg <= "0011001"; --4
                    when "0101" => seg <= "0010010"; --5
                    when "0110" => seg <= "0000010"; --6
                    when "0111" => seg <= "1111000"; --7
                    when "1000" => seg <= "0000000"; --8
                    when "1001" => seg <= "0010000"; --9
                    when others => seg <= "1111111"; -- null
                end case;   
            elsif an_count = 1 then
                an <= "1101";
                case digit_count_tms is
                    when "0000" => seg <= "1000000"; --0
                    when "0001" => seg <= "1111001"; --1
                    when "0010" => seg <= "0100100"; --2
                    when "0011" => seg <= "0110000"; --3
                    when "0100" => seg <= "0011001"; --4
                    when "0101" => seg <= "0010010"; --5
                    when "0110" => seg <= "0000010"; --6
                    when "0111" => seg <= "1111000"; --7
                    when "1000" => seg <= "0000000"; --8
                    when "1001" => seg <= "0010000"; --9
                    when others => seg <= "1111111"; -- null
                end case; 
            elsif an_count = 2 then
                an <= "1011";
                case digit_count_hms is
                    when "0000" => seg <= "1000000"; --0
                    when "0001" => seg <= "1111001"; --1
                    when "0010" => seg <= "0100100"; --2
                    when "0011" => seg <= "0110000"; --3
                    when "0100" => seg <= "0011001"; --4
                    when "0101" => seg <= "0010010"; --5
                    when "0110" => seg <= "0000010"; --6
                    when "0111" => seg <= "1111000"; --7
                    when "1000" => seg <= "0000000"; --8
                    when "1001" => seg <= "0010000"; --9
                    when others => seg <= "1111111"; -- null
                end case; 
            elsif an_count = 3 then
                an <= "0111";
                case digit_count_s is
                    when "0000" => seg <= "1000000"; --0
                    when "0001" => seg <= "1111001"; --1
                    when "0010" => seg <= "0100100"; --2
                    when "0011" => seg <= "0110000"; --3
                    when "0100" => seg <= "0011001"; --4
                    when "0101" => seg <= "0010010"; --5
                    when "0110" => seg <= "0000010"; --6
                    when "0111" => seg <= "1111000"; --7
                    when "1000" => seg <= "0000000"; --8
                    when "1001" => seg <= "0010000"; --9
                    when others => seg <= "1111111"; -- null
                end case; 
            end if;
         end process;

 end Behavioral;

