
AS = arm-elf-as
CC = arm-elf-gcc

CFLAGS  = -g -O -I../../include -mcpu=arm7tdmi -msoft-float -Wall

LIBDIR = ../../lib
BOOT= $(LIBDIR)/boot.o
LDFILE = sam7x256-exec-flash.ld 
ASFLAGS = -mcpu=arm7tdmi -msoft-float -gstabs
LDFLAGS = -msoft-float -nostartfiles -Lgcc -L$(LIBDIR) 
LIBS = -llse-arm -lm

UPLOAD =	openocd -d0 --file=openocd.cfg \
		-c 'init;init;arm7_9 fast_memory_access enable' \
		-c 'halt;flash write_image $< 0x100000;soft_reset_halt;resume' \
		-c 'shutdown'

# This rule strips comments and blank lines from LSE source.

%.txt:%.lse
	sed -e '/^#/d' -e '/^$$/d' $< >$@

TESSTUFF = lse_seq.o sequencer.o

upload_c80: TESSc80.elf
	$(UPLOAD)

TESSc80.elf:  $(LDFILE) $(TESSTUFF) TESScamera.o app_lse_c80.o stamp.o
	$(CC) -T$(LDFILE) $(LDFLAGS) -o $@ $(BOOT) TESScamera.o \
	$(TESSTUFF) $(LIBS) app_lse_c80.o stamp.o
	rm stamp.lse

app_lse_c80.o : c80.txt

c80.txt : bitfields.lse pio.lse LEDs.lse wink.lse AD53bb.lse HKADC.lse
	sed -e '/^#/d' -e '/^$$/d' $^ >$@

# The version that runs on the EK board
# For now, use the c20 version of LSE code

upload_ek: TESSek.elf
	$(UPLOAD)

TESSek.elf:  $(LDFILE) $(TESSTUFF) TESSek.o app_lse_ek.o stamp.o
	$(CC) -T$(LDFILE) $(LDFLAGS) -o $@ $(BOOT)  TESSek.o \
	$(TESSTUFF) $(LIBS) app_lse_ek.o stamp.o
	rm stamp.lse

TESSek.o : TESScamera.c
	$(CC) $(CFLAGS) -c -DEKBOARD=1 -o $@ TESScamera.c

app_lse_ek.o : ek.txt

# The version for CCID-20 with TESS electronics

upload_c20 : TESSc20.elf
	$(UPLOAD)

TESSc20.elf:  $(LDFILE) $(TESSTUFF) TESScamera.o app_lse_c20.o stamp.o
	$(CC) -T$(LDFILE) $(LDFLAGS) -o $@ $(BOOT) TESScamera.o \
	$(TESSTUFF) $(LIBS) app_lse_c20.o stamp.o
	rm stamp.lse

app_lse_c20.o : c20.txt

stamp.lse :
	echo -n '" ' >stamp.lse
	echo -n `git log -1 --format="%cd %h"` >>stamp.lse
	echo '" ,t nl' >>stamp.lse

stamp.o : stamp.txt

app_lse.o : mpu.txt

clean:
	rm -f *.o *.elf c20.txt c80.txt ek.txt stamp.txt
