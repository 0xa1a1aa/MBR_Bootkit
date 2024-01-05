BITS 16                              ; Specify 16-bit mode. x86 processors start in real mode to maintain compatibility with the legacy architecture
ORG 0x7c00                           ; Set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

jmp main                             ; Jump over the data "section" (i.e. quote)

quote db "Welcome to the real world. We're going to need guns... lots of guns.", 0
quote_length equ $ - quote
COLOR_YELLOW_ON_RED equ 0x4e

main:
    ; Set background and foreground colour
    mov ah, 0x06                    ; Clear / scroll screen up function
    xor al, al                      ; Number of lines by which to scroll up (00h = clear entire window)
    xor cx, cx                      ; Row,column of window's upper left corner
    mov dx, 0x184f                  ; Row,column of window's lower right corner
    mov bh, COLOR_YELLOW_ON_RED     ; Background/foreground colour. In our case - red background / yellow foreground (https://en.wikipedia.org/wiki/BIOS_color_attributes)
    int 0x10                        ; Issue BIOS video services interrupt with function 0x06
​
; Move label's bootloaderBanner memory address to si
mov si, quote
; Put 0x0e to ah, which stands for "Write Character in TTY mode" when issuing a BIOS Video Services interrupt 0x10
mov ah, 0x0e
loop:
    ; Load byte at address si to al
    lodsb
    ; Check if al==0 / a NULL byte, meaning end of a C string
    test al, al
    ; If al==0, jump to end, where the bootloader will be halted
    jz end
    ; Issue a BIOS interrupt 0x10 for video services
    int 0x10                                                
    ; Repeat
    jmp loop
end:
    ; Halt the program until the next interrupt
    hlt



times 510-($-$$) db 0                ; Fill the rest of the sector with zeros:
                                     ; - The "times" directive repeats a given assembly code or data block a specific number of times.
                                     ; - $ represents the current position in the assembly code.
                                     ; - $$ represents the beginning of the code.
                                     ; => 510-($-$$) calculates the number of bytes remaining, and fills them with zeros
dw 0xAA55                            ; Boot signature (end of the MBR)