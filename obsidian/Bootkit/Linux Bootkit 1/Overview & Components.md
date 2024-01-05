# 1. Dropper

Tasks:
1. Check if OS environment is suitable (if not abort installation)
2. Download bootkit kernel module
3. Relocate original MBR
4. Write malicious MBR Bootloader
5. Install Kernel Module (and pass info like orig. MBR location for uninstallation)

# 2. MBR Bootloader

Tasks:
1. Load and execute Bootkit

# 3. Bootkit

Tasks:
1. Install hooks (to intercept OS bootup and load Bootkit Kernel Module in the process)
2. Load and execute original MBR

# 4. Bootkit Kernel Module

Tasks:
1. Hide own existence
2. (Optional) Hide malicious MBR by hooking low level disk access routines
3. Be a bootkit :)
4. (Optional) Uninstall bootkit