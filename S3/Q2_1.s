.test

.globl _main

_main:
		MOV	r0, #12
		MOV	r1
		B 	_PGCD

.globl_PGCD

_PGCD:
_comp:		CMPS	r0, r1
		SUBLT	r1, r1, r0
		SUBGT	r0, r0, r1
		BNE	_comp
_END: 		MOVE	r15, r14
