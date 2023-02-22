#include <stdio.h>
#include <stdlib.h>

extern void hex(int p);
extern void newline();
extern void put(char cl);
extern void exit(int ret);

#define true 1
#define false 0

struct ArmRegisters
{
    int sr[13];
};

// Assuming all strings are null terminated.
void println(const char *chars)
{
    while (*chars)
        put(*chars++);
    newline();
}

// Linear congruential generator to generate pseudo-random numbers.
static unsigned long my_rand_state = 1;

void srand(unsigned long seed)
{
    my_rand_state = seed;
}

long rand()
{
    my_rand_state = (my_rand_state * 1103515245 + 12345) % 2147483648;
    return my_rand_state;
}

// Dump ARM registers to a struct.
#define DUMP_REGISTERS(TARGET_NAME)                  \
    struct ArmRegisters TARGET_NAME;                 \
    asm volatile("STR r0 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[0]));  \
    asm volatile("STR r1 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[1]));  \
    asm volatile("STR r2 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[2]));  \
    asm volatile("STR r3 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[3]));  \
    asm volatile("STR r4 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[4]));  \
    asm volatile("STR r5 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[5]));  \
    asm volatile("STR r6 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[6]));  \
    asm volatile("STR r7 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[7]));  \
    asm volatile("STR r8 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[8]));  \
    asm volatile("STR r9 , [%[addr]]"                \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[9]));  \
    asm volatile("STR r10 , [%[addr]]"               \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[10])); \
    asm volatile("STR r11 , [%[addr]]"               \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[11])); \
    asm volatile("STR r12 , [%[addr]]"               \
                 :                                   \
                 : [addr] "r"(&TARGET_NAME.sr[12]));

// Check if an ARM register was restored after a function call.
// Check if an ARM register was restored after a function call.
int arm_eval_restored_register(struct ArmRegisters a, struct ArmRegisters b, int n)
{
    if (a.sr[n] != b.sr[n])
    {
        println("Start: Register was not restored.");
        println("Register:");
        hex(n);
        println("Value before call:");
        hex(a.sr[n]);
        println("Value after call:");
        hex(b.sr[n]);
        println("End: Register was not restored.");
        return 1 << (n + 1);
    }
    return 0;
}
