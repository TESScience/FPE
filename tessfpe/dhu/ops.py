#!/usr/bin/env python2.7
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

One can also create a *collection* of operating parameters, like so:

>>> ops = OperatingParameters()

This object has two important attributes: `defaults` and `values`

These attributes are maps which have the same keys.

>>> ops.defaults.keys() == ops.values.keys()
True

Provided that `/tmp/operator_parameter_settings.json` does not exist, these attributes should be equal

>>> import os
>>> os.path.isfile('/tmp/operator_parameter_settings.json') or ops.defaults == ops.values
True

Operating parameters controlled by this object can be accessed two different ways:
  - You can use `ops.address` to set an operating parameter at a particular address
  - You can use `ops.<name>` to set an operating parameter with a particular name

>>> ops.address[50].name
'ccd4_input_gate_2'
>>> ops.ccd4_input_gate_2 = -5.0
>>> ops.address[50].value
-5.0

TODO: talk about derived parameters

"""

import collections
import binary_files

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


class DerivedOperatingParameter(object):
    """An operating parameter object that is derived from two operating parameter objects"""

    def __init__(self, base, offset):
        self._base = base
        self._offset = offset

    @property
    def default(self):
        return self._base.default + self._offset.default

    @property
    def value(self):
        return self._base.value + self._offset.value

    @value.setter
    def value(self, x):
        self._offset.value = x - self._base.value



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

fpe_operating_parameter_settings_file = '/tmp/operating_parameter_settings.json'

class OperatingParameters(object):
    def __init__(self, fpe=None):
        import re
        from ..data.operating_parameters import default_operating_parameters
        import os
        import json
        # The underscore here is used as sloppy "private" memory
        self._fpe = fpe
        self.address = 128 * [None]
        self._operating_parameters = {}

        # Set ordinary Operating Parameters
        for (name, data) in default_operating_parameters.iteritems():
            op = OperatingParameter(name, data)
            self.address[op.address] = op
            self._operating_parameters[name] = op

        # Set Derived Operating Parameters
        self._derived_operating_parameters = {}
        for name in default_operating_parameters:
            if 'offset' in name:
                offset_name = name
                derived_parameter_name = name.replace('_offset', '')
                if 'low' in derived_parameter_name:
                    base_name = derived_parameter_name.replace('low', 'high')
                    self._derived_operating_parameters[derived_parameter_name] = \
                        DerivedOperatingParameter(self[base_name], self[offset_name])
                if 'high' in derived_parameter_name:
                    base_name = derived_parameter_name.replace('high', 'low')
                    self._derived_operating_parameters[derived_parameter_name] = \
                        DerivedOperatingParameter(self[base_name], self[offset_name])
                if 'output_drain' in derived_parameter_name:
                    base_name = re.sub(r'output_drain_._offset$', 'reset_drain', offset_name)
                    self._derived_operating_parameters[derived_parameter_name] = \
                        DerivedOperatingParameter(self[base_name],
                                                  self[offset_name])
                super(OperatingParameters, self).__setattr__(
                    derived_parameter_name,
                    self._derived_operating_parameters[derived_parameter_name])

        # If we have already previously loaded our parameter settings to the fpe, load those values from file
        if os.path.isfile(fpe_operating_parameter_settings_file):
            with open(fpe_operating_parameter_settings_file) as data_file:
                for k,v in json.load(data_file).iteritems():
                    # Avoid derived parameters since they will be derived from ordinary operating parameters
                    if k in self._operating_parameters:
                       self[k].value = v

    def keys(self):
        return self._operating_parameters.keys() + self._derived_operating_parameters.keys()

    @property
    def defaults(self):
        return {k: self[k].default for k in self.keys()}

    @property
    def values(self):
        return {k: self[k].value for k in self.keys()}

    def __getitem__(self, item):
        if item in self._operating_parameters:
            return self._operating_parameters[item]
        elif item in self._derived_operating_parameters:
            return self._derived_operating_parameters[item]
        else:
            return super(OperatingParameters, self).__getitem__(item)

    # TODO: getattr?

    def __setattr__(self, name, value):
        if "_operating_parameters" in self.__dict__ and \
           name in self._operating_parameters:
            self._operating_parameters[name].value = value
        elif "_derived_operating_parameters" in self.__dict__ and \
                        name in self._derived_operating_parameters:
            self._derived_operating_parameters[name].value = value
        else:
            super(OperatingParameters, self).__setattr__(name, value)

    @property
    def raw_values(self):
        """The 12-bit unsigned values of the operating parameters"""
        return [0 if x is None else x.twelve_bit_value
                for x in self.address]

    def send(self):
        """Send the current DAC values to the hardware."""
        import json
        with open(fpe_operating_parameter_settings_file, 'w') as outfile:
            json.dump(self.values, outfile, sort_keys=True, indent=4)

        # Get the frames status, restore it after we are done uploading the operating parameters
        frames_status = self._fpe.frames_running_status
        self._fpe.cmd_stop_frames()
        try:
            return self._fpe.upload_operating_parameter_memory(
                   binary_files.write_clvmem(values_to_5328(self.raw_values)))
        finally:
            self._fpe.frames_running_status = frames_status

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
    print write_clvmem(values_to_5328(OperatingParameters().raw_values))
