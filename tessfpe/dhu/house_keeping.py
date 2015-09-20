#!/usr/bin/env python
"""The housekeeping identity map, padded with enough zeros to fill
the 512 bytes."""

identity_map = range(0, 128) + 384 * [0]

if __name__ == "__main__":
    from sh import od
    from binary_files import write_hskmem

    print od("-A", "x", "-t", "x1", write_hskmem(identity_map))
