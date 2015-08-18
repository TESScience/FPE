Focal Plane Electronics for TESS
--------------------------------------------

© 2015 John P. Doty &amp; Matthew P. Wampler-Doty, Noqsi Aerospace Ltd.

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