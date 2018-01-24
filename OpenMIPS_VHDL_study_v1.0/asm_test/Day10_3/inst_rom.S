   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori $1,$0,0x100     # r1 = 0x100
   jr $1               # 跳转到0x100处
   nop

   .org 0x20           # 中断处理例程
   addi $2,$2,0x1      # r2加1
   ori $1,$0,100        
   mtc0 $1,$11,0x0     # 设置compare寄存器的值为100
   eret                # 中断返回
   nop

   .org 0x100
   ori $2,$0,0x0
   ori $1,$0,100
   mtc0 $1,$11,0x0     # 设置compare寄存器的值为100
   lui $1,0x1000
   ori $1,$1,0x401
   mtc0 $1,$12,0x0     # 存储0x10000401到status寄存器
                       # 设置IE为1，IM为00000100

_loop:
   j _loop
   nop
   
   
