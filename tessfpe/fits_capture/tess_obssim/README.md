Installation Requirements
------------------------

This program needs cfitsio to run

To create the executables:

```bash
make
```

Running
-------

## House Keeping Data Only

To read one frame of housekeeping data:

```bash
./readHK
```

To read *N* frames of housekeeping data:

```bash
./readHK -n N
```

## House Keeping Data *and* FITS files

To read the housekeeping data *and* write FITS files in the current working directory, type:

```bash
./tess_obssim
```

By convention, we put TESS FITS files that are to be saved for future evaluation in:

```bash
/opt/Data/TESS/FPEvvv/yyyyMMdd
```

Here `vvv` is the FPE version number (currently 6.1)
