https://en.wikipedia.org/wiki/BIOS_color_attributes

A BIOS Color Attribute is an 8 bit value where **the low 4 bits represent the character color** and **the high 4 bits represent the background color**.

The name comes from the fact that these colors are used in BIOS interrupts, specifically INT 10h, the video interrupt. When writing text to the screen, a BIOS color attribute is used to designate the color to write the text in. For example, to print a white character with a black background, a color attribute of 0Fhex would be used. The high four bits are set to 0000bin, representing the background color, black. The low 4 bits, 1111bin, represent the foreground color, white.

https://stanislavs.org/helppc/int_10-9.html