# Low level attacks:

https://github.com/rmusser01/Infosec_Reference/blob/master/Draft/bios_uefi.md

# Debugging real mode:

Bochs source code:
https://github.com/bochs-emu/Bochs

Bochs user manual:
https://bochs.sourceforge.io/cgi-bin/topper.pl?name=New+Bochs+Documentation&url=https://bochs.sourceforge.io/doc/docbook/user/index.html

Qemu:
https://gist.github.com/Theldus/4e1efc07ec13fb84fa10c2f3d054dccd

https://stackoverflow.com/questions/62513643/qemu-gdb-does-not-show-instructions-of-firmware

# Icelord BIOS Bootkit - Bootkit on Flash(chinese)

https://blog.csdn.net/icelord/article/details/1604884

# Hooking int 13 (chinese)

Translate with google chrome:
https://bbs.kanxue.com/thread-75604.htm

# Bookit analysis

https://www.cs.vu.nl/~herbertb/papers/bootkits_dimva2015.pdf

## TDSS Bootkit analysis

https://securelist.com/tdss-tdl-4/36339/

# OS memory
http://www.brokenthorn.com/Resources/OSDev17.html

Instead of hooking int 13 one could hook int 15 which is invoked once by the bootloader GRUB to get the available RAM size of the system
https://wiki.osdev.org/Detecting_Memory_(x86)

# Bochs config file "bochsrc"

**Sample file location:**
/usr/local/share/doc/bochs/bochsrc-sample.txt

Create a disk image:
https://bochs.sourceforge.io/doc/docbook/user/diskimagehowto.html

