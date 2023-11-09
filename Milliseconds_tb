----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2023 13:21:47
-- Design Name: 
-- Module Name: milliseconds_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity milliseconds_tb is
--  Port ( );
end milliseconds_tb;

architecture Behavioral of milliseconds_tb is

component milliseconds is 
Port ( Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Enable : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

signal reset : STD_LOGIC := '1';
signal clk : STD_LOGIC := '0';
signal enable : STD_LOGIC := '1';

signal seg : STD_LOGIC_VECTOR (6 downto 0);
signal an : STD_LOGIC_VECTOR (3 downto 0);


begin

uut: milliseconds
port map (
    reset => reset,
    clk => clk,
    enable => enable,
    seg => seg,
    an => an);
    
    process 
    begin
        
        clk <= '1';
        wait for 7.6ns;
        clk <= '0';
        wait for 7.6ns;
    end process;
    
    process 
    begin
        wait for 2ms;
        reset <= '0';
        wait;
       -- wait for 8ms;
       --enable <= '1';
       -- wait for 20ms;
        --enable <= '0';
    end process;
    
end Behavioral;
