Focal Plane Electronics for TESS
--------------------------------------------

© 2015 John P. Doty &amp; Matthew P. Wampler-Doty, Noqsi Aerospace Ltd.

[![Build Status](https://travis-ci.org/TESScience/FPE.svg?branch=master)](https://travis-ci.org/TESScience/FPE)

This project contains the design specification for the focal plane electronics for the [Transiting Exoplanet Survey Satellite (TESS)](http://space.mit.edu/TESS/TESS/TESS_Overview.html).


Manual
----------

To build the TESS FPE manual, type:

```bash
make FPE/Documentation/AE.pdf
```

or

```bash
make manual
```

Testing
----------

To run the tests (which do sanity checks on the python module) type:

```bash
make test
```

Release
-----------

To make a release, first create a [git tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging) conforming to the following convention:

<center>*A.B.C.devD*</center>

Where:

  - *A* is the major revision number
  - *B* is the minor revision number
  - *C* is the review release number
  - *D* is the software release number

  **Hardware developers can safely ignore *D***

