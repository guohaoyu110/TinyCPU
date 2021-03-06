   .org 0x0
   .set noat
   .set noreorder
   .set nomacro
   .global _start
_start:
   ori  $3,$0,0x8000
   sll  $3,16               # r3 = 0x80000000
   ori  $1,$0,0x0001        # r1 = 0x1                
   b    s1
   ori  $1,$0,0x0002        # r1 = 0x2
1:
   ori  $1,$0,0x1111
   ori  $1,$0,0x1100

   .org 0x20
s1:
   ori  $1,$0,0x0003        # r1 = 0x3          
   bal  s2
   div  $zero,$31,$1        # r31 = 0x2c, r1 =0x3
                            # HI = 0x2, LO = 0xe 
   ori  $1,$0,0x1100
   ori  $1,$0,0x1111
   bne  $1,$0,s3
   nop
   ori  $1,$0,0x1100
   ori  $1,$0,0x1111

   .org 0x50   
s2:
   ori  $1,$0,0x0004      # r1 = 0x4
   beq  $2,$2,s3           
   or   $1,$31,$0         # $1 = 0x2c
   ori  $1,$0,0x1111
   ori  $1,$0,0x1100
2:
   ori  $1,$0,0x0007      # r1 = 0x7
   ori  $1,$0,0x0008      # r1 = 0x8
   bgtz $1,s4
   ori  $1,$0,0x0009      # r1 = 0x9
   ori  $1,$0,0x1111
   ori  $1,$0,0x1100

   .org 0x80
s3:
   ori  $1,$0,0x0005      # r1 = 0x5            
   BGEZ $1,2b           
   ori  $1,$0,0x0006      # r1 = 0x6
   ori  $1,$0,0x1111
   ori  $1,$0,0x1100

   .org 0x100
s4:
   ori  $1,$0,0x000a      # r1 = 0xa              
   BGEZAL $3,s3
   or   $1,$0,$31         # r1 = 0x10c          
   ori  $1,$0,0x000b      # r1 = 0xb
   ori  $1,$0,0x000c      # r1 = 0xc
   ori  $1,$0,0x000d      # r1 = 0xd
   ori  $1,$0,0x000e      # r1 = 0xe
   bltz $3,s5
   ori  $1,$0,0x000f      # r1 = 0xf
   ori  $1,$0,0x1100


   .org 0x130
s5:
   ori  $1,$0,0x0010      # r1 = 0x10            
   blez $1,2b           
   ori  $1,$0,0x0011      # r1 = 0x11
   ori  $1,$0,0x0012      # r1 = 0x12
   ori  $1,$0,0x0013      # r1 = 0x13
   bltzal $3,s6
   or   $1,$0,$31         # r1 = 0x14c
   ori  $1,$0,0x1100


   .org 0x160
s6:
   ori $1,$0,0x0014       # r1 = 0x14
   nop
   
   
    
_loop:
   j _loop
   nop
