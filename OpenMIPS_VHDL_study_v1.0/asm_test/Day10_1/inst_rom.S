   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0x100     # r1 = 0x100
   jr $1
   nop

   .org 0x40
   ori $1,$0,0x8000    # r1 = 0x00008000
   ori $1,$0,0x9000    # r1 = 0x00009000
   mfc0 $1,$14,0x0     # r1 = 0x0000010c
   addi $1,$1,0x4      # r1 = 0x00000110
   mtc0 $1,$14,0x0
   eret
   nop

   .org 0x100
   ori $1,$0,0x1000    # r1 = 0x1000
   sw  $1, 0x0100($0)  # [0x100] = 0x00001000
   mthi $1             # HI = 0x00001000
   syscall 0x50
   lw  $1, 0x0100($0)  # r1 = 0x00001000
   mfhi $2             # r2 = 0x00001000             
   ori $2,$0,0x5000    # r2 = 0x00005000

   ori $3,$0,0x1000    # r3 = 0x00001000
   ori $2,$0,0x2000    # r2 = 0x00002000
   mthi $2             # HI = 0x00002000
   syscall 0x50
   div $0,$2,$3        # HI = 0x0; Lo = 0x2
   j  _loop
   ori $2,$0,0x5000    # r2 = 0x00005000

_loop:
   j _loop
   nop
   
   
