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
        add_hsk_units
    return add_hsk_units(hsk_to_analogue_dictionary(hsk))


digital_dictionary_keywords = ["hsk_time_conv",
                               "hsk_time_btn_samples",
                               "hsk_total_samples",
                               "hsk_samples_per_frame",
                               "charge_pump_ena",
                               "force_status",
                               "prg_fs_ptr",
                               "test_mode",
                               "frames_xmt",
                               "hsk_sbit_err_cnt",
                               "seq_sbit_err_cnt",
                               "cmd_sbit_err_cnt",
                               "leds_off",
                               "version"]


def hsk_to_digital_dictionary(hsk):
    return dict(zip(digital_dictionary_keywords, hsk))


if __name__ == "__main__":
    import doctest

    doctest.testmod()
