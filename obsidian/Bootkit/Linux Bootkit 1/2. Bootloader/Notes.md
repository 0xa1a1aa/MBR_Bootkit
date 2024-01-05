
# BIOS memory map

https://wiki.osdev.org/Memory_Map_(x86)

1. Use the following interrupt https://wiki.osdev.org/Detecting_Memory_(x86)#BIOS_Function:_INT_0x15.2C_EAX_.3D_0xE820 to detect free memory
2. Check if the memory is big enough for the Bootkit
3. Load Bootkit to memory and pass control