AS=nasm
ASFLAGS=-f bin

bootloader.bin: bootloader.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f bootloader.bin
