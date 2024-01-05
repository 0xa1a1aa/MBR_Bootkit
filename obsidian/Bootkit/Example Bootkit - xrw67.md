Components:
- Dropper
- Bootloader
- Bootkit

**Dropper**
- Write the "bootkit" file to disk
- Store the first 80 bytes of the original MBR in the "bootkit" file
- Write the malicious MBR (size 80 bytes) to disk

**Bootloader**
- Load "bootkit" into RAM and execute it

**Bootkit**
- Restore the original MBR in RAM by overwriting the malicious MBR (first 80 bytes) with the saved 80 bytes from the original MBR.
- Install hooks
- Execute original MBR