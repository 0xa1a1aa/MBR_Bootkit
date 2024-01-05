AS=nasm
ASFLAGS=-f bin

bl1: bl_simple_text.s
	$(AS) $(ASFLAGS) $< -o $@

bl2: bl_simple_text2.s
	$(AS) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f bl1
	rm -f bl2
