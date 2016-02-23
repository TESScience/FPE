Focal Plane Electronics for TESS
--------------------------------------------

© 2015 John P. Doty &amp; Matthew P. Wampler-Doty, Noqsi Aerospace Ltd.

[![Build Status](https://travis-ci.org/TESScience/FPE.svg?branch=master)](https://travis-ci.org/TESScience/FPE)

This project contains the design specification for the focal plane electronics for the [Transiting Exoplanet Survey Satellite (TESS)](http://space.mit.edu/TESS/TESS/TESS_Overview.html).


Documentation
----------

You can read the latest documentation on our GitHub wiki:

[https://github.com/TESScience/FPE/wiki](https://github.com/TESScience/FPE/wiki)

This includes software tutorials and engineering manuals.

Provided that you have LaTeX, gschem and spice installed, you can reproduce the engineer manual by typing:

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

  Releases must conform to the above specification, which is a subset of [PEP 440](https://www.python.org/dev/peps/pep-0440/), in order to be accepted by [pypi](https://pypi.python.org/pypi).  In the event that a tag *does not* conform to the above spec, it will not be possible to create a software release on pypi. 
