__author__ = 'jpd'

"""Make the HK memory the identity map, padded with enough zeros to fill
the 512 bytes."""

bit_data = range(0,128)+384*[0]