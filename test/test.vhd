library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_part1 is port(clk, reset: in bit; count: out integer);
end entity test_part1;

architecture behave of test_part1 is 
	component part1 is port(Clk: in std_logic;
						 Enable: in std_logic;
						 Reset: in std_logic;
						 Mode: in std_logic_vector(1 downto 0);
						 Q: out std_logic_vector(4 downto 0));
	end component;

	signal t_Clk, t_Enable, t_Reset: std_logic;
	signal t_Mode: std_logic_vector(1 downto 0);
	signal t_Q: std_logic_vector(4 downto 0);
begin

	DUT: part1 port map (Clk => t_Clk, Enable => t_Enable, Reset => t_Reset, Mode => t_Mode, Q => t_Q);

	init: process
	begin

		t_Enable <= '1', '0' after 800 ns, '1' after 839 ns;
		t_Reset <= '0', '1' after 901 ns, '0' after 902 ns, '1' after 921 ns;
		t_Mode <= "00", 
				  "01" after 200 ns,
				  "10" after 400 ns,
				  "11" after 600 ns,
				  "01" after 821 ns;
		wait;
	end process;

	clock: process
	begin
		wait for 5 ns;
		t_Clk <= '1';
		wait for 5 ns;
		t_Clk <= '0';
	end process;

end behave;





