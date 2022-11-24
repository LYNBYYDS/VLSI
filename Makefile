GHDL = ghdl

all : exec_vide.o

Add_32.o : Add_32.vhdl
	${GHDL} -a -v $<
Add_16.o : Add_16.vhdl
	${GHDL} -a -v $<
Add_4.o : Add_4.vhdl
	${GHDL} -a -v $<
Add_1.o : Add_1.vhdl
	${GHDL} -a -v $<
Alu.o : Alu.vhdl
	${GHDL} -a -v $<
Shifter.o : Shifter.vhdl
	${GHDL} -a -v $<
exec_vide.o : exec_vide.vhdl
	${GHDL} -a -v $<
fifo_72b,o : fifo_72b.vhdl
	${GHDL} -a -v $<

Alu_tb.o : Alu_tb.vhdl
	${GHDL} -a -v $<
clean :
	rm *.o *.vcd
