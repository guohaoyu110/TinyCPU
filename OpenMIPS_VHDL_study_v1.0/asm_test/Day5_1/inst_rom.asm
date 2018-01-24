
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3401ffff 	li	at,0xffff
   4:	00010c00 	sll	at,at,0x10
   8:	3421fffb 	ori	at,at,0xfffb
   c:	34020006 	li	v0,0x6
  10:	70221802 	mul	v1,at,v0
  14:	00220018 	mult	at,v0
  18:	00220019 	multu	at,v0
Disassembly of section .reginfo:

00000000 <_ram_end-0x20>:
   0:	0000000e 	0xe
	...
