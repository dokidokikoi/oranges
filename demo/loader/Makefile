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

build : $(BOOT_BIN) $(LDR_BIN) $(KERNEL_BIN)
	$(DD) if=/dev/zero of=$(BOCHS)$(IMG) bs=1 count=1474560
	$(DD) if=$(BOOT_BIN) of=$(BOCHS)$(IMG) bs=512 count=1 conv=notrunc
	$(CPFAT12) $(BOCHS)$(IMG) $(LDR_BIN)
	$(CPFAT12) $(BOCHS)$(IMG) $(KERNEL_BIN)

run:	
	$(MAKE) build
	$(MAKE) -C $(BOCHS)

clean:
	-$(DEL) *.bin
	-$(DEL) *.lst

$(BOOT_BIN) : $(BOOT)
	nasm $< -o $@

$(LDR_BIN) : $(LDR)
	nasm $< -o $@

$(KERNEL_BIN) : $(KERNEL)
	nasm $< -o $@