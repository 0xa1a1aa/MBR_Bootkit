
# BIOS memory map

https://wiki.osdev.org/Memory_Map_(x86)

1. Use the following interrupt https://wiki.osdev.org/Detecting_Memory_(x86)#BIOS_Function:_INT_0x15.2C_EAX_.3D_0xE820 to detect free memory
2. Check if the memory is big enough for the Bootkit
3. Load Bootkit to memory and pass control


# Code to test the BIOS int 13

Assembly code to test the BIOS int 13 read on the second hard disk (dl = 0x81)
```assembly
;
; TEST BIOS int 13 - read first sector of second hard disk
;
jmp read_disk
disk_dap:
    db 0x10                          ; size of packet (16 bytes)
    db 0x00                          ; unused (always 0)
    dw 0x01                          ; number of sectors to transfer
    dw 0x3000                        ; transfer buffer @ 0x3000 (16 bit offset)
    dw 0x0000                        ; transfer buffer (16 bit segment)
    dq 0x00                          ; lower 32-bits of 48-bit starting LBA
    dq 0x00                          ; upper 16-bits of 48-bit starting LBA
read_disk:
    mov ah, 0x42
    mov dl, 0x81                     ; second hard disk
    mov si, disk_dap
    int 0x13
    jc read_error
    jmp read_success
read_error:
    nop
    jmp $
read_success:
    jmp $
```

Started QEMU with the following parameters:
```
qemu-system-i386 -s -S -drive file=bootloader.bin,format=raw -drive file=disk.img,format=raw
```

