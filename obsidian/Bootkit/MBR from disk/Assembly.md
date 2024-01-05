Retrieve MBR from disk (first sector - 512 bytes - from disk):
```SHELL
sudo dd if=/dev/sda of=mbr.bin bs=512 count=1
```

Disassemble MBR (set base address to 0x7c00, which is where the MBR will be loaded by the BIOS):
```SHELL
ndisasm -o 0x7c00 -b 16 mbr.bin > mbr16.as
```
