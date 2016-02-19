#!/bin/bash

[ -d ./frames ] || mkdir frames
./obssim_unpack ./frames/ 192.168.100.2 7777 17754432
