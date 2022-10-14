library ieee;
use ieee.std_logic_1164.all;
entity tb is
end tb;

architecture archi of tb is
	--signal horloge : std_logic := '0';
	signal Cin_signal : std_logic := '0';
	signal C : std_logic;
	signal S : std_logic_vector(3 downto 0); 
	signal a,b : std_logic_vector(3 downto 0) := "0000";
begin
	test : entity work.Add_4
		port map(a, b, Cin_signal, C, S);
	a <= "0001" after 20 ns, "0101" after 40 ns, "1010" after 60 ns, "0111" after 80 ns; 
	b <= "0001" after 20 ns, "0010" after 40 ns, "1110" after 60 ns, "0101" after 80 ns;
	
end archi;
