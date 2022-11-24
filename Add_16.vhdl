library ieee;
use ieee.std_logic_1164.all;

entity Add_16 is
port (	A, B : in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		C : out std_logic;
		S : out std_logic_vector(15 downto 0));
end Add_16;

architecture archi of Add_16 is

-- Component entity
	component Add_4 is
	port(	A, B : in std_logic_vector(3 downto 0);
			Cin : in std_logic;
			C : out std_logic;
			S : out std_logic_vector(3 downto 0));
	end component;

-- Signal instantiation
	signal C_signal : std_logic_vector(2 downto 0);

begin

-- Component instantiation
	hw_0:	Add_4
		port map(A(3 downto 0), B(3 downto 0), Cin, C_signal(0), S(3 downto 0));
	hw_1:	Add_4
		port map(A(7 downto 4), B(7 downto 4), C_signal(0), C_signal(1), S(7 downto 4));
	hw_2:	Add_4
		port map(A(11 downto 8), B(11 downto 8), C_signal(1), C_signal(2), S(11 downto 8));
	hw_3:	Add_4
		port map(A(15 downto 12), B(15 downto 12), C_signal(2), C, S(15 downto 12));
	
end archi;