-- dec2exe_push <= '1';
-- dec2if_push <= '1';
-- if2dec_pop <= '1';
inc_pc <= dec2if_push;
-- dec_pop <= if2dec_pop;

-- MAE

predictv <= '1';
T1_FETCH <= dec2if_full;
T1_RUN <= if2dec_empty or dec2exe_full;

process (ck)
begin

	if (rising_edge(ck)) then
		if (reset_n = '0') then
			cur_state <= FETCH;
		else
			cur_state <= next_state;
		end if;
	end if;

end process;


process(ck)
begin
	case cur_state is

		when FETCH => 	if T1_FETCH = '1' then next_state <= FETCH;
						else next_state <= RUN;
						end if;
		when RUN => if T1_RUN = '1' then next_state <= RUN;
					else next_state <= FETCH;
					end if;
		
	end case;
end process;


process (ck)
	begin
		case cur_state is

		when FETCH =>
			debug_state <= X"1";
			if2dec_pop <= '0';
			dec2exe_push <= '0';
			--blink <= '0';
			--mtrans_shift <= '0';
			--mtrans_loop_adr <= '0';

			if dec2if_full = '0' and reg_pcv = '1' then
				dec2if_push <= '1';
			else dec2if_push <= '0';
			end if;
		when RUN =>
		debug_state <= X"2";
			if operv = '1' then 
			dec2exe_push <= '1';
			else 	
			dec2exe_push <= '0';
			end if;
			if not if2dec_empty = '1' then 
			if2dec_pop <= '1';
			else
			if2dec_pop <= '0';
			end if;
			if dec2if_full = '0' and reg_pcv = '1' then
				dec2if_push <= '1';
			else dec2if_push <= '0';
			end if;

		
	end case;
end process;











T1_FETCH <= dec2if_full;
T2_FETCH 
T1_RUN <= if2dec_empty or dec2exe_full or predictv = '0';
T2_RUN
T3_RUN
T4_RUN
T5_RUN
T6_RUN
T1_LINK
T1_BRANCH
T2T_BRANCH

