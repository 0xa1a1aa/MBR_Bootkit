1. Disassemble our bootloader:
```SHELL
ndisasm -b 16 -o 0x7c00 bootloader.bin 
```

```assembly
00007C00  EB45              jmp short 0x7c47
00007C02  57                push di
00007C03  656C              gs insb
00007C05  636F6D            arpl [bx+0x6d],bp
00007C08  6520746F          and [gs:si+0x6f],dh
00007C0C  207468            and [si+0x68],dh
00007C0F  65207265          and [gs:bp+si+0x65],dh
00007C13  61                popa
00007C14  6C                insb
00007C15  20776F            and [bx+0x6f],dh
00007C18  726C              jc 0x7c86
00007C1A  642E205765        and [cs:bx+0x65],dl
00007C1F  27                daa
00007C20  7265              jc 0x7c87
00007C22  20676F            and [bx+0x6f],ah
00007C25  696E672074        imul bp,[bp+0x67],word 0x7420
00007C2A  6F                outsw
00007C2B  206E65            and [bp+0x65],ch
00007C2E  6564206775        and [fs:bx+0x75],ah
00007C33  6E                outsb
00007C34  732E              jnc 0x7c64
00007C36  2E2E206C6F        and [cs:si+0x6f],ch
00007C3B  7473              jz 0x7cb0
00007C3D  206F66            and [bx+0x66],ch
00007C40  206775            and [bx+0x75],ah
00007C43  6E                outsb
00007C44  732E              jnc 0x7c74
00007C46  0031              add [bx+di],dh
00007C48  C9                leave
00007C49  B40E              mov ah,0xe
00007C4B  A0027C            mov al,[0x7c02]
00007C4E  84C0              test al,al
00007C50  7404              jz 0x7c56
00007C52  CD10              int 0x10
00007C54  EBF5              jmp short 0x7c4b
00007C56  EBFE              jmp short 0x7c56
00007C58  0000              add [bx+si],al
[...]
00007DFC  0000              add [bx+si],al
00007DFE  55                push bp
00007DFF  AA                stosb
```

The first instruction `jmp short 0x7c47` is a jump to the address 0x7c47. However, when we look at the disassembly there is no such address:
```
[...]
00007C46  0031              add [bx+di],dh
00007C48  C9                leave
[...]
```

Address 0x7c47 is in the middle of the disassembled instruction at address 0x7c46 (byte 31).
Because NASM didn't know that the bytes after the very first instruction are data (our quote) and not actual code, it did disassemble the data bytes as code and thats why the rest of the following bytes were also disassembled incorrectly.

2. Lets open the man page of **ndisasm** (man ndisasm) and check whether we can skip the first 0x47 bytes, including the data bytes, and disassemble the main section that comes after that.

In the manual we can find the following entry: 
*-e hdrlen
	   Specifies a number of bytes to discard from the beginning of the file before starting disassembly. This does not count towards the calculation of the disassembly offset: the first disassembled instruction will be shown
	   starting at the given load address.*

Lets use that in the next attempt to disassemble the bootloader: 
```SHELL
ndisasm -b 16 -o 0x7c00 -e 0x47 bootloader.bin 
```

Alright, this looks better now. The code from the main section is disassembled correctly (note the byte 0x31 in the first instruction. It is the byte in the middle of the disassembled instruction from the previous round):
```assembly
00007C00  31C9              xor cx,cx
00007C02  B40E              mov ah,0xe
00007C04  A0027C            mov al,[0x7c02]
00007C07  84C0              test al,al
00007C09  7404              jz 0x7c0f
00007C0B  CD10              int 0x10
00007C0D  EBF5              jmp short 0x7c04
00007C0F  EBFE              jmp short 0x7c0f
00007C11  0000              add [bx+si],al
[...]
00007DB5  0000              add [bx+si],al
00007DB7  55                push bp
00007DB8  AA                stosb
```

Its still not 100% correct though, because we can see that at the base address 0x7c00 is our first instruction of the main section. However, this is not accurate, as we now there is more bytes beforehand (jmp instruction + data section).

3. So lets update the offset argument by adding the value 0x47 (number of skipped bytes) to the base address 0x7c00, resulting in 0x7c47:
```SHELL
ndisasm -b 16 -o 0x7c47 -e 0x47 bootloader.bin 
```

The output now shows the correct addresses and instructions:
```assembly
00007C47  31C9              xor cx,cx
00007C49  B40E              mov ah,0xe
00007C4B  A0027C            mov al,[0x7c02]
00007C4E  84C0              test al,al
00007C50  7404              jz 0x7c56
00007C52  CD10              int 0x10
00007C54  EBF5              jmp short 0x7c4b
00007C56  EBFE              jmp short 0x7c56
00007C58  0000              add [bx+si],al
[...]
00007DFC  0000              add [bx+si],al
00007DFE  55                push bp
00007DFF  AA                stosb
```