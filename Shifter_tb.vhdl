library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter_tb is
end Shifter_tb;

architecture archi of Shifter_tb is
	signal shift_lsl : std_logic:= '0';
	signal shift_lsr : std_logic:= '0';
	signal shift_asr : std_logic:= '0';
	signal shift_ror : std_logic:= '0';
	signal shift_rrx : std_logic:= '0';
	signal shift_val : std_logic_vector(4 downto 0) := "00001";
	signal din : std_logic_vector(31 downto 0):= x"87653210";
	signal cin : std_logic:= '0';
	signal dout : std_logic_vector(31 downto 0);
	signal cout : std_logic;
	signal vdd : bit:= '0';
	signal vss : bit:= '0';
	signal clk : std_logic := '0';
begin
	shifter : entity work.Shifter
						port map(shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, shift_val, din, cin, dout, cout, vdd, vss);

						shift_val <= "00010" after 12 ns, "00100" after 14 ns, "01000" after 16 ns, "10000" after 18 ns, "10110" after 20 ns;
						cin <= '1' after 60 ns;
						shift_lsl <= '1' after 10 ns, '0' after 20 ns, '1' after 60 ns, '0' after 65 ns;
						shift_lsr <= '1' after 20 ns, '0' after 30 ns, '1' after 65 ns, '0' after 70 ns;
						shift_asr <= '1' after 30 ns, '0' after 40 ns, '1' after 70 ns, '0' after 75 ns;	
						shift_ror <= '1' after 40 ns, '0' after 50 ns, '1' after 75 ns, '0' after 80 ns;
						shift_rrx <= '1' after 50 ns, '0' after 60 ns, '1' after 80 ns, '0' after 85 ns;

						

end archi;

