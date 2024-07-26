BOCHS	= bochs/
MV 		= mv
MAKE	= make
DEL     = rm
DD		= dd
CAT		= cat
SCRIPTS	= ./scripts/
NASM  	= $(SCRIPTS)nasm
LD 		= $(SCRIPTS)ld
GCC		= $(SCRIPTS)gcc
RUN 	= $(SCRIPTS)run
CPFAT12 = $(SCRIPTS)cpfat12

BOOT:=boot.asm
LDR:=loader.asm
KERNEL:=kernel.asm
BOOT_BIN:=$(subst .asm,.bin,$(BOOT))
LDR_BIN:=$(subst .asm,.bin,$(LDR))
KERNEL_BIN:=$(subst .asm,.bin,$(KERNEL))

IMG:=a.img

# .PHONY : build

default:
	$(NASM) -f elf foo.asm -o foo.o
	$(GCC) -m32 -c bar.c -o bar.o
	$(LD) -m elf_i386 -s foo.o bar.o -o foobar
	$(RUN) ./foobar

clean:
	-$(DEL) *.bin
	-$(DEL) *.lst

$(BOOT_BIN) : $(BOOT)
	nasm $< -o $@

$(LDR_BIN) : $(LDR)
	nasm $< -o $@

$(KERNEL_BIN) : $(KERNEL)
	nasm $< -o $@