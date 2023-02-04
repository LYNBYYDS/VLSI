library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity alu_tb is
end alu_tb;

architecture archi of alu_tb is
	signal op1, op2 : std_logic_vector(31 downto 0) := (others => '0');
	signal horloge,cin : std_logic := '0';
	signal cmd : std_logic_vector(1 downto 0);
	signal res : std_logic_vector(31 downto 0);
	signal cout : std_logic;
	signal z, n, v : std_logic := '0';
	signal vdd : bit := '1';
	signal vss : bit := '0';
begin
	test : entity work.alu
		port map(op1, op2, cin, cmd, res, cout, z, n, v, vdd, vss);
	cin <= '1' after 60 ns;	
	op1 <= x"81020301" after 15 ns, x"5C5C5C5C" after 30 ns, x"81020301" after 60 ns, x"5C5C5C5C" after 70 ns;
	op2 <= x"80000001" after 15 ns, x"5C5C5C5C" after 30 ns, x"C5C5C5C5" after 35 ns, x"5C5C5C5C" after 45 ns, x"FFFFFFFF" after 55 ns, 
	x"80000001" after 60 ns, x"5C5C5C5C" after 70 ns, x"C5C5C5C5" after 75 ns, x"5C5C5C5C" after 85 ns, x"FFFFFFFF" after 95 ns;
	cmd <= "00" after 20 ns,"01" after 30 ns,"10" after 40 ns,"11" after 50 ns,"00" after 60 ns,
	"01" after 70 ns,"10" after 80 ns,"11" after 90 ns,"00" after 100 ns;
end archi;
