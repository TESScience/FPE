import binary_files


def values_to_5328(values):
    """Convert the value list to AD5328 codes.
       The value list is ordered by (chip address)(address within the chip).
       Each group of 8 values goes to a single chip.
       The address within the chip must appear as bits 14 through 12 of the
       code sent to the DAC. Bit 15 must be zero.
       Assuming that values is a list of 128 integers in the range 0-4095,
       ordered as above, this expression tags on the necessary bits."""
    for v in values:
        if not (type(v) is int and (0 <= v < 2**12)):
            raise Exception("Value must be a unsigned 12 bit integer, was: {}".format(v))
    return map(lambda x,y: x+y, list(values), 16 * range(0, 8 * 4096, 4096))

class OperatingParameters(object):

    def __init__(self, ops_list):
        # The underscore here is used as sloppy "private" memory
        self._ops_list = ops_list

    def send(self):
        """Send the current DAC values to the hardware."""
        binary_files.write_clvmem(values_to_5328(x.twelve_bit_value for x in self._ops_list))
        self.upload_operating_parameter_memory()


    def dacreset(self):
        """Reset the DACs to the power-up state."""
        binary_files.write_clvmem(128 * [0xffff])
        self.upload_operating_parameter_memory()
