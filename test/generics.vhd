library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity generic_test is 
	generic(N: positive := 2);
	port(Clk: in std_logic;
		 Data: in std_logic_vector(N downto 0);
		 Q: out std_logic_vector(N downto 0));
end entity generic_test;

architecture behave of generic_test is
begin
	
	process(Clk) 
	begin
		if rising_edge(Clk) then
			Q <= Data;
		else
			Q <= (others => '0');
		end if;
	end process;

end architecture;
