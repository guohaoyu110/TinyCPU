   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori  $3,$0,0xeeff
   sb   $3,0x3($0)       # [0x3] = 0xff
   srl  $3,$3,8
   sb   $3,0x2($0)       # [0x2] = 0xee
   ori  $3,$0,0xccdd
   sb   $3,0x1($0)       # [0x1] = 0xdd
   srl  $3,$3,8
   sb   $3,0x0($0)       # [0x0] = 0xcc
   lb   $1,0x3($0)       # r1 = 0xffffffff
   bltz $1,s1
   lb   $1,0x2($0)       # r1 = 0xffffffee
   sll  $1,$1,0x10

s1:
   lb   $1,0x1($0)       # r1 = 0xffffffdd
   bltz $1,s2
   sb   $3,0x2($0)       # [0x2] = 0xcc
   or   $1,$1,$0

s2:
   lb   $1,0x2($0)       # r1 = 0xffffffcc
    
_loop:
   j _loop
   nop
