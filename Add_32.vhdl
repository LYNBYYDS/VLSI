library ieee;
use ieee.std_logic_1164.all;

entity Add_32 is
port (		A, B : in std_logic_vector(31 downto 0);
		Cin : in std_logic;
		C : out std_logic;
		S : out std_logic_vector(31 downto 0));
end Add_32;

architecture archi of Add_32 is

-- Component entity
	component Add_16 
	port(	A, B : in std_logic_vector(15 downto 0);
			Cin : in std_logic;
			C : out std_logic;
			S : out std_logic_vector(15 downto 0));
	end component;

-- Signal instantiation
signal C_signal : std_logic;

begin

-- Component instantiation
	part_0:	Add_16
		port map(A(15 downto 0), B(15 downto 0), Cin, C_signal, S(15 downto 0));
	part_1:	Add_16
		port map(A(31 downto 16), B(31 downto 16), C_signal, C, S(31 downto 16));
	
end archi;
