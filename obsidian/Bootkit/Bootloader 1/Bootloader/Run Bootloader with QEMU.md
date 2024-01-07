# Run the bootloader:
```SHELL
qemu-system-i386 -drive file=bootloader.bin,format=raw
```

# Run the bootloader with additional disk content:

## One disk

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

## Multiple disks

Then run qemu with the MBR bootloader in one file and the disk in another:
```SHELL
qemu-system-i386 -drive file=bootloader.bin,format=raw -drive file=disk.img,format=raw
```

The BIOS stores the drive number in the register **dl**:
- dl = 0x80 for bootloader.bin ?
- dl = 0x81 for disk.img ?

# Run bootloader and attach GDB

Start bootloader:
```SHELL
qemu-system-i386 -s -S -drive file=disk.img,format=raw
```
**-s**: Start GDB server on standard port 1234.
**-S**: Do not start CPU at startup. It will wait for a debugger to connect.

Start GDB:
```SHELL
gdb
```

Then connect to the QEMU GDB server:
```SHELL
(gdb) target remote localhost:1234
```

Set breakpoint  @ 0x7c00
Because of hardware virtualization, it may be necessary to use a hardware breakpoint:
```SHELL
(gdb) hbreak *0x7c00
```

To not always type in the above GDB commands store them in a file .gdbinit:
```
target remote localhost:1234
hbreak *0x7c00
continue
```
(continue is needed to continue to the breakpoint @ 0x7c00, cause the execution is stalled by providing the **-S** flag)

Then just call GDB like so:
```
gdb -x .gdbinit
```


**GDB plugin** to make debugging more friendly: https://github.com/pwndbg/pwndbg