# Run the bootloader:
```SHELL
qemu-system-i386 -drive file=bootloader.bin,format=raw
```

# Run the bootloader with additional disk content:

First copy the MBR to the disk (first sector):
```SHELL
dd if=bootloader.bin of=disk.img bs=512 count=1
```

Then copy bytes to the disk (seek=512 skips the first 512 bytes of the output file):
```SHELL
dd if=content.bin of=disk.img bs=1 count=100 seek=512
```

Then run qemu with the drive (the MBR in the first 512 bytes will be executed first):
```SHELL
qemu-system-i386 -drive file=disk.img,format=raw
```
