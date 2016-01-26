# Tutorial for the tessfpe Python Module

The following is a tutorial for testing the Observatory Simulator with the `tessfpe` python module. This software can be found at:

[https://github.com/TESScience/FPE/](https://github.com/TESScience/FPE/)

## Installation

The only things that must be installed on the platform prior to using this software are:

1. A C/C++ compiler, such at gcc or llvm
2. Python 2.7
3. Python [virtualenv](https://virtualenv.readthedocs.org/en/latest/)
4. [GIT](https://git-scm.com/)
5. the [make](http://linux.die.net/man/1/make) utility

To install, run the following commands at command line:

```
# git clone https://github.com/TESScience/FPE.git
# make -C FPE install_testsuite
```

This will take some time, since `tessfpe` depends on [numpy](http://www.numpy.org/) and [pandas](http://pandas.pydata.org/) which requires compilation.

To use the software, type:

```
# source FPE/testsuite/venv/bin/activate
```

If you are using `tcsh`, type:

```
# . FPE/testsuite/venb/bin/activate.csh
```

## Quick Start

To run the test suite, having cloned the git repository into `FPE`, type:

```
# FPE/testsuite/testsuite.sh
```

## Usage

The following describes how to use the `tessfpe` python module in detail.

### Create an FPE Object

To get started, you will first need to create an FPE Object.

Suppose you wanted to name your object `fpe`, you would do this as follows:

```
#!/usr/bin/env python2.7
from tessfpe.dhu.fpe import FPE
fpe = FPE(1, FPE_Wrapper_version='6.1.5')
```

The first argument, `1`, specifies which FPE we are talking to.  The Observatory Simulator supports two FPE objects.

The second argument specifies the FPGA wrapper image version to load.

The tessfpe software will attempt to detect if the FPGA wrapper image is already loaded by performing a diagnostic, since it cannot be loaded twice.

You can load the FPGA wrapper image at the command line with the `load_wrapper` command:

```
# load_wrapper 6.1.5
```


### Reading the House Keeping Data

You can read the (analogue) housekeeping for the unit by typing the following commands:

```
#!/usr/bin/env python2.7
from tessfpe.dhu.fpe import FPE
from pprint import pprint
pprint(FPE(1).analogue_house_keeping_with_units)
```

### Starting and Stopping Frames

When an `FPE` object is created, frames are stopped as part of a sanity check.

You can start frames as follows:

```
#!/usr/bin/env python2.7
fpe = FPE(1)
fpe.cmd_start_frames()
```

Similarly, you can stop frames with this command:

```
fpe.cmd_stop_frames()
```
