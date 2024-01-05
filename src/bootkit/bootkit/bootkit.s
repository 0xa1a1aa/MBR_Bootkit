BITS 16                              ; Specify 16-bit mode
ORG 0x7c00                           ; Set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

jmp start                            ; Jump over the "data section"

; data section

start:
; Initialize segment registers
TODO

; Load bootkit from disk to memory

; Execute bootkit