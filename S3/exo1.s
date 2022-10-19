L1:			MOV r6, #63176704
				ADC r10, r11, r12 ASR r13
				SUBGES r4, r5, r6, RRX
				BEQ L1
				LDR r7, [PC, - r0, LSR #2]
