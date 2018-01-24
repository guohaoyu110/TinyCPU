
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3c020404 	lui	v0,0x404
   4:	34420404 	ori	v0,v0,0x404
   8:	34070007 	li	a3,0x7
   c:	34050005 	li	a1,0x5
  10:	34080008 	li	t0,0x8
  14:	00021200 	sll	v0,v0,0x8
  18:	00e21004 	sllv	v0,v0,a3
  1c:	00021202 	srl	v0,v0,0x8
  20:	00a21006 	srlv	v0,v0,a1
  24:	000214c0 	sll	v0,v0,0x13
  28:	00021403 	sra	v0,v0,0x10
  2c:	01021007 	srav	v0,v0,t0
Disassembly of section .reginfo:

00000000 <_ram_end-0x30>:
   0:	000001a4 	0x1a4
	...
