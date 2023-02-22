TOOLCHAIN := arm-linux-gnu
TASK := max
SRCS := main.c ${TASK}.S libRA.S
OBJS := $(SRCS:%=%.o)
CFLAGS := -Wall -Wextra -std=gnu99 -nostartfiles
ASFLAGS :=
LDFLAGS :=

# Execute: make run
.PHONY: run
run: main
	qemu-arm $<

# Linking
main: $(OBJS)
	${TOOLCHAIN}-ld $(LDFLAGS) $^ -o $@

# Compile any .c file to .o object file
%.c.o: %.c
	${TOOLCHAIN}-gcc $(CFLAGS) -c $< -o $@

# Assemble any .S file to .o Object file
%.S.o: %.S
	${TOOLCHAIN}-as $(ASFLAGS) $< -o $@

# Clean up: make clean
.PHONY: clean
clean:
	$(RM) $(OBJS) main *.core test.log
	rm -rf tests

# Test: make test
.PHONY: test
test: clean
	bash test.sh

# Is the toolchain available?
.PHONY: check-toolchain
check-toolchain:
	command -v ${TOOLCHAIN}-as ${TOOLCHAIN}-ld ${TOOLCHAIN}-gcc

# Test runner
define test-runner
run.test.$1: tests/main.$1.c.o $(OBJS)
	${TOOLCHAIN}-ld $(LDFLAGS) $$^ -o tests/main.$1
	qemu-arm tests/main.$1
endef
$(foreach test,$(shell ls tests/main.*.c),$(eval $(call test-runner,$(shell basename $(test .c)))))

# Print debug info
.PHONY: debug
