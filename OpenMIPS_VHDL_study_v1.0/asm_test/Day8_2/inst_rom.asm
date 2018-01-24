
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3403eeff 	li	v1,0xeeff
   4:	a0030003 	sb	v1,3(zero)
   8:	00031a02 	srl	v1,v1,0x8
   c:	a0030002 	sb	v1,2(zero)
  10:	3403ccdd 	li	v1,0xccdd
  14:	a0030001 	sb	v1,1(zero)
  18:	00031a02 	srl	v1,v1,0x8
  1c:	a0030000 	sb	v1,0(zero)
  20:	80010003 	lb	at,3(zero)
  24:	04200002 	bltz	at,30 <s1>
  28:	80010002 	lb	at,2(zero)
  2c:	00010c00 	sll	at,at,0x10

00000030 <s1>:
  30:	80010001 	lb	at,1(zero)
  34:	04200002 	bltz	at,40 <s2>
  38:	a0030002 	sb	v1,2(zero)
  3c:	00200825 	move	at,at

00000040 <s2>:
  40:	80010002 	lb	at,2(zero)

00000044 <_loop>:
  44:	08000011 	j	44 <_loop>
  48:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x50>:
   0:	0000000a 	movz	zero,zero,zero
	...
