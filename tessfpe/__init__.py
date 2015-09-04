#!/usr/bin/env python
"""
The `tessfpe` python module provides datastructures for managing
operating parameters and housekeeping channels for the TESS
Focal Plane Electronics (FPE).

Operating parameters and housekeeping channels are described in
Section 6 of the TESS FPE manual: 
https://raw.githubusercontent.com/TESScience/FPE/master/FPE/Documentation/FPE.pdf

This file exports two dictionaries:
    - `operating_parameters`
    - `housekeeping_channels`

Each of these dictionaries has labeled entries associated `high` and
`low` values, along with a `unit` and associated `address` values in memory.

>>> operating_parameters['ccd1_input_diode_high']
{'high': 15.0, 'low': 0.0, 'unit': 'V', 'address': 70}
>>> housekeeping_channels['ccd1_input_diode_high']
{'high': 16.5, 'low': -16.5, 'unit': 'V', 'address': 70}

This file also exports two lists:
    - `operating_parameter_memory_map`
    - `housekeeping_channel_memory_map`

Each of these associates memory address values with corresponding
labeled entry names.

It is important to note that some addresses do not have have labeled names.
In the case of operating parameters, these addresses should NOT be set.
In the case of housekeeping channels, these addresses should be ignored.

Below we can see counts of how many unused parameters/channels there are.

>>> len([x for x in operating_parameter_memory_map if x == None])
49
>>> len([x for x in housekeeping_channel_memory_map if x == None])
6

Specifically, the unused housekeeping channels are:

>>> [i for (i,x) in enumerate(housekeeping_channel_memory_map) if x == None]
[99, 100, 101, 102, 103, 104]
"""

from data.operating_parameters import \
    operating_parameters, \
    operating_parameter_memory_map

from data.housekeeping_channels import \
    housekeeping_channels, \
    housekeeping_channel_memory_map

if __name__ == "__main__":
    import doctest
    doctest.testmod()
