GHDL = ghdl

Add_1.o : Add_1.vhdl
	${GHDL} -a -v $<
Add_4.o : Add_4.vhdl
	${GHDL} -a -v $<
Add_16.o : Add_16.vhdl
	${GHDL} -a -v $<
Add_32.o : Add_32.vhdl
	${GHDL} -a -v $<
clean :
	rm *.o *.vcd
