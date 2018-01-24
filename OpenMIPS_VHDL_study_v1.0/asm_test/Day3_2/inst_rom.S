	.org 0x0
.global _start
   .set noat
_start:
   lui  $1,0x0101
   ori  $1,$1,0x0101
   ori  $2,$1,0x1100        # r2 = r1 | 0x1100 = 0x01011101
   or   $1,$1,$2            # r1 = r1 | r2 = 0x01011101
   andi $3,$1,0x00fe        # r3 = r1 & 0x00fe = 0x00000000
   and  $1,$3,$1            # r1 = r3 & r1 = 0x00000000
   xori $4,$1,0xff00        # r4 = r1 ^ 0xff00 = 0x0000ff00
   xor  $1,$4,$1            # r1 = r4 ^ r1 = 0x0000ff00
   nor  $1,$4,$1            # r1 = r4 ~^ r1 = 0xffff00ff   nor is "not or"
