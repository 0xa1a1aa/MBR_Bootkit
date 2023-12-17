```assembly
BITS 16                              ; Specify 16-bit mode. x86 processors start in real mode to maintain compatibility with the legacy architecture
ORG 0x7c00                           ; Set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

jmp main                             ; Jump over the data "section" (i.e. quote)

quote db "Welcome to the real world. We're going to need guns... lots of guns.", 0 

main:
    xor cx, cx                       ; Zero out the CX (counter) register. This is used as an index into the quote string
    mov ah, 0x0e                     ; BIOS function for teletype output. Used to print to the screen
print:
    mov al, [quote + cx]             ; Move ASCII character to print into the lower byte of the AX register
    test al, al                      ; The "test" instruction performs a bitwise AND operation between two operands.
                                     ; If the result of the AND operation is zero, the Zero Flag (ZF) is set.
    jz end                           ; Reached the end of the string (Null byte)
    int 0x10                         ; Call BIOS interrupt 0x10. The ISR (Interrupt Service Routine) prints the character to the screen.
    inc cx                           ; Increment index into the string
    jmp print                        ; Print next character
end:
    jmp $                            ; Jump to the current instruction (infinite loop)

times 510-($-$$) db 0                ; Fill the rest of the sector with zeros:
                                     ; - The "times" directive repeats a given assembly code or data block a specific number of times.
                                     ; - $ represents the current position in the assembly code.
                                     ; - $$ represents the beginning of the code.
                                     ; => 510-($-$$) calculates the number of bytes remaining, and fills them with zeros
dw 0xAA55                            ; Boot signature (end of the MBR)
```