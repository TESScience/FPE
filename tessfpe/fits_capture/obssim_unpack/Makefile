CC=gcc
CFLAGS=-g -Wall -Werror

CPP=g++
CPPFLAGS=-g --coverage -Wall -Werror -isystem ../gtest-1.7.0/include

all: obssim_unpack

check: unit_obssim_unpack obssim_unpack
	./unit_obssim_unpack

#./obssim_unpack 192.168.100.3 5555 ./frames/tst 17756160

clean:
	rm -rf obssim_unpack unit_obssim_unpack
	rm -rf *.dSYM
	rm -rf *.o *.gcda *.gcno *.gcov
	rm -rf test

obssim_unpack: obssim_udp_main.c obssim_unpack.c
	$(CC) $(CFLAGS) $^ -o $@

unit_obssim_unpack: unit_obssim_unpack.cpp obssim_unpack.c gtest-all.o
	$(CPP) $(CPPFLAGS) unit_obssim_unpack.cpp gtest-all.o -o $@ -lpthread

gtest-all.o:
	$(CPP) $(CPPFLAGS) \
	-I../gtest-1.7.0 \
	-c ../gtest-1.7.0/src/gtest-all.cc

gcov: check
	gcov --branch-counts --branch-probabilities unit_obssim_unpack.cpp
