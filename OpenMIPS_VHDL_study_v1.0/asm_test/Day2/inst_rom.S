	.org 0x0
.global _start
   .set noat
_start:
   ori $1,$0,0x1100        # r1 = r0 | 0x1100 = 0x1100
   ori $2,$0,0x0020        # r2 = r0 | 0x0020 = 0x0020
   ori $3,$0,0xff00        # r3 = r0 | 0xff00 = 0xff00
   ori $4,$0,0xffff        # r4 = r0 | 0xffff = 0xffff

