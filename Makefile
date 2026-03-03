# GCC=aarch64-linux-gnu-gcc
# AR=aarch64-linux-gnu-ar
GCC=gcc
AR=ar

.PHONY: ac_lab

ac_lab: testbench.a
	$(GCC) testbench.a functions.s -ggdb -o ac_lab

.PHONY: verify ac_lab

verify:
	python3 verify.py functions.s
	@lines=$$(python3 verify.py functions.s | wc -l); \
	half=$$((lines / 2)); \
	echo "Total number of errors: $$half"

clean:
	rm -f *.o ac_lab
