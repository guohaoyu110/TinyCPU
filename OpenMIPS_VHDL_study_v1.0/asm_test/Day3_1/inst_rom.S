	.org 0x0
.global _start
   .set noat
_start:
   ori $1,$0,0x1100        # r1 = r0 | 0x1100 = 0x1100
   ori $1,$1,0x0020        # r1 = r1 | 0x0020 = 0x1120
   ori $1,$1,0x4400        # r1 = r1 | 0x4400 = 0x5520
   ori $1,$1,0x0044        # r1 = r1 | 0x0044 = 0x5564

