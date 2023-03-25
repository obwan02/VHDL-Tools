library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity part1 is port(Clk: in std_logic;
					 Enable: in std_logic;
					 Reset: in std_logic;
					 Mode: in std_logic_vector(1 downto 0);
					 Q: out std_logic_vector(4 downto 0));
end entity part1;

architecture behave of part1 is

	function reset_value(mde: std_logic_vector(1 downto 0)) return integer is
	begin
		case mde is
			when "00" => return 0;
			when "01" => return 15;
			when "10" => return 0; -- Counter is used as index
			when others => return 13; -- 0b01101 as an integer
		end case;

	end function reset_value;

begin


	main: process(Clk, Reset)
		variable prevMode: std_logic_vector(1 downto 0) := "00";
		-- When Mode is "10", this is used as an index
		variable counter: integer := 0;

		type t_mode10_arr is array (0 to 6) of integer;
		constant mode10Arr: t_mode10_arr := (5, 2, 13, 30, 25, 16, 18);
	begin

		-- Maybe change to rising_edge ?
		if Reset = '1' then
			counter := reset_value(Mode);
			Q <= std_logic_vector(to_unsigned(counter, Q'length));
		end if;

		if rising_edge(Clk) then
			if Enable = '1' then
				case Mode is
					when "00" => counter := counter + 2;
					when "01" => counter := counter - 1;
					when "10" => counter := counter + 1;
					when "11" => counter := 13; -- 0b01101 as an integer
					when others => null;
				end case;

				if Mode = "00" and counter > 24 then
					counter := 0;
				elsif Mode = "01" and counter < 0 then 
					counter := 15;
				elsif Mode = "10" and counter >= mode10Arr'length then
					counter := 0;
				end if;

				if prevMode /= Mode then
					counter := reset_value(Mode);
				end if;
				prevMode := Mode;

				if Mode = "10" then
					Q <= std_logic_vector(to_unsigned(mode10Arr(counter), Q'length));
				else
					Q <= std_logic_vector(to_unsigned(counter, Q'length));
				end if;
			end if;
		else
			Q <= std_logic_vector(to_unsigned(counter, Q'length));
		end if;


	end process;

end architecture behave;
