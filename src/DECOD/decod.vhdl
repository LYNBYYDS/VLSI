library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decod is
	port(
	-- Exec  operands
			dec_op1			: out Std_Logic_Vector(31 downto 0); 					-- from decod to exec first(alu) input
			dec_op2			: out Std_Logic_Vector(31 downto 0); 					-- from decod to exec second(shifter) input
			dec_exe_dest	: out Std_Logic_Vector(3 downto 0); 					-- Rd destination exec result reg destination
			dec_exe_wb		: out Std_Logic; 										-- Rd destination write back
			dec_flag_wb		: out Std_Logic; 										-- CSPR modifiy

	-- Decod to mem via exec
			dec_mem_data	: out Std_Logic_Vector(31 downto 0); 					-- from decod to mem data
			dec_mem_dest	: out Std_Logic_Vector(3 downto 0);						-- from decod to mem destination(reg number)
			dec_pre_index 	: out Std_logic;										--

			dec_mem_lw		: out Std_Logic;										--
			dec_mem_lb		: out Std_Logic;										--
			dec_mem_sw		: out Std_Logic;										--
			dec_mem_sb		: out Std_Logic;										--

	-- Shifter command
			dec_shift_lsl	: out Std_Logic;										-- from decod to exec shifter types
			dec_shift_lsr	: out Std_Logic;										--
			dec_shift_asr	: out Std_Logic;										--
			dec_shift_ror	: out Std_Logic;										--
			dec_shift_rrx	: out Std_Logic;										--
			dec_shift_val	: out Std_Logic_Vector(4 downto 0);						-- from decod to exec shifter amounts
			dec_cy			: out Std_Logic;										-- from decod to exec shifter carry in

	-- Alu operand selection
			dec_comp_op1	: out Std_Logic;										-- from decod to exec if we do complement à 1 for the first imput
			dec_comp_op2	: out Std_Logic;										-- from decod to exec if we do complement à 1 for the second imput
			dec_alu_cy 		: out Std_Logic;										-- from decod to exec alu carry in

	-- Exec Synchro
			dec2exe_empty	: out Std_Logic;										--
			exe_pop			: in Std_logic;											--

	-- Alu command
			dec_alu_cmd		: out Std_Logic_Vector(1 downto 0);						-- from decod to exec which kind of operation 

	-- Exe Write Back to reg
			exe_res			: in Std_Logic_Vector(31 downto 0);						-- from exec to decod result of alu

			exe_c				: in Std_Logic;										-- from exec to decod data to write to register
			exe_v				: in Std_Logic;										-- from exec to decod data to write to register
			exe_n				: in Std_Logic;										-- from exec to decod data to write to register
			exe_z				: in Std_Logic;										-- from exec to decod data to write to register

			exe_dest			: in Std_Logic_Vector(3 downto 0); -- Rd destination
			exe_wb			: in Std_Logic; -- Rd destination write back
			exe_flag_wb		: in Std_Logic; -- CSPR modifiy

	-- Ifetch interface
			dec_pc			: out Std_Logic_Vector(31 downto 0) ;
			if_ir				: in Std_Logic_Vector(31 downto 0) ;

	-- Ifetch synchro
			dec2if_empty	: out Std_Logic;
			if_pop			: in Std_Logic;

			if2dec_empty	: in Std_Logic;
			dec_pop			: out Std_Logic;

	-- Mem Write back to reg
			mem_res			: in Std_Logic_Vector(31 downto 0);
			mem_dest			: in Std_Logic_Vector(3 downto 0);
			mem_wb			: in Std_Logic;
			
	-- global interface
			ck					: in Std_Logic;
			reset_n			: in Std_Logic;
			vdd				: in bit;
			vss				: in bit);
end Decod;

----------------------------------------------------------------------

architecture Behavior OF Decod is

component reg
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
end component;

component fifo_127b
	port(
		din		: in std_logic_vector(126 downto 0);
		dout		: out std_logic_vector(126 downto 0);

		-- commands
		push		: in std_logic;
		pop		: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic;
		vdd		: in bit;
		vss		: in bit
	);
end component;

component fifo_32b
	port(
		din		: in std_logic_vector(31 downto 0);
		dout		: out std_logic_vector(31 downto 0);

		-- commands
		push		: in std_logic;
		pop		: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic;
		vdd		: in bit;
		vss		: in bit
	);
end component;

-- signal
	signal cond		: Std_Logic; -- it is set to 0 when the condition is not eligible
	signal condv	: Std_Logic; -- it is set to 0 when the flags used by checking the condition is not all valide
	signal operv	: Std_Logic; -- it is set to 0 when the operands are not all valide so we dont push instruction to the fifo

	signal regop_t  : Std_Logic;
	signal mult_t   : Std_Logic;
	signal swap_t   : Std_Logic;
	signal trans_t  : Std_Logic;
	signal mtrans_t : Std_Logic;
	signal branch_t : Std_Logic;

-- regop instructions
	signal regopns_t  : Std_Logic;
	signal regops_t : Std_Logic;
	signal and_i  : Std_Logic;
	signal eor_i  : Std_Logic;
	signal sub_i  : Std_Logic;
	signal rsb_i  : Std_Logic;
	signal add_i  : Std_Logic;
	signal adc_i  : Std_Logic;
	signal sbc_i  : Std_Logic;
	signal rsc_i  : Std_Logic;
	signal tst_i  : Std_Logic;
	signal teq_i  : Std_Logic;
	signal cmp_i  : Std_Logic;
	signal cmn_i  : Std_Logic;
	signal orr_i  : Std_Logic;
	signal mov_i  : Std_Logic;
	signal bic_i  : Std_Logic;
	signal mvn_i  : Std_Logic;


-- RF read ports
	signal radr1 : Std_Logic_Vector(3 downto 0);
	signal rdata1 : Std_Logic_Vector(31 downto 0);
	signal rvalid1 : Std_Logic;

	signal radr2 : Std_Logic_Vector(3 downto 0);
	signal rdata2 : Std_Logic_Vector(31 downto 0);
	signal rvalid2 : Std_Logic;

	signal radr3 : Std_Logic_Vector(3 downto 0);
	signal rdata3 : Std_Logic_Vector(31 downto 0);
	signal rvalid3 : Std_Logic;

-- RF inval ports
	signal inval_exe_adr : Std_Logic_Vector(3 downto 0);
	signal inval_exe : Std_Logic;

	signal inval_mem_adr : Std_Logic_Vector(3 downto 0);
	signal inval_mem : Std_Logic;

-- Flags
	signal cry	: Std_Logic;
	signal zero	: Std_Logic;
	signal neg	: Std_Logic;
	signal ovr	: Std_Logic;

	signal reg_cznv : Std_Logic;
	signal reg_vv : Std_Logic;

	signal inval_czn : Std_Logic;
	signal inval_ovr : Std_Logic;

-- PC
	signal reg_pc : Std_Logic_Vector(31 downto 0);
	signal reg_pcv : Std_Logic;
	signal inc_pc : Std_Logic;

-- FIFOs
	signal dec2if_full : Std_Logic;
	signal dec2if_push : Std_Logic;

	signal dec2exe_full : Std_Logic;
	signal dec2exe_push : Std_Logic;

	signal if2dec_pop : Std_Logic;

-- Exec  operands
	signal op1			: Std_Logic_Vector(31 downto 0);
	signal op2			: Std_Logic_Vector(31 downto 0);
	signal alu_dest	: Std_Logic_Vector(3 downto 0);
	signal alu_wb		: Std_Logic;
	signal flag_wb		: Std_Logic;

--signal offset32	: Std_Logic_Vector(31 downto 0);
-- Decod to mem via exec
	signal mem_data	: Std_Logic_Vector(31 downto 0);
	signal ld_dest		: Std_Logic_Vector(3 downto 0);
	signal pre_index 	: Std_logic;
	signal mem_lw		: Std_Logic;
	signal mem_lb		: Std_Logic;
	signal mem_sw		: Std_Logic;
	signal mem_sb		: Std_Logic;

-- Shifter command
	signal shift_lsl	: Std_Logic;
	signal shift_lsr	: Std_Logic;
	signal shift_asr	: Std_Logic;
	signal shift_ror	: Std_Logic;
	signal shift_rrx	: Std_Logic;
	signal shift_val	: Std_Logic_Vector(4 downto 0);
	signal cy			: Std_Logic;

-- Alu operand selection
	signal comp_op1	: Std_Logic;
	signal comp_op2	: Std_Logic;
	signal alu_cy 		: Std_Logic;

-- Alu command
	signal alu_cmd		: Std_Logic_Vector(1 downto 0);



	-- type state_type is (FETCH, RUN);-- BRANCH, LINK, MTRANS
	-- signal cur_state, next_state : state_type;
-- 
	-- signal debug_state : Std_Logic_Vector(3 downto 0) := X"0";
	-- signal T1_FETCH : std_logic;
	-- signal T2_FETCH : std_logic;
	-- signal T1_RUN : std_logic;
	-- signal predictv : std_logic;
begin

	dec2exec : fifo_127b
	port map (	din(126) => pre_index,
					din(125 downto 94) => op1,
					din(93 downto 62)	 => op2,
					din(61 downto 58)	 => alu_dest,
					din(57)	 => alu_wb,
					din(56)	 => flag_wb,

					din(55 downto 24)	 => rdata3,
					din(23 downto 20)	 => ld_dest,
					din(19)	 => mem_lw,
					din(18)	 => mem_lb,
					din(17)	 => mem_sw,
					din(16)	 => mem_sb,

					din(15)	 => shift_lsl,
					din(14)	 => shift_lsr,
					din(13)	 => shift_asr,
					din(12)	 => shift_ror,
					din(11)	 => shift_rrx,
					din(10 downto 6)	 => shift_val,
					din(5)	 => cry,

					din(4)	 => comp_op1,
					din(3)	 => comp_op2,
					din(2)	 => alu_cy,

					din(1 downto 0)	 => alu_cmd,

					dout(126)	 => dec_pre_index,
					dout(125 downto 94)	 => dec_op1,
					dout(93 downto 62)	 => dec_op2,
					dout(61 downto 58)	 => dec_exe_dest,
					dout(57)	 => dec_exe_wb,
					dout(56)	 => dec_flag_wb,

					dout(55 downto 24)	 => dec_mem_data,
					dout(23 downto 20)	 => dec_mem_dest,
					dout(19)	 => dec_mem_lw,
					dout(18)	 => dec_mem_lb,
					dout(17)	 => dec_mem_sw,
					dout(16)	 => dec_mem_sb,

					dout(15)	 => dec_shift_lsl,
					dout(14)	 => dec_shift_lsr,
					dout(13)	 => dec_shift_asr,
					dout(12)	 => dec_shift_ror,
					dout(11)	 => dec_shift_rrx,
					dout(10 downto 6)	 => dec_shift_val,
					dout(5)	 => dec_cy,

					dout(4)	 => dec_comp_op1,
					dout(3)	 => dec_comp_op2,
					dout(2)	 => dec_alu_cy,

					dout(1 downto 0)	 => dec_alu_cmd,

					push		 => dec2exe_push,
					pop		 => exe_pop,

					empty		 => dec2exe_empty,
					full		 => dec2exe_full,

					reset_n	 => reset_n,
					ck			 => ck,
					vdd		 => vdd,
					vss		 => vss);

	dec2if : fifo_32b
	port map (	din	=> reg_pc,
					dout	=> dec_pc,

					push		 => dec2if_push,
					pop		 => if_pop,

					empty		 => dec2if_empty,
					full		 => dec2if_full,

					reset_n	 => reset_n,
					ck			 => ck,
					vdd		 => vdd,
					vss		 => vss);

	reg_inst  : reg
	port map(	wdata1		=> exe_res,
				wadr1		=> exe_dest,
				wen1		=> exe_wb,
                                         
				wdata2		=> mem_res,
				wadr2		=> mem_dest,
				wen2		=> mem_wb,
                                          
				wcry		=> exe_c,
				wzero		=> exe_z,
				wneg		=> exe_n,
				wovr		=> exe_v,
				cspr_wb		=> exe_flag_wb,
					               
				reg_rd1		=> rdata1,
				radr1		=> radr1,
				reg_v1		=> rvalid1,
                                          
				reg_rd2		=> rdata2,
				radr2		=> radr2,
				reg_v2		=> rvalid2,
                                          
				reg_rd3		=> rdata3,
				radr3		=> radr3,
				reg_v3		=> rvalid3,
                                          
				reg_cry		=> cry,
				reg_zero	=> zero,
				reg_neg		=> neg,
				reg_ovr		=> ovr,
					               
				reg_cznv	=> reg_cznv,
				reg_vv		=> reg_vv,
                                          
				inval_adr1	=> inval_exe_adr,
				inval1		=> inval_exe,
                                         
				inval_adr2	=> inval_mem_adr,
				inval2		=> inval_mem,
                                          
				inval_czn	=> inval_czn,
				inval_ovr	=> inval_ovr,
                                          
				reg_pc		=> reg_pc,
				reg_pcv		=> reg_pcv,
				inc_pc		=> inc_pc,
				                              
				ck			=> ck,
				reset_n		=> reset_n,
				vdd			=> vdd,
				vss			=> vss);

-- Execution condition
	-- cond equals to '1' the flags answer the condition asked
	cond <= '1' when	(if_ir(31 downto 28) = X"0" and zero = '1') or -- EQ
						(if_ir(31 downto 28) = X"1" and zero = '0') or -- NE
						(if_ir(31 downto 28) = X"2" and cry = '1') or -- CS
						(if_ir(31 downto 28) = X"3" and cry = '0') or -- CC
						(if_ir(31 downto 28) = X"4" and neg = '1') or -- MI
						(if_ir(31 downto 28) = X"5" and neg = '0') or -- PL
						(if_ir(31 downto 28) = X"6" and ovr = '1') or -- VS
						(if_ir(31 downto 28) = X"7" and ovr = '0') or -- VC
						(if_ir(31 downto 28) = X"8" and cry = '1' and zero = '0') or -- HI
						(if_ir(31 downto 28) = X"9" and cry = '0' and zero = '1') or -- LS
						(if_ir(31 downto 28) = X"A" and neg = ovr) or -- GE
						(if_ir(31 downto 28) = X"B" and not neg = ovr) or -- LT
						(if_ir(31 downto 28) = X"C" and zero = '0' and neg = ovr) or -- GT
						(if_ir(31 downto 28) = X"D" and (zero = '1' or not neg = ovr)) or -- LE
						(if_ir(31 downto 28) = X"E") -- AL
						else '0';
	-- condv is not valide when any of the flag used at that condition is not valide 
	condv <= 	'1'  when if_ir(31 downto 28) = X"E" else -- AL
				reg_cznv when (	if_ir(31 downto 28) = X"0" or -- EQ
								if_ir(31 downto 28) = X"1" or -- NE
								if_ir(31 downto 28) = X"2" or -- CS
								if_ir(31 downto 28) = X"3" or -- CC
								if_ir(31 downto 28) = X"4" or -- MI
								if_ir(31 downto 28) = X"5" or -- PL
								if_ir(31 downto 28) = X"8" or -- HI
								if_ir(31 downto 28) = X"9") else -- LS

				reg_vv when (	if_ir(31 downto 28) = X"6" or -- VS
								if_ir(31 downto 28) = X"7" ) else -- VC
				(reg_cznv and reg_vv); -- HI LS GE LT GT LE



-- decod instruction type

	regop_t <= '1' when	if_ir(27 downto 26) = "00" and mult_t = '0' and swap_t = '0' else '0';
	mult_t <= '1' when	if_ir(27 downto 22) = "000000" and if_ir(7 downto 4) = "1001" else '0';
	swap_t <= '1' when	if_ir(27 downto 23) = "00010" and if_ir(11 downto 4) = "00001001" else '0';
	trans_t <= '1' when if_ir(27 downto 26) = "01" else '0';
	mtrans_t <= '1' when if_ir(27 downto 25) = "100" else '0';
	branch_t <= '1' when if_ir(27 downto 25) = "101" else '0';

-- decod regop opcode
	-- arithmetic instructions : AND0 EOR1 SUB2 RSB3 ADD4 ADC5 SBC6 RSC7 ORR12 MOV13 BIC14 MVN15
	regops_t <= '1' when regop_t = '1' and (if_ir(24 downto 21) = X"0" or
											if_ir(24 downto 21) = X"1" or
											if_ir(24 downto 21) = X"2" or
											if_ir(24 downto 21) = X"3" or
											if_ir(24 downto 21) = X"4" or
											if_ir(24 downto 21) = X"5" or
											if_ir(24 downto 21) = X"6" or
											if_ir(24 downto 21) = X"7" or
											if_ir(24 downto 21) = X"C" or
											if_ir(24 downto 21) = X"D" or
											if_ir(24 downto 21) = X"E" or
											if_ir(24 downto 21) = X"F") else '0';
	-- comparation instructions : TST8 TEQ9 CMP10 CMN11
	regopns_t <= '1' when regop_t = '1' and (	if_ir(24 downto 21) = X"8" or
												if_ir(24 downto 21) = X"9" or
												if_ir(24 downto 21) = X"A" or
												if_ir(24 downto 21) = X"B" ) else '0';
	and_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"0" else '0';
	eor_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"1" else '0';
	sub_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"2" else '0';
	rsb_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"3" else '0';
	add_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"4" else '0';
	adc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"5" else '0';
	sbc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"6" else '0';
	rsc_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"7" else '0';
	tst_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"8" else '0';
	teq_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"9" else '0';
	cmp_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"A" else '0';
	cmn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"B" else '0';
	orr_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"C" else '0';
	mov_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"D" else '0';
	bic_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"E" else '0';
	mvn_i <= '1' when regop_t = '1' and if_ir(24 downto 21) = X"F" else '0';



-- Decode interface operands
	op1 <=	rdata1 when regop_t = '1' and not(mov_i or mvn_i) = '1' else
			X"00000000"; -- mov or mvn

	op2	<=  --regop_y = '1' is a calcule instruction
	
			-- if_ir(25) = '0' means op2 is not an immediate operand so we have 2nd operand in a register and its number is in if_ir(3 downto 0)
			rdata2 when if_ir(4) = '0' and regop_t = '1' and if_ir(25) = '0' else

			-- if_ir(25) = '1' means op2 is an immediate operand so we have the 2nd oprand in the instruction if_ir(7 downto 0) 8bit
			x"000000"&if_ir(7 downto 0) when regop_t = '1' and if_ir(25) = '1' else

			x"000000"&"000"&if_ir(11 downto 7) when regop_t = '1' and if_ir(25) = '0' and if_ir(4) = '0' and else

			
			
			x"00000000";
	
	alu_dest <=	if_ir(15 downto 12) when regop_t = '1' and not(tst_i = '1' or teq_i = '1' or cmp_i = '1' or cmn_i = '1') else
				x"0"; -- tst teq cmp cmn
		

	alu_wb	<= 	regops_t when regop_t = '1' else
				'0';

	flag_wb	<= 	'1' when (if_ir(20) = '1' and regops_t = '1') or regopns_t = '1' else
				'0';

-- reg read
	radr1 <= 	if_ir(19 downto 16) when regop_t = '1' else
				x"0";
				
	radr2 <= 	if_ir(3 downto 0) when regop_t = '1' and if_ir(25) = '0' else
				x"0";

	radr3 <= 	if_ir(11 downto 8) when regop_t = '1' and if_ir(25) = '0' and if_ir(4) = '1' else
				x"0";

-- Reg Invalid
	inval_exe_adr <= 	if_ir(15 downto 12) when regop_t = '1' else
						x"0";

	inval_exe <= 	'1' when regops_t = '1' and operv = '1'  else
					'0';

	inval_czn <= 	flag_wb when regop_t = '1' else
					'0';
			
	inval_ovr <= 	flag_wb when regopns_t= '1' else
					'0';

-- operand validite

	operv <=	rvalid2 when regop_t = '1' and (mov_i = '1' or mvn_i = '1') and if_ir(4) = '0' and if_ir(25) = '0' else
				rvalid2 and rvalid3 when regop_t = '1' and (mov_i = '1' or mvn_i = '1') and if_ir(4) = '1' and if_ir(25) = '0' else
				'1' when regop_t = '1' and (mov_i = '1' or mvn_i = '1') and if_ir(25) = '1' else
				rvalid1 and rvalid2 when regop_t = '1' and not(mov_i = '1' or mvn_i = '1') and if_ir(4) = '0' and if_ir(25) = '0'else
				rvalid1 and rvalid2 and rvalid3 when regop_t = '1' and not(mov_i = '1' or mvn_i = '1') and if_ir(4) = '1' and if_ir(25) = '0'else
				rvalid1 when regop_t = '1' and not(mov_i = '1' or mvn_i = '1') and if_ir(25) = '1'else
				'0';

-- Decode to mem interface 
	ld_dest <= x"0";
	pre_index <= '0';

	mem_lw <= '0';
	mem_lb <= '0';
	mem_sw <= '0';
	mem_sb <= '0';

-- Shifter command

	shift_lsl <= 	'1' when if_ir(6 downto 5) = "00" and regop_t = '1' and if_ir(25) = '0' else
					'0';
	shift_lsr <=	'1' when if_ir(6 downto 5) = "01" and regop_t = '1' and if_ir(25) = '0' else
					'0';
	shift_asr <= 	'1' when if_ir(6 downto 5) = "10" and regop_t = '1' and if_ir(25) = '0' else
					'0';
	shift_ror <=	'1' when (if_ir(6 downto 5) = "11" and not if_ir(11 downto 5) = "00000" and regop_t = '1' and if_ir(25) = '0') or (regop_t = '1' and if_ir(25) = '1') else
					'0';
	shift_rrx <=	'1' when if_ir(6 downto 5) = "11" and if_ir(11 downto 5) = "00000" and regop_t = '1' and if_ir(25) = '0' else 
					'0';

	shift_val <=	if_ir(11 downto 7) when regop_t = '1' and if_ir(4) = '0' and if_ir(25) = '0' else 
					rdata3(4 downto 0) when regop_t = '1' and if_ir(4) = '1'  and if_ir(25) = '0'else 
					if_ir(11 downto 8)&'0' when regop_t = '1' and if_ir(25) = '1' else
					"00000";

-- Alu operand selection
	comp_op1	<= '1' when rsb_i = '1' or rsc_i = '1' else '0';
	comp_op2	<=	'1' when sub_i = '1' or sbc_i = '1' or bic_i = '1' or mvn_i = '1' else '0';
	alu_cy <=	'1' when rsb_i = '1' or rsc_i = '1' or sub_i = '1' or sbc_i = '1' or cmp_i = '1' or bic_i = '1' else '0';

-- Alu command

	alu_cmd <=	-- 00 add

				-- 01 and
				"01" when (and_i = '1' or tst_i = '1' or bic_i = '1') and regop_t = '1' else
				-- 10 or 
				"10" when (orr_i = '1') and regop_t = '1' else
				-- 11 xor
				"11" when (eor_i = '1' or teq_i = '1') and regop_t = '1' else
					"00";


dec2exe_push <= '1';
dec2if_push <= '1';
if2dec_pop <= '1';
inc_pc <= dec2if_push;
dec_pop <= if2dec_pop;


end Behavior;

