library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity exec_vide_tb is
end exec_vide_tb;

architecture archi of exec_vide_tb is
-- signaux

    signal dec2exe_empty : Std_logic        := '0';
	signal exe_pop : Std_logic              := '0';

    -- Decode interface operands
        signal dec_op1			: Std_Logic_Vector(31 downto 0) := x"00000000"; -- first alu input
        signal dec_op2			: Std_Logic_Vector(31 downto 0) := x"00000000"; -- shifter input
        signal dec_exe_dest	    : Std_Logic_Vector(3 downto 0)  := x"0"; -- Rd destination
        signal dec_exe_wb		: Std_Logic                     := '0'; -- Rd destination write back
        signal dec_flag_wb		: Std_Logic                     := '0'; -- CSPR modifiy

    -- Decode to mem interface 
        signal dec_mem_data	    : Std_Logic_Vector(31 downto 0) := x"00000000"; -- data to MEM W
        signal dec_mem_dest	    : Std_Logic_Vector(3 downto 0)  := x"0"; -- Destination MEM R
        signal dec_pre_index 	: Std_logic                     := '0';

        signal dec_mem_lw		: Std_Logic                     := '0';
        signal dec_mem_lb		: Std_Logic                     := '0';
        signal dec_mem_sw		: Std_Logic                     := '0';
        signal dec_mem_sb		: Std_Logic                     := '0';

	-- Shifter command
        signal dec_shift_lsl	: Std_Logic                     := '0';
        signal dec_shift_lsr	: Std_Logic                     := '0';
        signal dec_shift_asr	: Std_Logic                     := '0';
        signal dec_shift_ror	: Std_Logic                     := '0';
        signal dec_shift_rrx	: Std_Logic                     := '0';
        signal dec_shift_val	: Std_Logic_Vector(4 downto 0)  := (others => '0');
        signal dec_cy			: Std_Logic                     := '0';

	-- Alu operand selection
        signal dec_comp_op1	    : Std_logic                     := '0';
        signal dec_comp_op2	    : Std_Logic                     := '0';
        signal dec_alu_cy 		: Std_Logic                     := '0';

	-- Alu command
        signal dec_alu_cmd		: Std_Logic_Vector(1 downto 0)  := "00";

	-- Exe bypass to decod
        signal exe_res			: Std_Logic_Vector(31 downto 0);

        signal exe_c			: Std_Logic;
        signal exe_v			: Std_Logic;
        signal exe_n			: Std_Logic;
        signal exe_z			: Std_Logic;

        signal exe_dest			: Std_Logic_Vector(3 downto 0); -- Rd destination
        signal exe_wb			: Std_Logic; -- Rd destination write back
        signal exe_flag_wb		: Std_Logic; -- CSPR modifiy

	-- Mem interface
        signal exe_mem_adr		: Std_Logic_Vector(31 downto 0); -- Alu res register
        signal exe_mem_data	    : Std_Logic_Vector(31 downto 0);
        signal exe_mem_dest	    : Std_Logic_Vector(3 downto 0);

        signal exe_mem_lw		: Std_Logic;
        signal exe_mem_lb		: Std_Logic;
        signal exe_mem_sw		: Std_Logic;
        signal exe_mem_sb		: Std_Logic;

        signal exe2mem_empty	: Std_logic;
        signal mem_pop			: Std_logic                     := '0';

begin
	test : entity work.Alu
		port map(
                -- Decode interface synchro
                    dec2exe_empty	=> dec2exe_empty,
                    exe_pop			=> exe_pop,
        
                -- Decode interface operands
                    dec_op1			=> dec_op1,
                    dec_op2			=> dec_op2,
                    dec_exe_dest	=> dec_exe_dest,
                    dec_exe_wb		=> dec_exe_wb,
                    dec_flag_wb		=> dec_flag_wb,
                -- Decode to mem interface 
                    dec_mem_data	=> dec_mem_data,
                    dec_mem_dest	=> dec_mem_dest,
                    dec_pre_index 	=> dec_pre_index,

                    dec_mem_lw		=> dec_mem_lw,
                    dec_mem_lb		=> dec_mem_lb,
                    dec_mem_sw		=> dec_mem_sw,
                    dec_mem_sb		=> dec_mem_sb,

                -- Shifter command
                    dec_shift_lsl	=> dec_shift_lsl,
                    dec_shift_lsr	=> dec_shift_lsr,
                    dec_shift_asr	=> dec_shift_asr,
                    dec_shift_ror	=> dec_shift_ror,
                    dec_shift_rrx	=> dec_shift_rrx,
                    dec_shift_val	=> dec_shift_val,
                    dec_cy			=> dec_cy,

                -- Alu operand selection
                    dec_comp_op1	=> dec_comp_op1,
                    dec_comp_op2	=> dec_comp_op2,
                    dec_alu_cy 		=> dec_alu_cy,

                -- Alu command
                    dec_alu_cmd		=> dec_alu_cmd,

                -- Exe bypass to decod
                    exe_res			=> exe_res,

                    exe_c			=> exe_c,
                    exe_v			=> exe_v,
                    exe_n			=> exe_n,
                    exe_z			=> exe_z,

                    exe_dest		=> exe_dest,
                    exe_wb			=> exe_wb,
                    exe_flag_wb		=> exe_flag_wb,

                -- Mem interface
                    exe_mem_adr		=> exe_mem_adr,
                    exe_mem_data	=> exe_mem_data,
                    exe_mem_dest	=> exe_mem_dest,

                    exe_mem_lw		=> exe_mem_lw,
                    exe_mem_lb		=> exe_mem_lb,
                    exe_mem_sw		=> exe_mem_sw,
                    exe_mem_sb		=> exe_mem_sb,

                    exe2mem_empty	=> exe2mem_empty,
                    mem_pop			=> mem_pop);

	op1 <= x"01020301" after 20 ns;
	op2 <= x"00000001" after 20 ns;
    dec_shift_lsr <= '1' after 50 ns;
    dec_shift_val <= "00010" after 40 ns
end archi;
