The interrupt descriptor table (IDT) is a data structure used by the **x86 architecture** to implement an interrupt vector table. The IDT is used by the processor to determine the correct response to interrupts and exceptions.

The IDT consists of 256 interrupt vectors–the first 32 (0–31 or 0x00–0x1F) of which are used for processor exceptions.

**In real mode, the interrupt table is called IVT (interrupt vector table).** Up to the 80286, the IVT always resided at the same location in memory, ranging from 0x0000 to 0x03ff, and consisted of 256 far pointers. Hardware interrupts may be mapped to any of the vectors by way of a programmable interrupt controller. On the 80286 and later, the size and locations of the IVT can be changed in the same way as it is done with the IDT (Interrupt descriptor table) in protected mode (i.e., via the LIDT (Load Interrupt Descriptor Table Register) instruction) though it does not change the format of it.

After the UEFI boot process, control is handed over to the operating system. The operating system, in turn, initializes the Interrupt Descriptor Table (IDT) for protected mode operation.
The OS populates the IDT with appropriate descriptors, pointing to the location of interrupt service routines within the kernel.

	In systems using the legacy BIOS (Basic Input/Output System), the BIOS is responsible for setting up the IVT during the boot process.

**Setup:**
* The **LIDT** instruction is typically used during the initialization of the operating system kernel.
- The operating system sets up the IDT with descriptors for various interrupts and exceptions.
- When the IDT is ready, the LIDT instruction is used to load the base address and limit into the IDT register.
- Loading the IDT using LIDT enables the processor to locate the appropriate interrupt or exception handler when an interrupt occurs.