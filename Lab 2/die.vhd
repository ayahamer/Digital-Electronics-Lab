----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2023 11:28:30
-- Design Name: 
-- Module Name: die - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity die is
    Port ( reset_d : in STD_LOGIC;
           clk_d : in STD_LOGIC;
           enable_d : in STD_LOGIC;
           sel : in unsigned(1 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end die;

architecture Behavioral of die is

    component counter is
        Port (
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            enable : in STD_LOGIC
        );
    end component;
   
    signal eoc: std_logic;
    signal count: unsigned(16 downto 0); -- #bits = time*fclk = 1ms*100MHz = 100000; log2(100000) = 16.6 = ~17
    signal cout: unsigned (3 downto 0); -- keeps count of 0-9
    
    type seg_cout_array is array(0 to 9) of std_logic_vector(6 downto 0);
    constant seg_cout: seg_cout_array := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000"  -- 9
    );
        
begin

    Counter_Instance : counter
    port map (
        reset => reset_d,
        clk => clk_d,
        enable => enable_d
    );

eoc <= '1' when count = 2**16-1 else '0'; --timer where output signal every 1ms 2**6-1

process(sel) -- 7segment display on off
begin
    case sel is
        when "00" => an <= "1110"; 
        when "01" => an <= "1101"; 
        when "10" => an <= "1011"; 
        when "11" => an <= "0111"; 
        when others => an <= "1111";
    end case;
end process;

process (clk_d, reset_d)
begin
    if reset_d = '1' then 
        count <= (others => '0');
        cout <= (others => '0');
        --need to declare 7seg out off
        
    elsif clk_d'event and clk_d = '1' then
        if enable_d = '1' then --when enable is on
            -- 7seg out is off
            if eoc <= '1' then -- every millisecond
                count <= (others => '0'); --resetting count
      
                if cout >= 9 then --if cout has reached 9
                    cout <= (others => '0'); --reset cout to 0
                else 
                    cout <= cout + 1; --else increment
                end if; -- counter
                
            else --if eoc is '0'
                count <= count + 1; --increment count w/ clk cycle
                cout <= cout; --cout does not change
            end if; -- max count 
            
        else --when enable is off
            count <= count; --count stops
            cout <= cout; --cout stops
            --turn 7seg on
            seg <= seg_cout(to_integer(cout));  --value shown in cout  
        end if; -- enable 
    end if; -- clk
end process;

end Behavioral;