Retrieve MBR from disk (first sector - 512 bytes - from disk):
```SHELL
sudo dd if=/dev/sda of=mbr.bin bs=512 count=1
```

Disassemble MBR (set base address to 0x7c00, which is where the MBR will be loaded by the BIOS):
```SHELL
ndisasm -o 0x7c00 -b 16 mbr.bin > mbr16.as
```


```
00007C00  EB63              jmp short 0x7c65
00007C02  90                nop
00007C03  108ED0BC          adc [bp-0x4330],cl
00007C07  00B0B800          add [bx+si+0xb8],dh
00007C0B  008ED88E          add [bp-0x7128],cl
00007C0F  C0FBBE            sar bl,byte 0xbe
00007C12  007CBF            add [si-0x41],bh
00007C15  0006B900          add [0xb9],al
00007C19  02F3              add dh,bl
00007C1B  A4                movsb
00007C1C  EA21060000        jmp 0x0:0x621
00007C21  BEBE07            mov si,0x7be
00007C24  3804              cmp [si],al
00007C26  750B              jnz 0x7c33
00007C28  83C610            add si,byte +0x10
00007C2B  81FEFE07          cmp si,0x7fe
00007C2F  75F3              jnz 0x7c24
00007C31  EB16              jmp short 0x7c49
00007C33  B402              mov ah,0x2
00007C35  B001              mov al,0x1
00007C37  BB007C            mov bx,0x7c00
00007C3A  B280              mov dl,0x80
00007C3C  8A7401            mov dh,[si+0x1]
00007C3F  8B4C02            mov cx,[si+0x2]
00007C42  CD13              int 0x13
00007C44  EA007C0000        jmp 0x0:0x7c00
00007C49  EBFE              jmp short 0x7c49
00007C4B  0000              add [bx+si],al
00007C4D  0000              add [bx+si],al
00007C4F  0000              add [bx+si],al
00007C51  0000              add [bx+si],al
00007C53  0000              add [bx+si],al
00007C55  0000              add [bx+si],al
00007C57  0000              add [bx+si],al
00007C59  0000              add [bx+si],al
00007C5B  800100            add byte [bx+di],0x0
00007C5E  0000              add [bx+si],al
00007C60  0000              add [bx+si],al
00007C62  0000              add [bx+si],al
00007C64  FF                db 0xff
00007C65  FA                cli
00007C66  90                nop
00007C67  90                nop
00007C68  F6C280            test dl,0x80
00007C6B  7405              jz 0x7c72
00007C6D  F6C270            test dl,0x70
00007C70  7402              jz 0x7c74
00007C72  B280              mov dl,0x80
00007C74  EA797C0000        jmp 0x0:0x7c79
00007C79  31C0              xor ax,ax
00007C7B  8ED8              mov ds,ax
00007C7D  8ED0              mov ss,ax
00007C7F  BC0020            mov sp,0x2000
00007C82  FB                sti
00007C83  A0647C            mov al,[0x7c64]
00007C86  3CFF              cmp al,0xff
00007C88  7402              jz 0x7c8c
00007C8A  88C2              mov dl,al
00007C8C  52                push dx
00007C8D  BE807D            mov si,0x7d80
00007C90  E81701            call 0x7daa
00007C93  BE057C            mov si,0x7c05
00007C96  B441              mov ah,0x41
00007C98  BBAA55            mov bx,0x55aa
00007C9B  CD13              int 0x13
00007C9D  5A                pop dx
00007C9E  52                push dx
00007C9F  723D              jc 0x7cde
00007CA1  81FB55AA          cmp bx,0xaa55
00007CA5  7537              jnz 0x7cde
00007CA7  83E101            and cx,byte +0x1
00007CAA  7432              jz 0x7cde
00007CAC  31C0              xor ax,ax
00007CAE  894404            mov [si+0x4],ax
00007CB1  40                inc ax
00007CB2  8844FF            mov [si-0x1],al
00007CB5  894402            mov [si+0x2],ax
00007CB8  C7041000          mov word [si],0x10
00007CBC  668B1E5C7C        mov ebx,[0x7c5c]
00007CC1  66895C08          mov [si+0x8],ebx
00007CC5  668B1E607C        mov ebx,[0x7c60]
00007CCA  66895C0C          mov [si+0xc],ebx
00007CCE  C744060070        mov word [si+0x6],0x7000
00007CD3  B442              mov ah,0x42
00007CD5  CD13              int 0x13
00007CD7  7205              jc 0x7cde
00007CD9  BB0070            mov bx,0x7000
00007CDC  EB76              jmp short 0x7d54
00007CDE  B408              mov ah,0x8
00007CE0  CD13              int 0x13
00007CE2  730D              jnc 0x7cf1
00007CE4  5A                pop dx
00007CE5  84D2              test dl,dl
00007CE7  0F83D800          jnc near 0x7dc3
00007CEB  BE8B7D            mov si,0x7d8b
00007CEE  E98200            jmp 0x7d73
00007CF1  660FB6C6          movzx eax,dh
00007CF5  8864FF            mov [si-0x1],ah
00007CF8  40                inc ax
00007CF9  66894404          mov [si+0x4],eax
00007CFD  0FB6D1            movzx dx,cl
00007D00  C1E202            shl dx,byte 0x2
00007D03  88E8              mov al,ch
00007D05  88F4              mov ah,dh
00007D07  40                inc ax
00007D08  894408            mov [si+0x8],ax
00007D0B  0FB6C2            movzx ax,dl
00007D0E  C0E802            shr al,byte 0x2
00007D11  668904            mov [si],eax
00007D14  66A1607C          mov eax,[0x7c60]
00007D18  6609C0            or eax,eax
00007D1B  754E              jnz 0x7d6b
00007D1D  66A15C7C          mov eax,[0x7c5c]
00007D21  6631D2            xor edx,edx
00007D24  66F734            div dword [si]
00007D27  88D1              mov cl,dl
00007D29  31D2              xor dx,dx
00007D2B  66F77404          div dword [si+0x4]
00007D2F  3B4408            cmp ax,[si+0x8]
00007D32  7D37              jnl 0x7d6b
00007D34  FEC1              inc cl
00007D36  88C5              mov ch,al
00007D38  30C0              xor al,al
00007D3A  C1E802            shr ax,byte 0x2
00007D3D  08C1              or cl,al
00007D3F  88D0              mov al,dl
00007D41  5A                pop dx
00007D42  88C6              mov dh,al
00007D44  BB0070            mov bx,0x7000
00007D47  8EC3              mov es,bx
00007D49  31DB              xor bx,bx
00007D4B  B80102            mov ax,0x201
00007D4E  CD13              int 0x13
00007D50  721E              jc 0x7d70
00007D52  8CC3              mov bx,es
00007D54  60                pusha
00007D55  1E                push ds
00007D56  B90001            mov cx,0x100
00007D59  8EDB              mov ds,bx
00007D5B  31F6              xor si,si
00007D5D  BF0080            mov di,0x8000
00007D60  8EC6              mov es,si
00007D62  FC                cld
00007D63  F3A5              rep movsw
00007D65  1F                pop ds
00007D66  61                popa
00007D67  FF265A7C          jmp [0x7c5a]
00007D6B  BE867D            mov si,0x7d86
00007D6E  EB03              jmp short 0x7d73
00007D70  BE957D            mov si,0x7d95
00007D73  E83400            call 0x7daa
00007D76  BE9A7D            mov si,0x7d9a
00007D79  E82E00            call 0x7daa
00007D7C  CD18              int 0x18
00007D7E  EBFE              jmp short 0x7d7e
00007D80  47                inc di
00007D81  52                push dx
00007D82  55                push bp
00007D83  42                inc dx
00007D84  2000              and [bx+si],al
00007D86  47                inc di
00007D87  656F              gs outsw
00007D89  6D                insw
00007D8A  004861            add [bx+si+0x61],cl
00007D8D  7264              jc 0x7df3
00007D8F  204469            and [si+0x69],al
00007D92  736B              jnc 0x7dff
00007D94  005265            add [bp+si+0x65],dl
00007D97  61                popa
00007D98  640020            add [fs:bx+si],ah
00007D9B  45                inc bp
00007D9C  7272              jc 0x7e10
00007D9E  6F                outsw
00007D9F  720D              jc 0x7dae
00007DA1  0A00              or al,[bx+si]
00007DA3  BB0100            mov bx,0x1
00007DA6  B40E              mov ah,0xe
00007DA8  CD10              int 0x10
00007DAA  AC                lodsb
00007DAB  3C00              cmp al,0x0
00007DAD  75F4              jnz 0x7da3
00007DAF  C3                ret
00007DB0  0000              add [bx+si],al
00007DB2  0000              add [bx+si],al
00007DB4  0000              add [bx+si],al
00007DB6  0000              add [bx+si],al
00007DB8  626B2D            bound bp,[bp+di+0x2d]
00007DBB  1D0000            sbb ax,0x0
00007DBE  800401            add byte [si],0x1
00007DC1  0483              add al,0x83
00007DC3  FEC2              inc dl
00007DC5  FF00              inc word [bx+si]
00007DC7  0800              or [bx+si],al
00007DC9  00EE              add dh,ch
00007DCB  F7020A00          test word [bp+si],0xa
00007DCF  0000              add [bx+si],al
00007DD1  0000              add [bx+si],al
00007DD3  0000              add [bx+si],al
00007DD5  0000              add [bx+si],al
00007DD7  0000              add [bx+si],al
00007DD9  0000              add [bx+si],al
00007DDB  0000              add [bx+si],al
00007DDD  0000              add [bx+si],al
00007DDF  0000              add [bx+si],al
00007DE1  0000              add [bx+si],al
00007DE3  0000              add [bx+si],al
00007DE5  0000              add [bx+si],al
00007DE7  0000              add [bx+si],al
00007DE9  0000              add [bx+si],al
00007DEB  0000              add [bx+si],al
00007DED  0000              add [bx+si],al
00007DEF  0000              add [bx+si],al
00007DF1  0000              add [bx+si],al
00007DF3  0000              add [bx+si],al
00007DF5  0000              add [bx+si],al
00007DF7  0000              add [bx+si],al
00007DF9  0000              add [bx+si],al
00007DFB  0000              add [bx+si],al
00007DFD  0055AA            add [di-0x56],dl
```

# Breakdown

This is the disassembled code for the Master Boot Record (MBR) of a bootable sector. Let's break it down:

```assembly
00007C00  EB63              jmp short 0x7c65
```
This is a jump instruction (unconditional) that skips the next instructions.

```assembly
00007C02  90                nop
```
No-operation instruction, just padding.

```assembly
00007C03  108ED0BC          adc [bp-0x4330],cl
```
Add with carry instruction. This instruction adds the contents of the CL register to the byte at the address calculated by subtracting 0x4330 from the value in the BP register.

```assembly
00007C07  00B0B800          add [bx+si+0xb8],dh
```
Add instruction. It adds the contents of the DH register to the byte at the address calculated by adding 0xb8 to the values in the BX and SI registers.

The code goes on with a series of instructions, including jumps, moves, and comparisons. The key part of the code is:

```assembly
00007C33  B402              mov ah,0x2
00007C35  B001              mov al,0x1
00007C37  BB007C            mov bx,0x7c00
00007C3A  B280              mov dl,0x80
00007C3C  8A7401            mov dh,[si+0x1]
00007C3F  8B4C02            mov cx,[si+0x2]
00007C42  CD13              int 0x13
```
This part of the code sets up the registers AH, AL, BX, DL, DH, and CX and then calls the BIOS interrupt 0x13, which is often used for disk operations. This specific combination of registers and interrupt is commonly used for reading sectors from the disk.

```assembly
00007C44  EA007C0000        jmp 0x0:0x7c00
```
An indirect far jump to the address 0x0000:0x7c00.

```assembly
00007C49  EBFE              jmp short 0x7c49
```
An infinite loop (jumping to itself), effectively halting further execution.

This MBR code seems to be a simple bootloader that loads the first sector from the disk into memory at address 0x7C00 and then jumps to that address to continue execution. The disk read and jump are conditioned on certain checks, and the code has some basic error checking and recovery mechanisms.