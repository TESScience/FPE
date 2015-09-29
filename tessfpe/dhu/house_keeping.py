#!/usr/bin/env python
"""The housekeeping identity map, padded with enough zeros to fill
the 512 bytes."""

from operator import add

identity_map = map(add,
                   range(0, 128) + 384 * [0],
                   64 * [0] + 32 * [0x80] + 8 * [0] + 8 * [0x80] + 16 * [0] + 384 * [0])


def rescale_value(v, bits, high=None, low=None):
    return ((v + 2**15) / float(1 << bits)) * (high - low) + low


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


if __name__ == "__main__":
    from sh import od
    from binary_files import write_hskmem

    print od("-A", "x", "-t", "x1", write_hskmem(identity_map))
