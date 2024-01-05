https://wiki.osdev.org/Segmentation

https://en.wikipedia.org/wiki/X86_memory_segmentation
	Segmentation was introduced on the Intel 8086 in 1978 as a way to allow programs to address more than 64 KB (65,536 bytes) of memory. The Intel 80286 introduced a second version of segmentation in 1982 that added support for virtual memory and memory protection. At this point the original mode was renamed to real mode, and the new version was named protected mode. The x86-64 architecture, introduced in 2003, has largely dropped support for segmentation in 64-bit mode.

# Real Mode

In real mode or V86 mode, the size of a segment can range from 1 byte up to 65,536 bytes (using 16-bit offsets).

**The 16-bit segment selector in the segment register is interpreted as the most significant 16 bits of a linear 20-bit address**, called a segment address, of which the remaining four least significant bits are all zeros. **The segment address is always added to a 16-bit offset in the instruction to yield a linear address, which is the same as physical address in this mode.**

For instance, the segmented address 06EFh:1234h has a segment selector of 06EFh, representing a segment address of 06EF0h, to which the offset is added, yielding the linear address 06EF0h + 1234h = 08124h.

```
0000 0110 1110 1111 0000    Segment 16 bits (shifted left by 4 bits)
     0001 0010 0011 0100    Offset  16 bits
------------------------
0000 1000 0001 0010 0100    Address 20 bits (0x8124)
```

The effective 20-bit address space of real mode limits the addressable memory to 2^20 bytes, or 1,048,576 bytes (1 MB).

# Protected Mode

In Protected mode you use a logical address in the form A:B to address memory. As in Real Mode, A is the segment part and B is the offset within that segment. The registers in protected mode are limited to 32 bits. 32 bits can represent any integer between 0 and 4 GiB.

Because B can be any value between 0 and 4GiB our segments now have a maximum size of 4 GiB (Same reasoning as in real-mode).

In protected mode A is not an absolute value for the segment. In protected mode A is a selector. A selector represents an offset into a system table called the **Global Descriptor Table (GDT)**. The GDT contains a list of descriptors. Each of these descriptors contains information that describes the characteristics of a segment. 

The segment is described by its base address and limit. Remember in real-mode where the segment was a 64k area in memory? The only difference here is that the size of the segment isn't fixed. The base address supplied by the descriptor is the start of the segment, the limit is the maximum offset the processor will allow before producing an exception.


https://wiki.osdev.org/Segmentation:
So the range of physical addresses in our protected mode segment is:

**Segment Base -> Segment Base + Segment Limit**

Given a logical address A:B (Remember that A is a selector) we can determine the physical address it translates to using:

**Physical address = Segment Base (Found from the descriptor GDT\[A]) + B**
