----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2023 11:29:29
-- Design Name: 
-- Module Name: die_tb - Behavioral
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

entity die_tb is
--  Port ( );
end die_tb;

architecture Behavioral of die_tb is

    component die is
    Port (reset_d : in STD_LOGIC;
          clk_d : in STD_LOGIC;
          enable_d : in STD_LOGIC;
          sel : in unsigned(1 downto 0);
          seg : out STD_LOGIC_VECTOR (6 downto 0);
          an: out STD_LOGIC_VECTOR (3 downto 0)
          );
    end component;

--Inputs
signal reset_t: STD_LOGIC :='1';
signal clk_t: STD_LOGIC :='0';
signal enable_t: STD_LOGIC :='0';
signal sel_t: unsigned(1 downto 0);

--Outputs
signal seg_t : STD_LOGIC_VECTOR (6 downto 0);
signal an_t: STD_LOGIC_VECTOR (3 downto 0);

begin

    uut: die
    port map(
        reset_d => reset_t,
        clk_d => clk_t,
        enable_d => enable_t,
        sel => sel_t,
        seg => seg_t,
        an => an_t);
        
    process 
    begin
    clk_t<= '1';
    wait for 1ns;
    clk_t<= '0';
    wait for 1ns;
    
    end process;
    
    process
    begin
        wait for 10ns;
        reset_t <= '0';
        enable_t <= '1';
        sel_t <= "00";
        wait for 7ns;
        enable_t <= '0';
        wait for 7ns;
        enable_t <= '1';
        --sel_t <= "00";
        wait for 7ns;
        enable_t <= '0';
    end process;

end Behavioral;
