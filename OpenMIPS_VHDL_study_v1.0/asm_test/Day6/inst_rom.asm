
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3c010000 	lui	at,0x0
   4:	3c02ffff 	lui	v0,0xffff
   8:	3c030505 	lui	v1,0x505
   c:	3c040000 	lui	a0,0x0
  10:	0041200a 	movz	a0,v0,at
  14:	0061200b 	movn	a0,v1,at
  18:	0062200b 	movn	a0,v1,v0
  1c:	00802825 	move	a1,a0
  20:	0043200a 	movz	a0,v0,v1
  24:	00802825 	move	a1,a0
  28:	00000011 	mthi	zero
  2c:	00200011 	mthi	at
  30:	00400011 	mthi	v0
  34:	00002010 	mfhi	a0
  38:	00000000 	nop
  3c:	00000040 	ssnop
  40:	00600013 	mtlo	v1
  44:	00002012 	mflo	a0
  48:	00002010 	mfhi	a0
  4c:	00002012 	mflo	a0
Disassembly of section .reginfo:

00000000 <_ram_end-0x50>:
   0:	0000003e 	0x3e
	...
