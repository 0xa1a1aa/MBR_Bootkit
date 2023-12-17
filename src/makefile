AS=nasm
ASFLAGS=-f bin

bootloader2.bin: bootloader2.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f bootloader.bin
