
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
  24:	0023001b 	divu	zero,at,v1
  28:	00000810 	mfhi	at
  2c:	00000812 	mflo	at
  30:	80010003 	lb	at,3(zero)
  34:	00000000 	nop
  38:	30211202 	andi	at,at,0x1202
  3c:	3403aabb 	li	v1,0xaabb
  40:	a4030004 	sh	v1,4(zero)
  44:	94010004 	lhu	at,4(zero)
  48:	84010004 	lh	at,4(zero)
  4c:	34038899 	li	v1,0x8899
  50:	a4030006 	sh	v1,6(zero)
  54:	84010006 	lh	at,6(zero)
  58:	94010006 	lhu	at,6(zero)
  5c:	34034455 	li	v1,0x4455
  60:	00031c00 	sll	v1,v1,0x10
  64:	34636677 	ori	v1,v1,0x6677
  68:	ac030008 	sw	v1,8(zero)
  6c:	8c010008 	lw	at,8(zero)
  70:	88010005 	lwl	at,5(zero)
  74:	98010008 	lwr	at,8(zero)
  78:	b8010002 	swr	at,2(zero)
  7c:	a8010007 	swl	at,7(zero)
  80:	8c010000 	lw	at,0(zero)
  84:	8c010004 	lw	at,4(zero)
  88:	c0010008 	ll	at,8(zero)
  8c:	20210001 	addi	at,at,1
  90:	e0010008 	sc	at,8(zero)
  94:	8c210003 	lw	at,3(at)
  98:	8c010008 	lw	at,8(zero)

0000009c <_loop>:
  9c:	08000027 	j	9c <_loop>
  a0:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0xb0>:
   0:	0000000a 	movz	zero,zero,zero
	...
