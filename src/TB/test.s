

/*----------------------------------------------------------------
// Mon premier programme //
----------------------------------------------------------------*/
.text
.globl _start
_start:

mov r3, #3
eor r2, r3, #1
/*
and r3, r2, r1
eor r4, r2, r1
and r3, r2, r1
eor r4, r2, r1
sub r5, r2, r1
rsb r6
add r7
adc r8
sbc r9
rsc
tst
tea
cmp
cmn
orr
mov
bic
mvn
*/


/* 0x00 Reset Interrupt vector address */
b _good
/* 0x04 Undefined Instruction Interrupt vector address */
b _bad
_bad :
add r0, r0, r0
_good :
add r1, r1, r1
