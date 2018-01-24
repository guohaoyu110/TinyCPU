   .org 0x0
   .set noat
   .global _start
_start:
   ori  $1,$0,0xffff                  
   sll  $1,$1,16
   ori  $1,$1,0xfffb           # r1 = -5
   ori  $2,$0,6                # r2 = 6
   mul  $3,$1,$2               # r3 = -30 = 0xffffffe2
  
   mult $1,$2                  # hi = 0xffffffff
                               # lo = 0xffffffe2

   multu $1,$2                 # hi = 0x5
                               # lo = 0xffffffe2

