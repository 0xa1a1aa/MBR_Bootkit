BITS 16                              ; specify 16-bit mode
ORG 0x7c00                           ; set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

COLOR_GREEN_ON_BLACK EQU 0x0a

jmp clear_window

quote db "Original MBR", 0

clear_window:  
    mov ah, 0x06
    xor al, al                       ; set al = 0x00 for entire window
    xor cx, cx                       ; set upper left corner (ch = row = 0, cl = column = 0)
    mov dx, 0xffff
    mov bh, COLOR_GREEN_ON_BLACK
    int 0x10

reset_cursor:  
    mov ah, 0x02
    xor bh, bh                       ; set bh = 0x00 for graphics modes
    xor dx, dx                       ; set cursor to upper left corner (dh = row = 0, dl = column = 0)
    int 0x10

print_quote:
    mov ah, 0x0e
    xor bh, bh
    mov bl, COLOR_GREEN_ON_BLACK
    mov si, quote                    ; load address of quote
print_loop:
    lodsb                            ; load byte from si to al (character from quote)
    test al, al                      ; check if we reached the end of the string
    jz done                          ; printing done
    int 0x10
    jmp print_loop                   ; print next char
done:
    jmp $                            ; infinite loop