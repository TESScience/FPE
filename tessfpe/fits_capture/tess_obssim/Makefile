VPATH=.:../obssim_unpack
CFLAGS=-g -Wall -Werror -O3 $(shell pkg-config --cflags cfitsio)
.PHONY: all clean

all: obssim2fits tess_obssim

INCS	= -I../obssim_unpack
LIBS	= -lpthread -lm -ldl $(shell pkg-config --libs cfitsio)

.c.o:
	${CC} ${CFLAGS} ${INCS} -c $< -o $@

clean:
	rm -rf *.o obssim2fits tess_obssim *~


obssim2fits: obssim2fits.o tess_utils.o tess_fits.o tess_notes.o gps.o 
	$(CC) $(CFLAGS) $^ -o $@ ${LIBS}

tess_obssim: tess_obssim.o obssim_unpack.o tess_housekeeping.o tess_guidestamps.o tess_utils.o tess_fits.o tess_notes.o gps.o nthi.o
	$(CC) $(CFLAGS) $^ -o $@ ${LIBS}


readHK: readHK.o  obssim_unpack.o tess_housekeeping.o gps.o
	$(CC) $(CFLAGS) $^ -o $@ ${LIBS}


test_housekeeping: test_housekeeping.o tess_housekeeping.o
	$(CC) $(CFLAGS) $^ -o $@ ${LIBS}
