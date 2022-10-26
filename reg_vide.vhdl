library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
	port(
	-- Write Port 1 prioritaire
		wdata1		: in Std_Logic_Vector(31 downto 0);
		wadr1			: in Std_Logic_Vector(3 downto 0);
		wen1			: in Std_Logic;

	-- Write Port 2 non prioritaire
		wdata2		: in Std_Logic_Vector(31 downto 0);
		wadr2			: in Std_Logic_Vector(3 downto 0);
		wen2			: in Std_Logic;

	-- Write CSPR Port
		wcry			: in Std_Logic;
		wzero			: in Std_Logic;
		wneg			: in Std_Logic;
		wovr			: in Std_Logic;
		cspr_wb		: in Std_Logic;
		
	-- Read Port 1 32 bits
		reg_rd1		: out Std_Logic_Vector(31 downto 0);
		radr1			: in Std_Logic_Vector(3 downto 0);
		reg_v1		: out Std_Logic;

	-- Read Port 2 32 bits
		reg_rd2		: out Std_Logic_Vector(31 downto 0);
		radr2			: in Std_Logic_Vector(3 downto 0);
		reg_v2		: out Std_Logic;

	-- Read Port 3 32 bits
		reg_rd3		: out Std_Logic_Vector(31 downto 0);
		radr3			: in Std_Logic_Vector(3 downto 0);
		reg_v3		: out Std_Logic;

	-- read CSPR Port
		reg_cry		: out Std_Logic;
		reg_zero		: out Std_Logic;
		reg_neg		: out Std_Logic;
		reg_cznv		: out Std_Logic;
		reg_ovr		: out Std_Logic;
		reg_vv		: out Std_Logic;
		
	-- Invalidate Port 
		inval_adr1	: in Std_Logic_Vector(3 downto 0);
		inval1		: in Std_Logic;

		inval_adr2	: in Std_Logic_Vector(3 downto 0);
		inval2		: in Std_Logic;

		inval_czn	: in Std_Logic;
		inval_ovr	: in Std_Logic;

	-- PC
		reg_pc		: out Std_Logic_Vector(31 downto 0);
		reg_pcv		: out Std_Logic;
		inc_pc		: in Std_Logic;
	
	-- global interface
		ck				: in Std_Logic;
		reset_n		: in Std_Logic;
		vdd			: in bit;
		vss			: in bit);
end Reg;

architecture Behavior OF Reg is

	signal data_r0 : Std_Logic_Vector(31 downto 0);
	signal data_r1 : Std_Logic_Vector(31 downto 0);
	signal data_r2 : Std_Logic_Vector(31 downto 0);
	signal data_r3 : Std_Logic_Vector(31 downto 0);
	signal data_r4 : Std_Logic_Vector(31 downto 0);
	signal data_r5 : Std_Logic_Vector(31 downto 0);
	signal data_r6 : Std_Logic_Vector(31 downto 0);
	signal data_r7 : Std_Logic_Vector(31 downto 0);
	signal data_r8 : Std_Logic_Vector(31 downto 0);
	signal data_r9 : Std_Logic_Vector(31 downto 0);
	signal data_r10 : Std_Logic_Vector(31 downto 0);
	signal data_r11 : Std_Logic_Vector(31 downto 0);
	signal data_r12 : Std_Logic_Vector(31 downto 0);
	signal data_r13 : Std_Logic_Vector(31 downto 0);
	signal data_r14 : Std_Logic_Vector(31 downto 0);
	signal data_pc : Std_Logic_Vector(31 downto 0);

	signal inv_r0 : Std_Logic;
	signal inv_r1 : Std_Logic;
	signal inv_r2 : Std_Logic;
	signal inv_r3 : Std_Logic;
	signal inv_r4 : Std_Logic;
	signal inv_r5 : Std_Logic;
	signal inv_r6 : Std_Logic;
	signal inv_r7 : Std_Logic;
	signal inv_r8 : Std_Logic;
	signal inv_r9 : Std_Logic;
	signal inv_r10 : Std_Logic;
	signal inv_r11 : Std_Logic;
	signal inv_r12 : Std_Logic;
	signal inv_r13 : Std_Logic;
	signal inv_r14 : Std_Logic;
	signal inv_pc : Std_Logic;

end Behavior;
