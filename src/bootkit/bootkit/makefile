AS=nasm
ASFLAGS=-f bin

bootkit.bin: bootkit.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f bootkit.bin
