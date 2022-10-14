library ieee;
use ieee.std_logic_1164.all;

entity Add_4 is
port (		A, B : in std_logic_vector(3 downto 0);
		Cin : in std_logic;
		C : out std_logic;
		S : out std_logic_vector(3 downto 0));
end Add_4;

architecture archi of Add_4 is

signal C_signal : std_logic_vector(2 downto 0);

begin
	bit_0:	entity work.Add_1
		port map(A(0), B(0), Cin, C_signal(0), S(0));
	bit_1:	entity work.Add_1
		port map(A(1), B(1), C_signal(0), C_signal(1), S(1));
	bit_2:	entity work.Add_1
		port map(A(2), B(2), C_signal(1), C_signal(2), S(2));
	bit_3:	entity work.Add_1
		port map(A(3), B(3), C_signal(2), C, S(3));
	
end archi;
