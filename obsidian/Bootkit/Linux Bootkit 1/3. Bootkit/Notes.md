
# Inject original MBR 64 bytes into the reserved space of the Bootkit


```bash
dd if=orig_mbr_64.bin of=bootkit.bin bs=1 count=64 seek=4 conv=notrunc
```
The option **conv=notrunc** is needed otherwise the whole output file is overwritten.
With seek=4 we skip the first instructions of the bootkit (= jmp over the next 64 bytes + some nop's)