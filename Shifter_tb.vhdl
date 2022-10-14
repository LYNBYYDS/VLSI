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
	signal shift_val : std_logic_vector(4 downto 0) := (others => '0');
	signal din : std_logic_vector(31 downto 0):= x"01234567";
	signal cin : std_logic:= '1';
	signal dout : std_logic_vector(31 downto 0);
	signal cout : std_logic;
	signal vdd : bit:= '0';
	signal vss : bit:= '0';
	signal clk : std_logic := '0';
begin
	shifter : entity work.Shifter
						port map(shift_lsl, shift_lsr, shift_asr, shift_ror, shift_rrx, shift_val, din, cin, dout, cout, vdd, vss);



						shift_lsl <= '1' after 10 ns, '0' after 20 ns;
						shift_lsr <= '1' after 20 ns, '0' after 30 ns;
						shift_asr <= '1' after 30 ns, '0' after 40 ns;	
						shift_ror <= '1' after 40 ns, '0' after 50 ns;
						shift_rrx <= '1' after 50 ns, '0' after 60 ns;

						
	test: process (clk)
	begin
		clk <= not clk after 60 ns;
			case shift_val is
				when "00000" =>	shift_val <= "00001";
				when "00001" => shift_val <= "00010";
				when "00010" => shift_val <= "00100";
				when "00100" => shift_val <= "01000";
				when "01000" => shift_val <= "10000";
				when others => shift_val <= "00000";
			end case;
		
		
	end process;

end archi;

