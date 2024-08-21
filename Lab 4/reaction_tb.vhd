----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2023 16:39:58
-- Design Name: 
-- Module Name: reaction_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reaction_tb is
--  Port ( );
end reaction_tb;

architecture Behavioral of reaction_tb is

component reaction is 
Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           button : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

signal reset : STD_LOGIC;
signal clk : STD_LOGIC;
signal button : STD_LOGIC :='0';

signal seg : STD_LOGIC_VECTOR (6 downto 0);
signal an : STD_LOGIC_VECTOR (3 downto 0);


begin

uut: reaction
port map (
    reset => reset,
    clk => clk,
    button => button,
    seg => seg,
    an => an);
    
    process 
    begin
        
        clk <= '0';
        wait for 7.6ns;
        clk <= '1';
        wait for 7.6ns;
    end process;
    
    process 
    begin
        reset <= '1';
        wait for 2ms;
        reset <= '0';
        wait for 30ms; 
        button <= '1';
        wait for 20ms;
        button <= '0';
        wait for 80ms;
        button <= '1';
        wait for 20ms;
        button <= '0';
        wait for 80ms;
         button <= '1';
        wait for 20ms;
        button <= '0';
        wait for 80ms;
        button <= '1';
        wait for 20ms;
        button <= '0';
        wait;
    end process;
    

end Behavioral;
