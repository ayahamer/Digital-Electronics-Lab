----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 20.10.2023 09:55:08
-- Design Name:
-- Module Name: decoders_tb - Behavioral
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

entity decoders_tb is

end decoders_tb;

architecture Behavioral of decoders_tb is

component decoders --is
    Port ( sel : in STD_LOGIC_VECTOR (1 downto 0);
           data : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

--Inputs
signal sel : STD_LOGIC_VECTOR (1 downto 0); -- := (others => '0');
signal data : STD_LOGIC_VECTOR (3 downto 0); --:= (others => '0');

--Outputs
signal seg : STD_LOGIC_VECTOR (6 downto 0);
signal an : STD_LOGIC_VECTOR (3 downto 0);

begin

uut: decoders
port map(
    sel => sel,
    data => data,
    seg => seg,
    an => an);

process
begin

    sel <= "00";
    data <= "0000";
    wait for 10 ns;
    data <= "0001";
    wait for 10 ns;
    data <= "0010";
    wait for 10 ns;
    data <= "0011";
    wait for 10 ns;
    data <= "0100";
    wait for 10 ns;
    data <= "0101";
    wait for 10 ns;
    data <= "0110";
    wait for 10 ns;
    data <= "0111";
    wait for 10 ns;
    data <= "1000";
    wait for 10 ns;
    data <= "1001";
    wait for 10 ns;
   
    sel <= "01";
    data <= "0000";
    wait for 10 ns;
    data <= "0001";
    wait for 10 ns;
    data <= "0010";
    wait for 10 ns;
    data <= "0011";
    wait for 10 ns;
    data <= "0100";
    wait for 10 ns;
    data <= "0101";
    wait for 10 ns;
    data <= "0110";
    wait for 10 ns;
    data <= "0111";
    wait for 10 ns;
    data <= "1000";
    wait for 10 ns;
    data <= "1001";
    wait for 10 ns;
   
    sel <= "10";
    data <= "0000";
    wait for 10 ns;
    data <= "0001";
    wait for 10 ns;
    data <= "0010";
    wait for 10 ns;
    data <= "0011";
    wait for 10 ns;
    data <= "0100";
    wait for 10 ns;
    data <= "0101";
    wait for 10 ns;
    data <= "0110";
    wait for 10 ns;
    data <= "0111";
    wait for 10 ns;
    data <= "1000";
    wait for 10 ns;
    data <= "1001";
    wait for 10 ns;
   
    sel <= "11";
    data <= "0000";
    wait for 10 ns;
    data <= "0001";
    wait for 10 ns;
    data <= "0010";
    wait for 10 ns;
    data <= "0011";
    wait for 10 ns;
    data <= "0100";
    wait for 10 ns;
    data <= "0101";
    wait for 10 ns;
    data <= "0110";
    wait for 10 ns;
    data <= "0111";
    wait for 10 ns;
    data <= "1000";
    wait for 10 ns;
    data <= "1001";
    wait for 10 ns;


end process;

end Behavioral;

