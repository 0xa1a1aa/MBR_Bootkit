# EQU

The `EQU` (equivalent) directive in assembly language is used to define a symbolic constant or alias.

Example:
```assembly
COLOR_WHITE_ON_BLACK EQU 0x0F  ; Define a constant with the value 0x0F
```

# BITS

This directive informs the assembler that the assembly code should be processed for a 16-bit target architecture.

Example:
```assembly
BITS 16
```

# ORG

This directive specifies the origin address where the program is expected to be loaded in memory.

Example:
```assembly
ORG 0x7c00  ; Set the origin address to 0x7c00
```
