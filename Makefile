BOCHS	= bochs/
MV 		= mv
MAKE	= make
DEL     = rm
DD		= dd
CAT		= cat
SCRIPTS	= ./scripts/
DASM	= ndisasm
NASM  	= $(SCRIPTS)nasm
LD 		= $(SCRIPTS)ld
CC		= $(SCRIPTS)gcc
RUN 	= $(SCRIPTS)run
CPFAT12 = $(SCRIPTS)cpfat12

# Entry point of Orange'S
# It must have the same value with 'KernelEntryPointPhyAddr' in load.inc!
ENTRYPOINT	= 0x30400

# Offset of entry point in kernel file
# It depends on ENTRYPOINT
ENTRYOFFSET	=   0x400

ASMBFLAGS	= -I src/boot/include/
ASMKFLAGS	= -I src/include/ -f elf
CFLAGS		= -I src/include/ -c -fno-builtin -m32 -fno-stack-protector
LDFLAGS		= -s -Ttext $(ENTRYPOINT) -m elf_i386 
DASMFLAGS	= -u -o $(ENTRYPOINT) -e $(ENTRYOFFSET)

# This Program
ORANGESBOOT	= src/boot/boot.bin src/boot/loader.bin
ORANGESKERNEL	= kernel.bin
OBJS		= src/kernel/kernel.o src/kernel/start.o src/lib/kliba.o \
		src/lib/string.o src/kernel/i8259.o src/kernel/global.o \
		src/kernel/protect.o src/lib/klib.o src/kernel/main.o src/kernel/clock.o \
		src/kernel/proc.o src/kernel/syscall.o
DASMOUTPUT	= src/kernel.bin.asm

IMG:=a.img

# All Phony Targets
.PHONY : everything final image clean realclean disasm all buildimg

# Default starting position
everything : $(ORANGESBOOT) $(ORANGESKERNEL)

all : realclean everything

final : all clean

image : final buildimg

clean :
	$(DEL) -f $(OBJS)

realclean :
	$(DEL) -f $(OBJS) $(ORANGESBOOT) $(ORANGESKERNEL)

disasm :
	$(DASM) $(DASMFLAGS) $(ORANGESKERNEL) > $(DASMOUTPUT)

buildimg : $(ORANGESBOOT) $(ORANGESKERNEL)
	$(DD) if=/dev/zero of=$(BOCHS)$(IMG) bs=1 count=1474560
	$(DD) if=src/boot/boot.bin of=$(BOCHS)$(IMG) bs=512 count=1 conv=notrunc
	$(CPFAT12) $(BOCHS)$(IMG) src/boot/loader.bin
	$(CPFAT12) $(BOCHS)$(IMG) kernel.bin

run:	
	$(MAKE) buildimg
	$(MAKE) -C $(BOCHS)

src/boot/boot.bin : src/boot/boot.asm src/boot/include/load.inc src/boot/include/fat12hdr.inc
	$(NASM) $(ASMBFLAGS) -o $@ $<

src/boot/loader.bin : src/boot/loader.asm src/boot/include/load.inc \
			src/boot/include/fat12hdr.inc src/boot/include/pm.inc
	$(NASM) $(ASMBFLAGS) -o $@ $<

$(ORANGESKERNEL) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(ORANGESKERNEL) $(OBJS)

src/kernel/kernel.o : src/kernel/kernel.asm
	$(NASM) $(ASMKFLAGS) -o $@ $<

src/kernel/start.o : src/kernel/start.c src/include/type.h src/include/const.h src/include/protect.h \
		src/include/proto.h src/include/string.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/i8259.o : src/kernel/i8259.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/global.o : src/kernel/global.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/protect.o : src/kernel/protect.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/lib/klib.o : src/lib/klib.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/clock.o : src/kernel/clock.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/proc.o : src/kernel/proc.c src/include/type.h src/include/const.h src/include/protect.h \
			src/include/proto.h src/include/proc.h
	$(CC) $(CFLAGS) -o $@ $<

src/kernel/syscall.o : src/kernel/syscall.asm
	$(NASM) $(ASMKFLAGS) -o $@ $<

src/lib/kliba.o : src/lib/kliba.asm
	$(NASM) $(ASMKFLAGS) -o $@ $<

src/lib/string.o : src/lib/string.asm
	$(NASM) $(ASMKFLAGS) -o $@ $<
