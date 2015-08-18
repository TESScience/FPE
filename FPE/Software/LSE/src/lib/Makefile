
AS = arm-elf-as
CC = arm-elf-gcc
AR = arm-elf-ar
CFLAGS = -g -Wall -I../include

%.o : %.s
	$(AS) -o $@ $<

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

OBJS =  init_lse.o strings.o lse-arm.o primitives.o usart.o C_startup.o copy_static.o aic.o \
	irq_stack.o pit.o spi_driver.o spi_primitives.o math.o pulsar.o \
	pulsar_primitives.o ad53bb.o ad53_primitives.o cbuf.o async_usart.o \
	adc.o adc_primitives.o

all : boot.o liblse-arm.a

liblse-arm.a : $(OBJS)
	$(AR) rcs liblse-arm.a $(OBJS)

$(OBJS) : Makefile

init_lse.txt : init.lse Makefile
	sed -e '/^#/d' -e '/^$$/d' init.lse >init_lse.txt

init_lse.o : init_lse.txt Makefile

test : testmain.o liblse-arm.a
	$(CC)  testmain.o -o test -L. -llse-arm -lm

clean : 
	rm -f *.a *.o init_lse.txt test


