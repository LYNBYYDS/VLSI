library ieee;
use ieee.std_logic_1164.all;
entity add_tb is
end add_tb;

architecture archi of add_tb is
	--signal horloge : std_logic := '0';
	signal Cin_signal : std_logic := '1';
	signal Cout : std_logic;
	signal S : std_logic_vector(31 downto 0); 
	signal a,b : std_logic_vector(31 downto 0) := x"00000000";
begin
	test : entity work.add_32
		port map(a, b, Cin_signal, Cout, S);
	a <= x"80000001" after 20 ns, x"00000101" after 40 ns, x"10000010" after 60 ns; 
	b <= x"80000001" after 20 ns, x"00000010" after 40 ns, x"10000110" after 60 ns;
	
end archi;
