

/*----------------------------------------------------------------
// Mon premier programme //
----------------------------------------------------------------*/
.text
.globl _start
_start:


movs r1, #-1
movs r2, #0
movs r2, #1

/*
and r3, r2, r1
eor r3, r2, r1
sub r3, r2, r1
rsb r3, r2, r1
add r3, r2, r1
adc r3, r2, r1
sbc r3, r2, r1
rsc r3, r2, r1
tst r2, r1
teq r2, r1
cmp r2, r1
cmn r2, r1
orr r3, r2, r1
mov r2, #0
bic r3, r2, r1
mvn r2, #0



and r3, r2, r1
eor r3, r2, r1
and r3, r2, r1
eor r3, r2, r1
sub r3, r2, r1
rsb r3, r2, r1
add r3, r2, r1
adc r3, r2, r1
sbc r3, r2, r1
rsc r3, r2, r1
tst r2, r1
teq r2, r1
cmp r2, r1
cmn r2, r1
orr r3, r2, r1
mov r2, #0
bic r3, r2, r1
mvn r2, #0
nop
mvn r1, #0
nop
and r3, r1, r2
mov r3, #6
mov r3, #7
mov r3, #8
mov r3, #9
orr r2, r3, r1

*/


/* 0x00 Reset Interrupt vector address */
b _good
/* 0x04 Undefined Instruction Interrupt vector address */
b _bad
_bad :
add r0, r0, r0
_good :
add r1, r1, r1
