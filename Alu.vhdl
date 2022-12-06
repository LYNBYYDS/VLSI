library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
	
entity Alu is
port (	op1 : in std_logic_vector(31 downto 0);
				op2 : in std_logic_vector(31 downto 0);
				cin : in std_logic;
				cmd : in std_logic_vector(1 downto 0);
				res : out std_logic_vector(31 downto 0);
				cout : out std_logic;
				z : out std_logic;
				n : out std_logic;
				v : out std_logic;
				vdd : in bit;
				vss : in bit);
end Alu;

architecture archi of Alu is 
signal res_signal : std_logic_vector(31 downto 0);
signal add_sum : std_logic_vector(31 downto 0);
signal add_cout : std_logic;

begin 

	ADD32 : entity work.Add_32
					port map(op1, op2, cin, add_cout, add_sum);

	res_signal <= 	op1 and op2 when cmd = "01" else
									op1 or op2 when cmd = "10" else
									op1 xor op2;
	
	res <= 	add_sum when cmd = "00" else
					res_signal;

	cout <=	add_cout when cmd = "00" else
					'0';
	z <= 	'1' when (add_sum = x"00000000" and cmd = "00") or (res_signal = x"00000000" and not (cmd = "00")) else
				'0';
	n <= 	'1' when  add_sum(31) = '1' and cmd = "00" else
				'0';
	v <= 	'1' when  ((add_sum(31) = '1' and op1(31) = '0' and op2(31) = '0') or (add_sum(31) = '0' and op1(31) = '1' and op2(31) = '1')) and cmd = "00" else
				'0';
	

end archi;




