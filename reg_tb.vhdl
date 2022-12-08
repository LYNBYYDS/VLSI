library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity reg_tb is
end reg_tb;

architecture archi of reg_tb is
    
	-- Write Port 1 prioritaire 50:50
		signal wdata1		:  Std_Logic_Vector(31 downto 0) := x"00000000";
		signal wadr1		:  Std_Logic_Vector(3 downto 0) := x"0";
		signal wen1			:  Std_Logic := '0';

	-- Write Port 2 non prioritaire
        signal wdata2		:  Std_Logic_Vector(31 downto 0) := x"00000000";
		signal wadr2		:  Std_Logic_Vector(3 downto 0) := x"0";
		signal wen2			:  Std_Logic := '0';

	-- Write CSPR Port
        signal wcry			:  Std_Logic := '0';
		signal wzero		:  Std_Logic := '0';
		signal wneg			:  Std_Logic := '0';
		signal wovr			:  Std_Logic := '0';
		signal cspr_wb		:  Std_Logic := '0';
		
	-- Read Port 1 32 bits
        signal reg_rd1		:  Std_Logic_Vector(31 downto 0) := x"00000000";
        signal radr1		:  Std_Logic_Vector(3 downto 0) := x"0";
        signal reg_v1		:  Std_Logic := '0';

	-- Read Port 2 32 bits
        signal reg_rd2		:  Std_Logic_Vector(31 downto 0) := x"00000000";
        signal 	radr2		:  Std_Logic_Vector(3 downto 0) := x"0";
        signal 	reg_v2		:  Std_Logic := '0';

	-- Read Port 3 32 bits
        signal reg_rd3		:  Std_Logic_Vector(31 downto 0) := x"00000000";
        signal radr3		:  Std_Logic_Vector(3 downto 0) := x"0";
        signal reg_v3		:  Std_Logic := '0';

	-- read CSPR Port
    signal reg_cry		:  Std_Logic := '0';
    signal reg_zero		:  Std_Logic := '0';
	signal 	reg_neg		:  Std_Logic := '0';
    signal reg_cznv		:  Std_Logic := '0';
	signal 	reg_ovr		:  Std_Logic := '0';
	signal 	reg_vv		:  Std_Logic := '0';
		
	-- Invalidate Port 
	signal 	inval_adr1	:  Std_Logic_Vector(3 downto 0) := x"0";
	signal 	inval1		:  Std_Logic := '0';

    signal inval_adr2	:  Std_Logic_Vector(3 downto 0) := x"0";
    signal inval2		:  Std_Logic := '0';

    signal inval_czn	:  Std_Logic := '0';
	signal 	inval_ovr	:  Std_Logic := '0';

	-- PC
    signal reg_pc		:  Std_Logic_Vector(31 downto 0) := x"00000000";
    signal reg_pcv		:  Std_Logic := '0';
    signal inc_pc		:  Std_Logic := '0';
	
	-- global interface
    signal ck				:  Std_Logic := '0';
    signal reset_n		:  Std_Logic := '0';
    signal vdd			:  bit;
    signal vss			:  bit;

    signal t : Std_Logic_Vector(31 downto 0) := x"00000000";
begin
	test : entity work.Reg
		port map(wdata1, wadr1, wen1, wdata2, wadr2, wen2, wcry, wzero, wneg, wovr, cspr_wb, reg_rd1, radr1, reg_v1, reg_rd2, radr2, reg_v2, reg_rd3, radr3, 
        reg_v3, reg_cry, reg_zero, reg_neg, reg_cznv, reg_ovr, reg_vv, inval_adr1, inval1, inval_adr2, inval2, inval_czn, inval_ovr, reg_pc, reg_pcv, 
        inc_pc, ck, reset_n, vdd, vss);
	
        reset_n <= '1' after 3 ns;

        inval_adr1 <= x"3" after 4 ns;
        inval1 <= '1' after 4 ns, '0' after 6 ns;
        inval_adr2 <= x"3" after 4 ns;
        inval2 <= '1' after 4 ns, '0' after 6 ns;

        wdata1 <= x"FFFF0000" after 4 ns;
        wadr1 <= x"3" after 4 ns;
        wen1 <= '1' after 4 ns;
        wdata2 <= x"0000FFFF" after 4 ns;
        wadr2 <= x"3" after 4 ns; 
        wen2 <= '1' after 4 ns;
    
    
    process(ck)
    begin
        ck <= not ck after 5 ns;
    end process;
end archi;
