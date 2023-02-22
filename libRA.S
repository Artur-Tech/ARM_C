.global newline
newline:
STMFD sp!, {r7, lr}
MOV r7, #4 // write syscall
MOV r0, #1 // file descriptor
LDR r1, =nl // address of newline
MOV r2, #1 // length
SWI #0
LDMFD sp!, {r7, pc}

.global put
put:
// Parameter in r0, buffer in r1
STMFD sp!, {r4, r7, lr}
MOV r4, r0
LDRB r0, [r1]
MOV r7, #4 // write syscall
MOV r0, #1 // file descriptor
MOV r2, #1 // length
SWI #0
LDMFD sp!, {r4, r7, pc}

.global hex
hex:
// Output of r0
STMFD sp!, {r4, r7, lr}
MOV r4, r0
MOV r3, #8
MOV r7, #4 // write syscall
MOV r0, #1 // file descriptor
MOV r2, #1 // length
hexloop:
LDR r1, =lut
ADD r1, r1, r4, lsr #28
STR r1, [sp, #-4]!
MOV r4, r4, lsl #4
SUBS r3, r3, #1
BNE hexloop
LDR r1, =buf
MOV r0, #8
MOV r2, #8
mov r7, #4 // write syscall
SWI #0
BL newline
LDMFD sp!, {r4, r7, pc}

.global exit
exit: // System call exit to end the program.
MOV r7, #1
SWI #0

.data
buf: .space 16
lut: .ascii "0123456789abcdef"
nl: .ascii "\n"