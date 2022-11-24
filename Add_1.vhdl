library ieee;
use ieee.std_logic_1164.all;

entity Add_1 is
port (	A, B , Cin: in std_logic;
		C : out std_logic;
		S : out std_logic);
end Add_1;

architecture archi of Add_1 is

begin
	S <= A xor B xor Cin;
	C 	<= (A and B) or (Cin and B) or (A and Cin) ;	
end archi;
