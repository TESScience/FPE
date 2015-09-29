#!/usr/bin/env python
"""
This module contains object for handling setting operating parameters for the FPE.

Usage
-----

To create an operating parameter object, type (for example):

>>> op = OperatingParameter("ccd4_parallel_low", \
 {"address": 89, "high": -13.2, "low": 0.0, "unit": "V", "default": -5.0})

You can read the supplied info by simply accessing the values like so:

>>> op.name
'ccd4_parallel_low'
>>> op.address
89
>>> op.high
-13.2
>>> op.low
0.0
>>> op.unit
'V'
>>> op.default
-5.0

Every operating parameter has a value, which is set to the specified default value by default.

>>> op.value == op.default
True
>>> op.value
-5.0

When trying to set a parameter, a bounds check is performed.  If the value is set out of bounds, an `Exception` is raised.

>>> op.value = 9
Traceback (most recent call last):
...
Exception: Attempting to set value out of bounds.
value: 9
low: 0.0
high: -13.2

*Note the signs of high and low can be flipped.*

Associated with each set value is a `twelve_bit_value` quantization.

This is an unsigned, 12 bit integer.

Setting an `OperatingParameter`'s `value` to the specified `low` value
makes the `twelve_bit_value` zero:
>>> op.value = op.low
>>> op.twelve_bit_value
0

Setting an `OperatingParameter`'s `value` to the specified `low` value
makes the `twelve_bit_value` equal to `2**12 - 1 == 4095`:
>>> op.value = op.high
>>> op.twelve_bit_value
4095

Symmetrically, the `twelve_bit_value` may be set, and the `value` is adjusted to reflect the change.
>>> op.twelve_bit_value = 0
>>> op.value == op.low
True

The values set are only approximate; they can only match the declared high and low values up to an epsilon tolerance:
>>> op.twelve_bit_value = 0xFFF
>>> abs(op.value - op.high) < 0.01
True

"""

import collections

OperatingParameterInfo = \
    collections.namedtuple('OperatingParameterInfo',
                           ['name', 'address', 'high', 'low', 'unit', 'default'])


class OperatingParameter(object):
    """An operating parameter object for the FPE Data Handling Unit (DHU) object"""

    def __init__(self, name, info):
        self._info = OperatingParameterInfo(name=name, **info)
        self._twelve_bit_value = None
        self._value = None
        self.value = self._info.default

    # Delegation Pattern https://en.wikipedia.org/wiki/Delegation_pattern
    @property
    def name(self):
        """The name of the parameter"""
        return self._info.name

    @property
    def address(self):
        """The address of the parameter"""
        return self._info.address

    @property
    def high(self):
        """The high value of the parameter"""
        return self._info.high

    @property
    def low(self):
        """The low value of the parameter"""
        return self._info.low

    @property
    def unit(self):
        """The units of the parameter"""
        return self._info.unit

    @property
    def default(self):
        """The default value of the parameter"""
        return self._info.default

    # Set the value, do bounds checks
    @property
    def value(self):
        """The value of the operating parameter"""
        return self._value

    @value.setter
    def value(self, x):
        actual_low = self.low
        actual_high = self.high
        if actual_high <= actual_low:
            (actual_low, actual_high) = (actual_high, actual_low)
        if not (actual_low <= x <= actual_high):
            raise Exception("Attempting to set value out of bounds.\n"
                            + "value: {}\n".format(x)
                            + "low: {}\n".format(self.low)
                            + "high: {}".format(self.high))
        self._value = x
        self._twelve_bit_value = int((x - self.low) / float(self.high - self.low) * (2 ** 12 - 1))

    @property
    def twelve_bit_value(self):
        """The value of the operating parameter as a 12 bit unsigned integer"""
        return self._twelve_bit_value

    @twelve_bit_value.setter
    def twelve_bit_value(self, x):
        if not (type(x) is int and 0 <= x < 2 ** 12):
            raise Exception(
                "Attempting to set 12 bit unsigned integer value that is either not an integer or out of bounds.\n"
                + "value: {}\n".format(x)
                + "low: {}\n".format(self.low)
                + "high: {}".format(self.high))
        self._twelve_bit_value = x
        self._value = (self.high - self.low) / float(2 ** 12) * x + self.low


import binary_files
from ..data.operating_parameters import operating_parameters
from ops import OperatingParameter


def values_to_5328(values):
    """Convert the value list to AD5328 codes.
       The value list is ordered by (chip address)(address within the chip).
       Each group of 8 values goes to a single chip.
       The address within the chip must appear as bits 14 through 12 of the
       code sent to the DAC. Bit 15 must be zero.
       Assuming that values is a list of 128 integers in the range 0-4095,
       ordered as above, this expression tags on the necessary bits."""
    for v in values:
        if not (type(v) is int and (0 <= v < 2 ** 12)):
            raise Exception("Value must be a unsigned 12 bit integer, was: {}".format(v))
    if len(values) != 128:
        raise Exception("Should have 128 values, had: {}".format(len(values)))
    return map(lambda x, y: x + y, list(values), 16 * range(0, 8 * 4096, 4096))


class OperatingParameters(object):
    def __init__(self, fpe=None):
        # The underscore here is used as sloppy "private" memory
        self._fpe = fpe
        self.address = 128 * [None]
        self._keys = operating_parameters.keys()
        for (name, data) in operating_parameters.iteritems():
            self._keys.append(name)
            op = OperatingParameter(name, data)
            super(OperatingParameters, self).__setattr__(name, op)
            self.address[op.address] = op

    def __getitem__(self, item):
        if item in self._keys:
            return self.__dict__[item]
        else:
            raise KeyError(item)

    def __setattr__(self, name, value):
        if "_keys" in self.__dict__ and name in self._keys:
            self.__dict__[name].value = value
        else:
            super(OperatingParameters, self).__setattr__(name, value)

    @property
    def values(self):
        """The 12-bit unsigned values of the operating parameters"""
        return [0 if x is None else x.twelve_bit_value
                for x in self.address]

    def send(self):
        """Send the current DAC values to the hardware."""
        return self._fpe.upload_operating_parameter_memory(
            binary_files.write_clvmem(values_to_5328(self.values)))

    def upload_operating_parameter_memory(self):
        """Synonym for send"""
        return self.send()

    def dacreset(self):
        """Reset the DACs to the power-up state."""
        return self._fpe.upload_operating_parameter_memory(
            binary_files.write_clvmem(128 * [0xffff]))


if __name__ == "__main__":
    import doctest
    from binary_files import write_clvmem

    doctest.testmod()
    print write_clvmem(values_to_5328(OperatingParameters().values))
