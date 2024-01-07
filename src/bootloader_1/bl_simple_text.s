BITS 16                              ; Specify 16-bit mode. x86 processors start in real mode to maintain compatibility with the legacy architecture
ORG 0x7c00                           ; Set the origin address to 0x7c00. This is where the MBR is loaded by the BIOS

jmp start                            ; Jump over the "data section" (i.e. quote)

quote db "Welcome to the real world. We're going to need guns... lots of guns.", 0
COLOR_GREEN_ON_BLACK EQU 0x0a

start:
;
; BIOS call "INT 0x10, FUNCTION 0x06" to clear the window (https://www.ctyme.com/intr/rb-0096.htm)
; Arguments:
;   ah = 0x06
;   al = 0x00                        (clear entire window)
;   bh = COLOR_GREEN_ON_BLACK        (attribute used to write blank lines at bottom of window)
;   ch,cl = 0,0                      (row,column of window's upper left corner)
;   dh,dl = 0xff,0xff                (row,column of window's lower right corner)
; Returns:
;   Nothing
;
clear_window:  
    mov ah, 0x06
    xor al, al                       ; set al = 0x00 for entire window
    xor cx, cx                       ; set upper left corner (ch = row = 0, cl = column = 0)
    mov dx, 0xffff
    mov bh, COLOR_GREEN_ON_BLACK
    int 0x10

;
; BIOS call "INT 0x10, FUNCTION 0x02" to set the cursor position (https://www.ctyme.com/intr/rb-0087.htm)
; Arguments:
;   ah = 0x02
;   bh = 0                           (0 for graphics modes)
;   dh,dl = 0,0                      (row,column)
; Returns:
;   Nothing
;
reset_cursor:  
    mov ah, 0x02
    xor bh, bh                       ; set bh = 0x00 for graphics modes
    xor dx, dx                       ; set cursor to upper left corner (dh = row = 0, dl = column = 0)
    int 0x10

;
; BIOS call "INT 0x10, FUNCTION 0x0e" teletype output (https://www.ctyme.com/intr/rb-0106.htm)
; Arguments:
;   ah = 0x0e
;   al =                             (character to write)
;   bh = 0x00                        (page number)
;   bl = COLOR_GREEN_ON_BLACK        (foreground color)
; Returns:
;   Nothing
;
print_quote:
    mov ah, 0x0e
    xor bh, bh
    mov bl, COLOR_GREEN_ON_BLACK
    mov si, quote                    ; load address of quote
print_loop:
    lodsb                            ; load byte from si to al (character from quote)
    test al, al                      ; check if we reached the end of the string
    jz stop                          ; printing done
    int 0x10
    jmp print_loop                   ; print next char

;
; Stop (infinite loop)
;
stop:
    jmp $                            ; Jump to the current instruction

times 510-($-$$) db 0                ; Fill the rest of the sector with zeros:
                                     ; - The "times" directive repeats a given assembly code or data block a specific number of times.
                                     ; - $ represents the current position in the assembly code.
                                     ; - $$ represents the beginning of the code.
                                     ; => 510-($-$$) calculates the number of bytes remaining, and fills them with zeros
dw 0xAA55                            ; Boot signature (end of the MBR)