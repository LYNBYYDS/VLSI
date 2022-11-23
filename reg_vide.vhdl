library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
	port(
	-- Write Port 1 prioritaire 50:50
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
-- component entity
	component Add_32
		port ( 	A, B : in std_logic_vector(31 downto 0);
				Cin : in std_logic;
				C : out std_logic;
				S : out std_logic_vector(31 downto 0));
	end component;

-- valeurs stockees dans les registres r0-r15
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
	signal data_SP : Std_Logic_Vector(31 downto 0);
	signal data_LR : Std_Logic_Vector(31 downto 0);
	signal data_PC : Std_Logic_Vector(31 downto 0);
	signal data_PC_plus4 : Std_Logic_Vector(31 downto 0);
	signal data_PC_plus4_cry : Std_Logic;

-- invalitation des registres r0-r15
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
	signal inv_SP : Std_Logic;
	signal inv_LR : Std_Logic;

-- valeurs stockees dans les registres du CDPR
	signal flag_cry : Std_Logic;
	signal flag_zero : Std_Logic;
	signal flag_neg : Std_Logic;
	signal flag_ovr : Std_Logic;

-- invlitation du CDPR
	signal inv_czn : Std_Logic;
	signal inv_ovr : Std_Logic;

begin
	
	Add32_pc : Add_32
	port map (	A		 => data_PC,
				B		 => x"00000004",
				Cin		 => '0',
				C		 => data_PC_plus4_cry,
				S		 => data_PC_plus4);
	-- R0
		process(ck, reset_n)
		begin
			if reset_n = '0' then
				inv_r0 <= '0'; -- all the register become valide after reset
				inv_r1 <= '0';
				inv_r2 <= '0';
				inv_r3 <= '0';
				inv_r4 <= '0';
				inv_r5 <= '0';
				inv_r6 <= '0';
				inv_r7 <= '0';
				inv_r8 <= '0';
				inv_r9 <= '0';
				inv_r10 <= '0';
				inv_r11 <= '0';
				inv_r12 <= '0';
				inv_SP <= '0';
				inv_LR <= '0';
				inv_czn <= '0';
				inv_ovr <= '0';

			elsif rising_edge(ck) then

				-- write 1
					if wen1 = '1' then 
						case wadr1 is 
							when x"0" =>	-- the number of the registre
							if inv_r0 = '1' then
								inv_r0 = '0' -- when u write it become valide
								data_r0 <= wdata1; -- write the data into the registre
							end if;
							when x"1" =>	
							if inv_r1 = '1' then
								inv_r1 = '0'
								data_r1 <= wdata1;
							end if;
							when x"2" =>	
							if inv_r2 = '1' then
								inv_r2 = '0'
								data_r2 <= wdata1;
							end if;
							when x"3" =>	
							if inv_r3 = '1' then
								inv_r3 = '0'
								data_r3 <= wdata1;
							end if;
							when x"4" =>	
							if inv_r4 = '1' then
								inv_r4 = '0'
								data_r4 <= wdata1;
							end if;
							when x"5" =>	
							if inv_r5 = '1' then
								inv_r5 = '0'
								data_r5 <= wdata1;
							end if;
							when x"6" =>	
							if inv_r6 = '1' then
								inv_r6 = '0'
								data_r6 <= wdata1;
							end if;
							when x"7" =>	
							if inv_r7 = '1' then
								inv_r7 = '0'
								data_r7 <= wdata1;
							end if;
							when x"8" =>	
							if inv_r8 = '1' then
								inv_r8 = '0'
								data_r8 <= wdata1;
							end if;
							when x"9" =>	
							if inv_r9 = '1' then
								inv_r9 = '0'
								data_r9 <= wdata1;
							end if;
							when x"A" =>	
							if inv_r10 = '1' then
								inv_r10 = '0'
								data_r10 <= wdata1;
							end if;
							when x"B" =>	
							if inv_r11 = '1' then
								inv_r11 = '0'
								data_r11 <= wdata1;
							end if;
							when x"C" =>	
							if inv_r12 = '1' then
								inv_r12 = '0'
								data_r12 <= wdata1;
							end if;
							when x"D" =>	
							if inv_SP = '1' then
								inv_SP = '0'
								data_SP <= wdata1;
							end if;
							when x"E" =>	
							if inv_LR = '1' then
								inv_LR = '0'
								data_LR <= wdata1;
							end if;
							when x"F" =>	
							if inc_pc = '0' then
								data_PC <= wdata1;
							end if;
							
						end case;
					end if;

				-- write 2
					if wen2 = '1' then 
						case wadr2 is 
							when x"0" =>	-- the number of the registre
							if inv_r0 = '1' then
								inv_r0 = '0' -- when u write it become valide
								data_r0 <= wdata2; -- write the data into the registre
							end if;
							when x"1" =>	
							if inv_r1 = '1' then
								inv_r1 = '0'
								data_r1 <= wdata2;
							end if;
							when x"2" =>	
							if inv_r2 = '1' then
								inv_r2 = '0'
								data_r2 <= wdata2;
							end if;
							when x"3" =>	
							if inv_r3 = '1' then
								inv_r3 = '0'
								data_r3 <= wdata2;
							end if;
							when x"4" =>	
							if inv_r4 = '1' then
								inv_r4 = '0'
								data_r4 <= wdata2;
							end if;
							when x"5" =>	
							if inv_r5 = '1' then
								inv_r5 = '0'
								data_r5 <= wdata2;
							end if;
							when x"6" =>	
							if inv_r6 = '1' then
								inv_r6 = '0'
								data_r6 <= wdata2;
							end if;
							when x"7" =>	
							if inv_r7 = '1' then
								inv_r7 = '0'
								data_r7 <= wdata2;
							end if;
							when x"8" =>	
							if inv_r8 = '1' then
								inv_r8 = '0'
								data_r8 <= wdata2;
							end if;
							when x"9" =>	
							if inv_r9 = '1' then
								inv_r9 = '0'
								data_r9 <= wdata2;
							end if;
							when x"A" =>	
							if inv_r10 = '1' then
								inv_r10 = '0'
								data_r10 <= wdata2;
							end if;
							when x"B" =>	
							if inv_r11 = '1' then
								inv_r11 = '0'
								data_r11 <= wdata2;
							end if;
							when x"C" =>	
							if inv_r12 = '1' then
								inv_r12 = '0'
								data_r12 <= wdata2;
							end if;
							when x"D" =>	
							if inv_SP = '1' then
								inv_SP = '0'
								data_SP <= wdata2;
							end if;
							when x"E" =>	
							if inv_LR = '1' then
								inv_LR = '0'
								data_LR <= wdata2;
							end if;
							when x"F" =>	
							if inc_pc = '0' then
								data_PC <= wdata2;
							end if;
						end case;
					end if;

				-- read 1
					case radr1 is 
						when x"0" =>
							reg_rd1 <= data_r0;
							reg_v1 <= not inv_r0;
						when x"1" =>
							reg_rd1 <= data_r1;
							reg_v1 <= not inv_r1;
						when x"2" =>
							reg_rd1 <= data_r2;
							reg_v1 <= not inv_r2;
						when x"3" =>
							reg_rd1 <= data_r3;
							reg_v1 <= not inv_r3;
						when x"4" =>
							reg_rd1 <= data_r4;
							reg_v1 <= not inv_r4;
						when x"5" =>
							reg_rd1 <= data_r5;
							reg_v1 <= not inv_r5;
						when x"6" =>
							reg_rd1 <= data_r6;
							reg_v1 <= not inv_r6;
						when x"7" =>
							reg_rd1 <= data_r7;
							reg_v1 <= not inv_r7;
						when x"8" =>
							reg_rd1 <= data_r8;
							reg_v1 <= not inv_r8;
						when x"9" =>
							reg_rd1 <= data_r9;
							reg_v1 <= not inv_r9;
						when x"A" =>
							reg_rd1 <= data_r10;
							reg_v1 <= not inv_r10;
						when x"B" =>
							reg_rd1 <= data_r11;
							reg_v1 <= not inv_r11;
						when x"C" =>
							reg_rd1 <= data_r12;
							reg_v1 <= not inv_r12;
						when x"D" =>
							reg_rd1 <= data_SP;
							reg_v1 <= not inv_SP;
						when x"E" =>
							reg_rd1 <= data_LR;
							reg_v1 <= not inv_LR;
						when x"F" =>
							NULL;
					end case;

				-- read 2
					case radr2 is 
						when x"0" =>
							reg_rd2 <= data_r0;
							reg_v2 <= not inv_r0;
						when x"1" =>
							reg_rd2 <= data_r1;
							reg_v2 <= not inv_r1;
						when x"2" =>
							reg_rd2 <= data_r2;
							reg_v2 <= not inv_r2;
						when x"3" =>
							reg_rd2 <= data_r3;
							reg_v2 <= not inv_r3;
						when x"4" =>
							reg_rd2 <= data_r4;
							reg_v2 <= not inv_r4;
						when x"5" =>
							reg_rd2 <= data_r5;
							reg_v2 <= not inv_r5;
						when x"6" =>
							reg_rd2 <= data_r6;
							reg_v2 <= not inv_r6;
						when x"7" =>
							reg_rd2 <= data_r7;
							reg_v2 <= not inv_r7;
						when x"8" =>
							reg_rd2 <= data_r8;
							reg_v2 <= not inv_r8;
						when x"9" =>
							reg_rd2 <= data_r9;
							reg_v2 <= not inv_r9;
						when x"A" =>
							reg_rd2 <= data_r10;
							reg_v2 <= not inv_r10;
						when x"B" =>
							reg_rd2 <= data_r11;
							reg_v2 <= not inv_r11;
						when x"C" =>
							reg_rd2 <= data_r12;
							reg_v2 <= not inv_r12;
						when x"D" =>
							reg_rd2 <= data_SP;
							reg_v2 <= not inv_SP;
						when x"E" =>
							reg_rd2 <= data_LR;
							reg_v2 <= not inv_LR;
						when x"F" =>
							NULL;
					end case;
				
				-- read 3
					case radr3 is 
						when x"0" =>
							reg_rd3 <= data_r0;
							reg_v3 <= not inv_r0;
						when x"1" =>
							reg_rd3 <= data_r1;
							reg_v3 <= not inv_r1;
						when x"2" =>
							reg_rd3 <= data_r2;
							reg_v3 <= not inv_r2;
						when x"3" =>
							reg_rd3 <= data_r3;
							reg_v3 <= not inv_r3;
						when x"4" =>
							reg_rd3 <= data_r4;
							reg_v3 <= not inv_r4;
						when x"5" =>
							reg_rd3 <= data_r5;
							reg_v3 <= not inv_r5;
						when x"6" =>
							reg_rd3 <= data_r6;
							reg_v3 <= not inv_r6;
						when x"7" =>
							reg_rd3 <= data_r7;
							reg_v3 <= not inv_r7;
						when x"8" =>
							reg_rd3 <= data_r8;
							reg_v3 <= not inv_r8;
						when x"9" =>
							reg_rd3 <= data_r9;
							reg_v3 <= not inv_r9;
						when x"A" =>
							reg_rd3 <= data_r10;
							reg_v3 <= not inv_r10;
						when x"B" =>
							reg_rd3 <= data_r11;
							reg_v3 <= not inv_r11;
						when x"C" =>
							reg_rd3 <= data_r12;
							reg_v3 <= not inv_r12;
						when x"D" =>
							reg_rd3 <= data_SP;
							reg_v3 <= not inv_SP;
						when x"E" =>
							reg_rd3 <= data_LR;
							reg_v3 <= not inv_LR;
						when x"F" =>
							NULL;
					end case;

				-- changer les status invalitations
					-- write1
						if (inval1 = '1') then
							case inval_adr1 is
								when x"0" => 
									inv_r0 <= '1';
								when x"1" => 
									inv_r1 <= '1';
								when x"2" => 
									inv_r2 <= '1';
								when x"3" => 
									inv_r3 <= '1';
								when x"4" => 
									inv_r4 <= '1';
								when x"5" => 
									inv_r5 <= '1';
								when x"6" => 
									inv_r6 <= '1';
								when x"7" => 
									inv_r7 <= '1';
								when x"8" => 
									inv_r8 <= '1';
								when x"9" => 
									inv_r9 <= '1';
								when x"A" => 
									inv_r10 <= '1';
								when x"B" => 
									inv_r11 <= '1';
								when x"C" => 
									inv_r12 <= '1';
								when x"D" => 
									inv_SP <= '1';
								when x"E" => 
									inv_LR <= '1';
								when x"F" => 
									NULL;
									-- inv_PC <= '1';
							end case;
						end if;
					
					-- write2
						if (inval2 = '1') then
							case inval_adr2 is
								when x"0" => 
									inv_r0 <= '1';
								when x"1" => 
									inv_r1 <= '1';
								when x"2" => 
									inv_r2 <= '1';
								when x"3" => 
									inv_r3 <= '1';
								when x"4" => 
									inv_r4 <= '1';
								when x"5" => 
									inv_r5 <= '1';
								when x"6" => 
									inv_r6 <= '1';
								when x"7" => 
									inv_r7 <= '1';
								when x"8" => 
									inv_r8 <= '1';
								when x"9" => 
									inv_r9 <= '1';
								when x"A" => 
									inv_r10 <= '1';
								when x"B" => 
									inv_r11 <= '1';
								when x"C" => 
									inv_r12 <= '1';
								when x"D" => 
									inv_SP <= '1';
								when x"E" => 
									inv_LR <= '1';
								when x"F" => 
									NULL;
									-- inv_PC <= '1';
							end case;
						end if;
					
						-- czn
						if (inval_czn = '1') then
							inv_czn <= '1';
						end if;
					
					-- overflow
						if (inval_ovr = '1') then
							inv_ovr <= '1';
						end if;

					-- PC registre
						if (inc_pc = 0) then
							data_PC <= data_PC + 4;

			end if;
		
		end process;

end Behavior;
