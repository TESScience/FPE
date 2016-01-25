#!/usr/bin/env python2.7
"""The housekeeping identity map, padded with enough zeros to fill
the 512 bytes."""

from operator import add

identity_map = map(add,
                   range(0, 128) + 384 * [0],
                   64 * [0] + 32 * [0x80] + 8 * [0] + 8 * [0x80] + 16 * [0] + 384 * [0])


def rescale_value(v, bits, high=None, low=None):
    """Rescale a voltage value represented by a number of bits from a DAC, given high and low values.
       >>> rescale_value(123, 16, -27, 27)
       -0.101348876953125
    """
    return ((v + 2 ** (bits - 1)) / float(1 << bits)) * (high - low) + low


def unscale_value(v, bits, high=None, low=None):
    """Unscales a rescaled DAC value to its original voltage.

    This obeys the following simple law:
       >>> from random import random
       >>> x = random()
       >>> x == rescale_value(unscale_value(x, 16, high=0, low=1), 16, high=0, low=1)
       True
    """
    return (v - low) / (high - low) * float(1 << bits) - 2 ** (bits - 1)


def unpack_pair(p):
    return p >> 16, p & 0xFFFF


def to_signed_integer(i):
    if i >= 2 ** 15:
        return i - 2 ** 16
    else:
        return i


def hsk_to_analogue_dictionary(hsk):
    from ..data.housekeeping_channels import \
        housekeeping_channel_memory_map, \
        housekeeping_channels
    return {k: rescale_value(v, 16,
                             low=housekeeping_channels[k]["low"],
                             high=housekeeping_channels[k]["high"])
            for k, v in
            zip(housekeeping_channel_memory_map,
                [to_signed_integer(k)
                 for i in range(0, 128, 32)
                 for j in hsk[1 + i:17 + i]
                 for k in unpack_pair(j)])}

def hsk_to_analogue_dictionary_with_units(hsk):
    from ..data.housekeeping_channels import \
        housekeeping_channels
    return {k: "{0} {1}".format(v, housekeeping_channels[k]["unit"])
            for k,v in hsk_to_analogue_dictionary(hsk).iteritems()}
    

if __name__ == "__main__":
    import doctest
    doctest.testmod()
