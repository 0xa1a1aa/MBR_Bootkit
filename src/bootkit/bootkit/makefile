AS=nasm
ASFLAGS=-f bin

bootkit.bin: bootkit.s
	$(AS) $(ASFLAGS) $< -o $@

orig_mbr_64.bin: orig_mbr_64.s
	$(AS) $(ASFLAGS) $< -o $@

all: bootkit.bin orig_mbr_64.bin

.PHONY: clean
clean:
	rm -f bootkit.bin
	rm -f orig_mbr_64.bin