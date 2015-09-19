import binary_files
from ..data.operating_parameters import operating_parameters
from OperatingParameters import OperatingParameter


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
    def __init__(self, fpe):
        # The underscore here is used as sloppy "private" memory
        self._fpe = fpe
        self.address = 128 * [None]
        for (name, data) in operating_parameters.iteritems():
            op = OperatingParameter(name, data)
            setattr(self, name, op)
            self.address[op.address] = op

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
    from binary_files import write_clvmem

    print write_clvmem(values_to_5328(OperatingParameters(None).values))
