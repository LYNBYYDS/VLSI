library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
	
entity Shifter is
port (	shift_lsl : in std_logic;
		shift_lsr : in std_logic;
		shift_asr : in std_logic;
		shift_ror : in std_logic;
		shift_rrx : in std_logic;
		shift_val : in std_logic_vector(4 downto 0);
				
		din : in Std_Logic_Vector(31 downto 0);
		cin : in Std_Logic;
		dout : out Std_Logic_Vector(31 downto 0);
		cout : out Std_Logic;

		-- global interface
		vdd : in bit;
		vss : in bit);
end Shifter;

architecture archi of Shifter is 
	
	signal cout_left : std_logic;
	signal cout_right : std_logic;
	signal dout_inter0 : std_logic_vector(31 downto 0);
	signal dout_inter1 : std_logic_vector(31 downto 0);
	signal dout_inter2 : std_logic_vector(31 downto 0);
	signal dout_inter3 : std_logic_vector(31 downto 0);

begin 
	
	dout_inter0 <= 	din(30 downto 0)&'0' when shift_lsl = '1' and shift_val(0) = '1' else														--lsl

					'0'&din(31 downto 1) when shift_lsr = '1' and shift_val(0) = '1' else														--lsr

					din(31)&din(31 downto 1) when shift_asr = '1' and shift_val(0) = '1' else													--asr

					din(0)&din(31 downto 1) when shift_ror = '1' and shift_val(0) = '1' else													--ror

				
					din;
	dout_inter1 <= 	dout_inter0(29 downto 0)&"00" when shift_lsl = '1' and shift_val(1) = '1' else												--lsl

					"00"&dout_inter0(31 downto 2) when shift_lsr = '1' and shift_val(1) = '1' else												--lsr

					dout_inter0(31)&dout_inter0(31)&dout_inter0(31 downto 2) when shift_asr = '1' and shift_val(1) = '1' else					--asr

					dout_inter0(1 downto 0)&dout_inter0(31 downto 2) when shift_ror = '1' and shift_val(1) = '1' else							--ror

					dout_inter0;
	dout_inter2 <= 	dout_inter1(27 downto 0)&x"0" when shift_lsl = '1' and shift_val(2) = '1' else												--lsl

					x"0"&dout_inter1(31 downto 4) when shift_lsr = '1' and shift_val(2) = '1' else												--lsr

					dout_inter1(31)&dout_inter1(31)&dout_inter1(31)&dout_inter1(31)&dout_inter1(31 downto 2) when shift_asr = '1' and shift_val(2) = '1' else																			--asr

					dout_inter1(3 downto 0)&dout_inter1(31 downto 4) when shift_ror = '1' and shift_val(2) = '1' else							--ror

					dout_inter1;
	dout_inter3 <= 	dout_inter2(23 downto 0)&x"00" when shift_lsl = '1' and shift_val(3) = '1' else												--lsl

					x"00"&dout_inter2(31 downto 8) when shift_lsr = '1' and shift_val(3) = '1' else												--lsr

					dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31)&dout_inter2(31 downto 2) when shift_asr = '1' and shift_val(3) = '1' else  			--asr

					dout_inter2(7 downto 0)&dout_inter2(31 downto 8) when shift_ror = '1' and shift_val(3) = '1' else							--ror

					dout_inter2;
	dout <= 		dout_inter3(15 downto 0)&x"0000" when shift_lsl = '1' and shift_val(4) = '1' else											--lsl

					x"0000"&dout_inter3(31 downto 16) when shift_lsr = '1' and shift_val(4) = '1' else												--lsr

					dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31)&dout_inter3(31 downto 2) when shift_asr = '1' and shift_val(4) = '1' else	--asr

					dout_inter3(15 downto 0)&dout_inter3(31 downto 16) when shift_ror = '1' and shift_val(4) = '1' else							--ror

					cin&dout_inter3(31 downto 1) when shift_rrx = '1' else																		--rrx

					dout_inter3;


	cout_left 	<=	din(31) when shift_val = "00001" else
					dout_inter0(30) when shift_val(4 downto 1) = "0001" else
					dout_inter1(28) when shift_val(4 downto 2) = "001" else
					dout_inter2(24) when shift_val(4 downto 3) = "01" else
					dout_inter3(16) when shift_val(4) = '1' else
					'0';
	cout_right 	<=	din(0) when shift_val = "00001" else
					dout_inter0(1) when shift_val(4 downto 1) = "0001" else
					dout_inter1(3) when shift_val(4 downto 2) = "001" else
					dout_inter2(7) when shift_val(4 downto 3) = "01" else
					dout_inter3(15) when shift_val(4) = '1' else
					'0';
	cout <= 	cout_left when shift_lsl = '1' else
				cout_right when shift_lsr = '1' or shift_asr = '1' or shift_ror = '1' else
				din(0) when shift_rrx = '1' else
				cin;

end archi;




