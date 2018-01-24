
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	34010100 	li	at,0x100
   4:	00200008 	jr	at
   8:	00000000 	nop
	...
  40:	34018000 	li	at,0x8000
  44:	34019000 	li	at,0x9000
  48:	40017000 	mfc0	at,c0_epc
  4c:	20210004 	addi	at,at,4
  50:	40817000 	mtc0	at,c0_epc
  54:	42000018 	eret
	...
 100:	34011000 	li	at,0x1000
 104:	ac010100 	sw	at,256(zero)
 108:	00200011 	mthi	at
 10c:	0000140c 	syscall	0x50
 110:	8c010100 	lw	at,256(zero)
 114:	00001010 	mfhi	v0
 118:	34025000 	li	v0,0x5000
 11c:	34031000 	li	v1,0x1000
 120:	34022000 	li	v0,0x2000
 124:	00400011 	mthi	v0
 128:	0000140c 	syscall	0x50
 12c:	0043001a 	div	zero,v0,v1
 130:	0800004e 	j	138 <_loop>
 134:	34025000 	li	v0,0x5000

00000138 <_loop>:
 138:	0800004e 	j	138 <_loop>
 13c:	00000000 	nop
Disassembly of section .reginfo:

00000000 <_ram_end-0x140>:
   0:	0000000e 	0xe
	...
