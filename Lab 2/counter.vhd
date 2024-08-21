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

entity counter is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC); 
           --sel : in unsigned(1 downto 0);
           --seg : out STD_LOGIC_VECTOR (6 downto 0);
           --an : out STD_LOGIC_VECTOR (3 downto 0));
end counter;

architecture Behavioral of counter is

signal eoc: std_logic;
signal count: unsigned(16 downto 0); -- #bits = time*fclk = 1ms*100MHz = 100000; log2(100000) = 16.6 = ~17
signal cout: unsigned(3 downto 0); -- keeps count of 0-9

begin

--eoc <= '1' when count = 2**16-1 else '0'; --timer that outputs a signal every millisecond, 

process (clk, reset)
begin
    if reset = '1' then 
        count <= (others => '0');
        cout <= (others => '0');
    elsif clk'event and clk = '1' then
        if enable = '1' then 
            if count >= 2**16-1 then 
                count <= (others => '0'); --resetting count
      
                if cout >= 9 then -- setting condition for incrementing counter
                    cout <= (others => '0');
                else 
                    cout <= cout + 1;--incrementing 0-9 counter
                end if; -- counter
                
            else 
                count <= count + 1;
                cout <= cout;
            end if; -- max count 
        end if; -- enable 
    end if; -- clk
end process;



end Behavioral;

--The output of the timer will be used as an enable input for the counter
--While the user keeps the button pressed, the counter shall be enabled and shall count at clock speed
--When the user releases the button, the counter will be disabled
--The counter will count every millisecond
